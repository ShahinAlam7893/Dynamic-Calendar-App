// lib/ui/one_to_one_conversation_page.dart
import 'dart:convert';
import 'dart:async';
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
  bool _isLoadingMessages = false;
  DateTime? _lastMessageTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('[OneToOneConversationPage] initState: currentUser=${widget.currentUserId} partner=${widget.chatPartnerId} conversationId=${widget.conversationId}');
    _initializeConversation();
    _messageController.addListener(_handleTyping);
    _messageController.addListener(() {
      // Trigger rebuild to update send button state
      if (mounted) setState(() {});
    });
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
      // Don't call _loadMessagesFromServer() since we're using WebSocket for conversation messages
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
      await MessageStorageService.clearMessages(_conversationId!);
    }
  }

  Future<void> _loadMessagesFromServer() async {
    if (_conversationId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) throw Exception('No access token found');

      // Based on the Django URL patterns, the correct endpoint is:
      // /api/chat/messages/{conversation_id}/send/ for sending messages
      // But for fetching messages, we need to check if there's a different endpoint
      // For now, we'll skip server message loading since the endpoint doesn't exist
      // Messages will be loaded via WebSocket instead
      
      debugPrint('[OneToOneConversationPage] Skipping server message loading - endpoint not available');
      debugPrint('[OneToOneConversationPage] Messages will be loaded via WebSocket and local storage');
      
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
          debugPrint('[OneToOneConversationPage] Decoded message: $decoded');
          
          if (decoded['type'] == 'message' && decoded['message'] != null) {
            // Handle message type with nested message object
            _addMessageFromServer(decoded['message']);
          } else if (decoded['type'] == 'new_message') {
            // Handle direct new_message type
            _addMessageFromServer(decoded);
          } else if (decoded['type'] == 'conversation_messages' && decoded['messages'] != null) {
            // Handle conversation_messages type - load multiple messages
            final messages = decoded['messages'] as List;
            debugPrint('[OneToOneConversationPage] Loading ${messages.length} conversation messages');
            _loadConversationMessages(messages);
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
      
      // Request conversation messages from server via WebSocket
      _requestConversationMessages();
    } catch (e) {
      debugPrint('[OneToOneConversationPage] Error connecting WebSocket: $e');
    }
  }

  void _requestConversationMessages() {
    if (_conversationId == null) return;
    try {
      setState(() {
        _isLoadingMessages = true;
      });
      
      final request = {
        'type': 'get_conversation_messages',
        'conversation_id': _conversationId,
      };
      _chatSocketService.sendRawMessage(jsonEncode(request));
      debugPrint('[OneToOneConversationPage] Requested conversation messages');
      
      // Set a timeout to stop loading if no response received
      Timer(const Duration(seconds: 10), () {
        if (mounted && _isLoadingMessages) {
          setState(() {
            _isLoadingMessages = false;
          });
          debugPrint('[OneToOneConversationPage] Conversation messages request timed out');
        }
      });
    } catch (e) {
      debugPrint('[OneToOneConversationPage] Error requesting conversation messages: $e');
      setState(() {
        _isLoadingMessages = false;
      });
    }
  }

  void _loadConversationMessages(List<dynamic> messagesData) async {
    debugPrint('[OneToOneConversationPage] Processing ${messagesData.length} conversation messages');
    
    try {
      final List<StoredMessage> newMessages = [];
      
      for (var msgData in messagesData) {
        try {
          // Handle different API response structures
          final String messageId = msgData['id']?.toString() ?? '';
          final String content = msgData['content']?.toString() ?? '';
          final String timestamp = msgData['timestamp']?.toString() ?? '';
          
          // Handle sender information - API might send sender as object or ID
          String senderId;
          if (msgData['sender'] is Map) {
            senderId = msgData['sender']['id']?.toString() ?? '';
          } else {
            senderId = msgData['sender_id']?.toString() ?? msgData['sender']?.toString() ?? '';
          }
          
          final bool isRead = msgData['is_read'] == true;
          final bool isDelivered = msgData['is_delivered'] == true;
          final String? clientMessageId = msgData['client_message_id']?.toString();
          
          // Parse timestamp safely
          DateTime messageTime;
          try {
            messageTime = DateTime.parse(timestamp);
          } catch (e) {
            debugPrint('[OneToOneConversationPage] Error parsing timestamp: $timestamp, using current time');
            messageTime = DateTime.now();
          }
          
          final message = StoredMessage(
            id: messageId,
            text: content,
            timestamp: messageTime,
            sender: senderId == widget.currentUserId ? MessageSender.user : MessageSender.other,
            senderId: senderId,
            senderImageUrl: senderId == widget.currentUserId ? AppAssets.jennyProfile : AppAssets.sarahMartinez,
            status: isRead ? MessageStatus.seen : isDelivered ? MessageStatus.delivered : MessageStatus.sent,
            clientMessageId: clientMessageId,
          );
          
          newMessages.add(message);
        } catch (e) {
          debugPrint('[OneToOneConversationPage] Error processing message in conversation: $e');
        }
      }
      
      // Sort messages by timestamp
      newMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      // Save to local storage
      await MessageStorageService.saveMessages(_conversationId!, newMessages);
      
      // Update UI
      setState(() {
        _messages.clear();
        _messages.addAll(newMessages);
        if (_messages.isNotEmpty) {
          _lastMessageTime = _messages.last.timestamp;
        }
        _isLoadingMessages = false;
      });
      
      _scrollToBottom();
      debugPrint('[OneToOneConversationPage] Loaded ${newMessages.length} conversation messages');
      
    } catch (e) {
      debugPrint('[OneToOneConversationPage] Error loading conversation messages: $e');
    }
  }

  void _addMessageFromServer(Map<String, dynamic> msgData) async {
    debugPrint('[OneToOneConversationPage] _addMessageFromServer payload: $msgData');
    
    try {
      // Handle different API response structures
      final String messageId = msgData['id']?.toString() ?? '';
      final String content = msgData['content']?.toString() ?? '';
      final String timestamp = msgData['timestamp']?.toString() ?? '';
      
      // Handle sender information - API might send sender as object or ID
      String senderId;
      if (msgData['sender'] is Map) {
        senderId = msgData['sender']['id']?.toString() ?? '';
      } else {
        senderId = msgData['sender_id']?.toString() ?? msgData['sender']?.toString() ?? '';
      }
      
      final bool isRead = msgData['is_read'] == true;
      final bool isDelivered = msgData['is_delivered'] == true;
      final String? clientMessageId = msgData['client_message_id']?.toString();
      
      // Parse timestamp safely
      DateTime messageTime;
      try {
        messageTime = DateTime.parse(timestamp);
      } catch (e) {
        debugPrint('[OneToOneConversationPage] Error parsing timestamp: $timestamp, using current time');
        messageTime = DateTime.now();
      }
      
      final message = StoredMessage(
        id: messageId,
        text: content,
        timestamp: messageTime,
        sender: senderId == widget.currentUserId ? MessageSender.user : MessageSender.other,
        senderId: senderId,
        senderImageUrl: senderId == widget.currentUserId ? AppAssets.jennyProfile : AppAssets.sarahMartinez,
        status: isRead ? MessageStatus.seen : isDelivered ? MessageStatus.delivered : MessageStatus.sent,
        clientMessageId: clientMessageId,
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
    } catch (e) {
      debugPrint('[OneToOneConversationPage] Error processing message from server: $e');
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
      // Send via WebSocket first for real-time delivery
      _chatSocketService.sendMessage(
        message.text,
        widget.chatPartnerId,
        clientMessageId,
      );
      
      // Also send via HTTP API as backup (using the correct endpoint from Django URLs)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token != null) {
        try {
          final url = Uri.parse('http://10.10.13.27:8000/api/chat/messages/$_conversationId/send/');
          final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'content': message.text,
              'receiver_id': widget.chatPartnerId,
              'client_message_id': clientMessageId,
            }),
          );
          debugPrint('[OneToOneConversationPage] HTTP API response: ${response.statusCode}');
        } catch (e) {
          debugPrint('[OneToOneConversationPage] HTTP API error (non-critical): $e');
        }
      }
      
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
                style: TextStyle(color: Colors.white70, fontSize: 14.0),
              ),
          ],
        ),
        actions: [
          // Connection status indicator
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: _chatSocketService.isConnected
                ? const Icon(Icons.wifi, color: Colors.green, size: 20)
                : const Icon(Icons.wifi_off, color: Colors.red, size: 20),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isLoadingMessages
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading conversation...',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : _messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No messages yet. Start the conversation!',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
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
    final bool canSend = _isConversationReady && _messageController.text.trim().isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enabled: _isConversationReady,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: _isConversationReady ? 'Type a message...' : 'Connecting...',
                hintStyle: TextStyle(
                  color: _isConversationReady ? Colors.grey[600] : Colors.grey[400],
                ),
                filled: true,
                fillColor: AppColors.chatInputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              onSubmitted: (_) => canSend ? _sendMessage() : null,
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: BoxDecoration(
              color: canSend ? AppColors.primaryBlue : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: canSend ? _sendMessage : null,
              icon: Icon(
                Icons.send,
                color: canSend ? Colors.white : Colors.grey[600],
                size: 20,
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ),
        ],
      ),
    );
  }
}