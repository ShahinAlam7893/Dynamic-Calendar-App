import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/core/services/message_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/services/group/group_chat_socket_service.dart';
import '../../../../../data/models/group_model.dart';
import '../../../../routes/app_router.dart';

class GroupConversationPage extends StatefulWidget {
  final String groupId;
  final String currentUserId;
  final String groupName;

  const GroupConversationPage({
    super.key,
    required this.groupId,
    required this.currentUserId,
    required this.groupName,

    // Default to false if not provided
  });

  @override
  State<GroupConversationPage> createState() => _GroupConversationPageState();
}

class _GroupConversationPageState extends State<GroupConversationPage>
    with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final List<StoredMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isCurrentUserAdmin = false; // Track if the current user is an admin
  final Uuid _uuid = const Uuid();

  late GroupChatSocketService _groupChatSocketService;

  bool _isLoading = true;
  bool _isConversationReady = false;
  bool _isTyping = false;
  bool _isSomeoneTyping = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _groupChatSocketService = GroupChatSocketService(
      onMessageReceived: _handleIncomingMessage,
    );

    _initializeConversation();
    _checkIfAdmin();
    _messageController.addListener(_handleTyping);
  }

  Future<void> _initializeConversation() async {
    setState(() => _isLoading = true);

    await _loadMessagesFromLocal();
    await _connectWebSocket();

    setState(() {
      _isConversationReady = true;
      _isLoading = false;
    });
  }

  Future<void> _checkIfAdmin() async {
    // Example API call or local logic
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('userRole'); // or API result
    setState(() {
      _isCurrentUserAdmin = role == 'admin';
    });
  }

  Future<void> _loadMessagesFromLocal() async {
    try {
      final messages = await MessageStorageService.loadMessages(widget.groupId);
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint('Error loading local messages: $e');
      await MessageStorageService.clearMessages(widget.groupId);
    }
  }

  Future<void> _connectWebSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      debugPrint('[GroupConversationPage] No token found!');
      return;
    }

    try {
      await _groupChatSocketService.connect(widget.groupId, token);
      debugPrint('[GroupConversationPage] WebSocket connected');
    } catch (e) {
      debugPrint('[GroupConversationPage] WebSocket connection failed: $e');
    }
  }

  void _handleIncomingMessage(Message message) async {
    final storedMessage = StoredMessage(
      id: message.id,
      text: message.content,
      timestamp: DateTime.parse(message.timestamp),
      senderId: message.senderId,
      sender: message.senderId == widget.currentUserId
          ? MessageSender.user
          : MessageSender.other,
      senderImageUrl: message.senderId == widget.currentUserId
          ? AppAssets.jennyProfile
          : AppAssets.sarahMartinez,
      status: MessageStatus.seen,
      clientMessageId: null,
    );

    await MessageStorageService.addMessage(widget.groupId, storedMessage);

    setState(() {
      _messages.add(storedMessage);
      _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });
    _scrollToBottom();
  }

  void _handleTyping() {
    // You can implement typing indicator here if you want
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final clientMessageId = _uuid.v4();

    final message = StoredMessage(
      id: clientMessageId,
      text: text,
      timestamp: DateTime.now(),
      sender: MessageSender.user,
      senderId: widget.currentUserId,
      senderImageUrl: AppAssets.jennyProfile,
      status: MessageStatus.sending,
      clientMessageId: clientMessageId,
    );

    setState(() {
      _messages.add(message);
      _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });
    _scrollToBottom();
    _messageController.clear();

    await MessageStorageService.addMessage(widget.groupId, message);

    try {
      _groupChatSocketService.sendMessage(
        widget.groupId,
        widget.currentUserId,
        text,
      );
      await MessageStorageService.updateMessageStatus(
        widget.groupId,
        message.id,
        MessageStatus.sent,
        clientMessageId: clientMessageId,
      );
    } catch (e) {
      debugPrint('Failed to send message: $e');
      await MessageStorageService.updateMessageStatus(
        widget.groupId,
        message.id,
        MessageStatus.failed,
        clientMessageId: clientMessageId,
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _groupChatSocketService.disconnect();
    _messageController.removeListener(_handleTyping);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.groupName, // Display group name here
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_isSomeoneTyping)
              const Text(
                'Someone is typing...',
                style: TextStyle(color: Colors.white70, fontSize: 12.0),
              ),
          ],
        ),
        centerTitle: false,
        actions: [
          if (_isCurrentUserAdmin)
            IconButton(
              icon: const Icon(Icons.manage_accounts, color: Colors.white),
              tooltip: 'Group Manager',
              onPressed: () {
                debugPrint("PRINT groupId: ${widget.groupId}");
                debugPrint("PRINT conversationId: ${widget.groupId}");
                context.push(
                  RoutePaths.groupManagement,
                  extra: {
                    'groupId': widget.groupId,
                    'conversationId': widget.groupId,
                    'currentUserId': widget.currentUserId,
                  },
                );
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                ? const Center(
                    child: Text(
                      'No messages yet. Start the conversation!',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) =>
                        _buildMessageBubble(_messages[index]),
                  ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(StoredMessage message) {
    final bool isUser = message.sender == MessageSender.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isUser)
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage(
                      message.senderImageUrl ?? AppAssets.sarahMartinez,
                    ),
                  ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.receiverBubbleColor
                          : AppColors.senderBubbleColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                if (isUser) const SizedBox(width: 8.0),
                if (isUser)
                  Row(
                    children: [
                      _buildMessageStatusIcon(message.status),
                      const SizedBox(width: 4.0),
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage(
                          message.senderImageUrl ?? AppAssets.jennyProfile,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              DateFormat('h:mm a').format(message.timestamp),
              style: const TextStyle(fontSize: 10.0, color: Color(0x991A1A1A)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return const Icon(Icons.access_time, size: 12, color: Colors.grey);
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 12, color: Colors.grey);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 12, color: Colors.grey);
      case MessageStatus.seen:
        return const Icon(Icons.done_all, size: 12, color: Colors.blue);
      case MessageStatus.failed:
        return const Icon(Icons.error_outline, size: 12, color: Colors.red);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enabled: _isConversationReady,
              decoration: InputDecoration(
                hintText: 'Type a message',
                filled: true,
                fillColor: AppColors.chatInputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _isConversationReady ? _sendMessage() : null,
            ),
          ),
          const SizedBox(width: 8.0),
          GestureDetector(
            onTap: _isConversationReady ? _sendMessage : null,
            child: Icon(
              Icons.send,
              color: _isConversationReady
                  ? AppColors.primaryBlue
                  : AppColors.buttonPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
