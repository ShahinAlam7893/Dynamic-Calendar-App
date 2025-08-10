// lib/ui/one_to_one_conversation_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/core/services/conversation_manager.dart';
import 'package:circleslate/core/services/websocket_service.dart';
import 'package:circleslate/core/services/message_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class OneToOneConversationPage extends StatefulWidget {
  final String chatPartnerName;
  final String currentUserId;
  final String chatPartnerId;
  final String? conversationId;

  const OneToOneConversationPage({
    super.key,
    required this.chatPartnerName,
    required this.currentUserId,
    required this.chatPartnerId,
    this.conversationId,
  });

  @override
  State<OneToOneConversationPage> createState() => _OneToOneConversationPageState();
}

class _OneToOneConversationPageState extends State<OneToOneConversationPage> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final List<StoredMessage> _messages = [];
  final ChatSocketService _chatSocketService = ChatSocketService();
  final ScrollController _scrollController = ScrollController();
  final Uuid _uuid = const Uuid();

  String? _conversationId;
  bool _isLoading = true;
  bool _isConversationReady = false;
  bool _isTyping = false;
  bool _isPartnerTyping = false;
  DateTime? _lastMessageTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('[OneToOneConversationPage] initState: currentUser=${widget.currentUserId} partner=${widget.chatPartnerId} conversationId=${widget.conversationId}');
    _initializeConversation();
    _messageController.addListener(_handleTyping);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('[OneToOneConversationPage] App resumed - reconnecting socket & marking read');
      _chatSocketService.reconnect();
      _markMessagesAsRead();
    } else if (state == AppLifecycleState.paused) {
      debugPrint('[OneToOneConversationPage] App paused - sending typing=false');
      _chatSocketService.sendTypingIndicator(widget.chatPartnerId, false, isGroup: false);
    }
  }

  Future<void> _initializeConversation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.conversationId != null && widget.conversationId!.isNotEmpty) {
        _conversationId = widget.conversationId;
        debugPrint('[OneToOneConversationPage] Using passed conversationId: $_conversationId');
      } else {
        final conversationData = await ConversationManager.getOrCreateConversation(
          widget.currentUserId,
          widget.chatPartnerId,
          partnerName: widget.chatPartnerName,
        );
        debugPrint('[OneToOneConversationPage] Conversation data: $conversationData');
        _conversationId = conversationData['conversation']['id'].toString();
      }

      if (_conversationId == null || _conversationId!.isEmpty) {
        throw Exception('Conversation ID is empty after initialization');
      }

      setState(() {
        _isConversationReady = true;
      });

      await _loadMessagesFromLocal();
      await _connectWebSocket();
      await _loadMessagesFromServer();
      await _sendPendingMessages();

      setState(() {
        _isLoading = false;
      });
      debugPrint('[OneToOneConversationPage] Initialization complete for conversation $_conversationId');
    } catch (e, st) {
      debugPrint('[OneToOneConversationPage] Error initializing conversation: $e\n$st');
      setState(() {
        _isLoading = false;
        _isConversationReady = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize conversation: $e')),
      );
    }
  }


  Future<void> _loadMessagesFromLocal() async {
    if (_conversationId == null) return;
    try {
      debugPrint('[OneToOneConversationPage] Loading messages from local for $_conversationId');
      final messages = await MessageStorageService.loadMessages(_conversationId!);
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
        if (_messages.isNotEmpty) {
          _lastMessageTime = _messages.last.timestamp;
        }
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint('[OneToOneConversationPage] Error loading messages from local storage: $e');
      // Clear potentially corrupt local storage data
      await MessageStorageService.clearMessages(_conversationId!);
    }
  }

  Future<void> _loadMessagesFromServer() async {
    if (_conversationId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) throw Exception('No access token found');

      final url = Uri.parse('http://10.10.13.27:8000/api/chat/conversations/$_conversationId/messages/');
      debugPrint('[OneToOneConversationPage] Fetching server messages from $url');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('[OneToOneConversationPage] loadMessagesFromServer -> ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final messages = (data['messages'] as List).map((msg) {
          return StoredMessage(
            id: msg['id'].toString(),
            text: msg['content'],
            timestamp: DateTime.parse(msg['timestamp']),
            sender: msg['sender_id'].toString() == widget.currentUserId ? MessageSender.user : MessageSender.other,
            senderId: msg['sender_id'].toString(),
            senderImageUrl: msg['sender_id'].toString() == widget.currentUserId ? AppAssets.jennyProfile : AppAssets.sarahMartinez,
            status: msg['is_read'] ? MessageStatus.seen : msg['is_delivered'] ? MessageStatus.delivered : MessageStatus.sent,
            clientMessageId: msg['client_message_id'],
          );
        }).toList();

        await MessageStorageService.saveMessages(_conversationId!, messages);
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
          if (_messages.isNotEmpty) {
            _lastMessageTime = _messages.last.timestamp;
          }
        });
        _scrollToBottom();
        debugPrint('[OneToOneConversationPage] Loaded ${messages.length} messages from server');
      } else {
        debugPrint('[OneToOneConversationPage] No messages loaded from server (status ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('[OneToOneConversationPage] Error loading messages from server: $e');
    }
  }

  Future<void> _sendPendingMessages() async {
    if (_conversationId == null) return;
    final pendingMessages = await MessageStorageService.getPendingMessages(_conversationId!);
    debugPrint('[OneToOneConversationPage] Found ${pendingMessages.length} pending messages to send');
    for (var message in pendingMessages) {
      try {
        _chatSocketService.sendMessage(
          message.text,
          widget.chatPartnerId,
          message.clientMessageId,
        );
        await MessageStorageService.updateMessageStatus(
          _conversationId!,
          message.id,
          MessageStatus.sent,
          clientMessageId: message.clientMessageId,
        );
        debugPrint('[OneToOneConversationPage] Pending message sent (client:${message.clientMessageId})');
      } catch (e) {
        debugPrint('[OneToOneConversationPage] Error sending pending message: $e');
        await MessageStorageService.updateMessageStatus(
          _conversationId!,
          message.id,
          MessageStatus.failed,
          clientMessageId: message.clientMessageId,
        );
      }
    }
    await _loadMessagesFromLocal();
  }

  Future<void> _connectWebSocket() async {
    if (_conversationId == null) return;
    try {
      debugPrint('[OneToOneConversationPage] Connecting WebSocket for conversation $_conversationId');
      await _chatSocketService.connect(_conversationId!);

      _chatSocketService.connectionStatus.listen((isConnected) {
        debugPrint('[OneToOneConversationPage] WebSocket connection status: $isConnected');
        setState(() {});
      }, onError: (e) {
        debugPrint('[OneToOneConversationPage] connectionStatus stream error: $e');
      });

      _chatSocketService.messages.listen((data) {
        debugPrint('[OneToOneConversationPage] Received socket message: $data');
        try {
          final decoded = jsonDecode(data);
          if (decoded['type'] == 'new_message' || decoded['message'] != null) {
            _addMessageFromServer(decoded['message'] ?? decoded);
          } else if (decoded['type'] == 'typing_indicator') {
            setState(() {
              _isPartnerTyping = decoded['is_typing'] == true;
            });
          } else if (decoded['type'] == 'mark_as_read') {
            _updateMessageStatuses(List<String>.from(decoded['message_ids'] ?? []), MessageStatus.seen);
          } else {
            debugPrint('[OneToOneConversationPage] Unknown socket message type: ${decoded['type']}');
          }
        } catch (e) {
          debugPrint('[OneToOneConversationPage] Error decoding socket message: $e');
        }
      }, onError: (err) {
        debugPrint('[OneToOneConversationPage] messages stream error: $err');
      });

      _markMessagesAsRead();
    } catch (e) {
      debugPrint('[OneToOneConversationPage] Error connecting WebSocket: $e');
    }
  }

  void _addMessageFromServer(Map<String, dynamic> msgData) async {
    debugPrint('[OneToOneConversationPage] _addMessageFromServer payload: $msgData');
    final message = StoredMessage(
      id: msgData['id'].toString(),
      text: msgData['content'],
      timestamp: DateTime.parse(msgData['timestamp']),
      sender: msgData['sender_id'].toString() == widget.currentUserId ? MessageSender.user : MessageSender.other,
      senderId: msgData['sender_id'].toString(),
      senderImageUrl: msgData['sender_id'].toString() == widget.currentUserId ? AppAssets.jennyProfile : AppAssets.sarahMartinez,
      status: msgData['is_read'] ? MessageStatus.seen : msgData['is_delivered'] ? MessageStatus.delivered : MessageStatus.sent,
      clientMessageId: msgData['client_message_id'],
    );

    await MessageStorageService.replaceTemporaryMessage(
      _conversationId!,
      message.clientMessageId ?? '',
      message,
    );

    setState(() {
      _messages.removeWhere((m) => m.clientMessageId == message.clientMessageId);
      _messages.add(message);
      _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      _lastMessageTime = _messages.last.timestamp;
    });

    _scrollToBottom();

    if (message.sender == MessageSender.other) {
      _markMessagesAsRead();
    }
  }

  void _updateMessageStatuses(List<String> messageIds, MessageStatus status) async {
    debugPrint('[OneToOneConversationPage] updating ${messageIds.length} message statuses => $status');
    for (var messageId in messageIds) {
      await MessageStorageService.updateMessageStatus(_conversationId!, messageId, status);
    }
    await _loadMessagesFromLocal();
  }

  void _markMessagesAsRead() async {
    if (_conversationId == null) return;
    final unreadMessages = _messages
        .where((msg) =>
    msg.sender == MessageSender.other &&
        (msg.status == MessageStatus.sent || msg.status == MessageStatus.delivered))
        .map((msg) => msg.id)
        .toList();
    if (unreadMessages.isNotEmpty) {
      debugPrint('[OneToOneConversationPage] Marking ${unreadMessages.length} messages as read');
      _chatSocketService.markAsRead(unreadMessages);
      _updateMessageStatuses(unreadMessages, MessageStatus.seen);
    }
  }

  void _handleTyping() {
    final isTypingNow = _messageController.text.isNotEmpty;
    if (isTypingNow != _isTyping) {
      _isTyping = isTypingNow;
      debugPrint('[OneToOneConversationPage] Typing changed: $_isTyping');
      _chatSocketService.sendTypingIndicator(widget.chatPartnerId, _isTyping, isGroup: false);
    }
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _conversationId == null) return;

    final clientMessageId = _uuid.v4();
    final message = StoredMessage(
      id: clientMessageId,
      text: _messageController.text.trim(),
      timestamp: DateTime.now(),
      sender: MessageSender.user,
      senderId: widget.currentUserId,
      senderImageUrl: AppAssets.jennyProfile,
      status: MessageStatus.sending,
      clientMessageId: clientMessageId,
    );

    debugPrint('[OneToOneConversationPage] Sending message locally (client:$clientMessageId): ${message.text}');
    setState(() {
      _messages.add(message);
      _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      _lastMessageTime = _messages.last.timestamp;
    });
    _scrollToBottom();
    _messageController.clear();

    await MessageStorageService.addMessage(_conversationId!, message);

    try {
      _chatSocketService.sendMessage(
        message.text,
        widget.chatPartnerId,
        clientMessageId,
      );
      await MessageStorageService.updateMessageStatus(
        _conversationId!,
        message.id,
        MessageStatus.sent,
        clientMessageId: clientMessageId,
      );
      debugPrint('[OneToOneConversationPage] Message sent via socket (client:$clientMessageId)');
    } catch (e) {
      debugPrint('[OneToOneConversationPage] Error sending message: $e');
      await MessageStorageService.updateMessageStatus(
        _conversationId!,
        message.id,
        MessageStatus.failed,
        clientMessageId: clientMessageId,
      );
    }
    await _loadMessagesFromLocal();
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
    _messageController.removeListener(_handleTyping);
    _messageController.dispose();
    _chatSocketService.dispose();
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
              widget.chatPartnerName,
              style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            if (_isPartnerTyping)
              const Text(
                'Typing...',
                style: TextStyle(color: Colors.white70, fontSize: 12.0),
              ),
          ],
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _chatSocketService.isConnected ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
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
              itemBuilder: (context, index) => _buildMessageBubble(_messages[index]),
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
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isUser)
                  CircleAvatar(radius: 16, backgroundImage: AssetImage(message.senderImageUrl ?? AppAssets.sarahMartinez)),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.receiverBubbleColor : AppColors.senderBubbleColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message.text,
                      style: const TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
                if (isUser) const SizedBox(width: 8.0),
                if (isUser)
                  Row(
                    children: [
                      _buildMessageStatusIcon(message.status),
                      const SizedBox(width: 4.0),
                      CircleAvatar(radius: 16, backgroundImage: AssetImage(message.senderImageUrl ?? AppAssets.jennyProfile)),
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
              color: _isConversationReady ? AppColors.primaryBlue : AppColors.buttonPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
