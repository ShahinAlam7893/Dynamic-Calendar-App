// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// import '../../../data/models/group_model.dart';
//
// class GroupChatSocketService {
//   WebSocketChannel? _channel;
//   final String baseWsUrl = 'ws://10.10.13.27:8000/ws/chat/';
//   final Function(Message) onMessageReceived;
//
//   // Add a connection status controller
//   final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
//
//   Stream<bool> get connectionStatusStream => _connectionStatusController.stream;
//   bool _isConnected = false;
//
//   bool get isConnected => _isConnected;
//
//   GroupChatSocketService({required this.onMessageReceived});
//
//   Future<void> connect(String conversationId, String token) async {
//     try {
//       final wsUrl = '$baseWsUrl$conversationId/?token=$token';
//       debugPrint('[GroupChatSocketService] Connecting to WebSocket: $wsUrl');
//       debugPrint('conversation ID: $conversationId');
//       _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
//       _isConnected = true;
//       _connectionStatusController.add(true);
//
//       _channel!.stream.listen(
//             (data) {
//           final message = jsonDecode(data);
//           debugPrint('[GroupChatSocketService] Received message: $message');
//
//           onMessageReceived(Message.fromJson(message));
//         },
//         onError: (error) {
//           debugPrint('[GroupChatSocketService] WebSocket error: $error');
//           _isConnected = false;
//           _connectionStatusController.add(false);
//         },
//         onDone: () {
//           debugPrint('[GroupChatSocketService] WebSocket connection closed');
//           _isConnected = false;
//           _connectionStatusController.add(false);
//         },
//       );
//     } catch (e) {
//       debugPrint('[GroupChatSocketService] Error connecting to WebSocket: $e');
//       _isConnected = false;
//       _connectionStatusController.add(false);
//       rethrow;
//     }
//   }
//
//   void sendMessage(String conversationId, String senderId, String content) {
//     if (_channel == null) {
//       debugPrint('[GroupChatSocketService] WebSocket not connected');
//       return;
//     }
//     final message = {
//       'conversation_id': conversationId,
//       'sender_id': senderId,
//       'content': content,
//       'message_type': 'text',
//     };
//     debugPrint('[GroupChatSocketService] Sending message: $message');
//     debugPrint('conversatiogfdfn ID: $conversationId');
//
//     _channel!.sink.add(jsonEncode(message));
//   }
//
//   void disconnect() {
//     _channel?.sink.close();
//     _channel = null;
//     _isConnected = false;
//     _connectionStatusController.add(false);
//
//
//
//     debugPrint('[GroupChatSocketService] WebSocket disconnected');
//   }
//
//   void dispose() {
//     _connectionStatusController.close();
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../data/models/group_model.dart';

class GroupChatSocketService {
  WebSocketChannel? _channel;
  final String baseWsUrl = 'ws://10.10.13.27:8000/ws/chat/';
  final Function(Message) onMessageReceived;
  final Function(bool)? onTypingReceived; // Added for typing indicators

  // Connection status controller
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  GroupChatSocketService({required this.onMessageReceived, this.onTypingReceived});

  Future<void> connect(String conversationId, String token) async {
    try {
      final wsUrl = '$baseWsUrl$conversationId/?token=$token';
      debugPrint('[GroupChatSocketService] Connecting to WebSocket: $wsUrl');
      debugPrint('conversation ID: $conversationId');
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _isConnected = true;
      _connectionStatusController.add(true);

      _channel!.stream.listen(
        _handleMessage,
        onError: (error) {
          debugPrint('[GroupChatSocketService] WebSocket error: $error');
          _isConnected = false;
          _connectionStatusController.add(false);
        },
        onDone: () {
          debugPrint('[GroupChatSocketService] WebSocket connection closed');
          _isConnected = false;
          _connectionStatusController.add(false);
        },
      );
    } catch (e) {
      debugPrint('[GroupChatSocketService] Error connecting to WebSocket: $e');
      _isConnected = false;
      _connectionStatusController.add(false);
      rethrow;
    }
  }

  Future<void> connectWithRetry(String conversationId, String token, {int maxRetries = 3, Duration retryDelay = const Duration(seconds: 2)}) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        await connect(conversationId, token);
        debugPrint('[GroupChatSocketService] Connected successfully on attempt ${attempts + 1}');
        return;
      } catch (e) {
        attempts++;
        debugPrint('[GroupChatSocketService] Retry $attempts/$maxRetries after error: $e');
        if (attempts == maxRetries) {
          debugPrint('[GroupChatSocketService] Max retries reached, giving up');
          throw e;
        }
        await Future.delayed(retryDelay);
      }
    }
  }

  void _handleMessage(dynamic data) {
    debugPrint('[GroupChatSocketService] Raw message received: $data');
    try {
      final decoded = jsonDecode(data);
      debugPrint('[GroupChatSocketService] Decoded message: $decoded');
      if (decoded['type'] == 'conversation_messages' && decoded['messages'] != null) {
        for (var msg in decoded['messages']) {
          final message = Message(
            id: msg['id']?.toString() ?? '',
            content: msg['content']?.toString() ?? '',
            senderId: msg['sender_id']?.toString() ?? msg['sender']['id']?.toString() ?? '',
            timestamp: msg['timestamp']?.toString() ?? DateTime.now().toIso8601String(), messageType: '',
          );
          onMessageReceived(message);
        }
      } else if (decoded['type'] == 'new_message' || decoded['type'] == 'message') {
        final msgData = decoded['message'] ?? decoded;
        final message = Message(
          id: msgData['id']?.toString() ?? '',
          content: msgData['content']?.toString() ?? '',
          senderId: msgData['sender_id']?.toString() ?? msgData['sender']['id']?.toString() ?? '',
          timestamp: msgData['timestamp']?.toString() ?? DateTime.now().toIso8601String(), messageType: '',
        );
        onMessageReceived(message);
      } else if (decoded['type'] == 'typing_indicator') {
        onTypingReceived?.call(decoded['is_typing'] == true);
      } else {
        debugPrint('[GroupChatSocketService] Unknown message type: ${decoded['type']}');
      }
    } catch (e) {
      debugPrint('[GroupChatSocketService] Error handling message: $e');
    }
  }

  void sendMessage(String conversationId, String senderId, String content) {
    if (_channel == null || !_isConnected) {
      debugPrint('[GroupChatSocketService] WebSocket not connected, cannot send message');
      throw Exception('WebSocket not connected');
    }
    final message = {
      'type': 'new_message',
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'message_type': 'text',
      'timestamp': DateTime.now().toIso8601String(),
    };
    debugPrint('[GroupChatSocketService] Sending message: $message');
    _channel!.sink.add(jsonEncode(message));
  }

  void sendTypingIndicator(String groupId, bool isTyping) {
    if (_channel == null || !_isConnected) {
      debugPrint('[GroupChatSocketService] WebSocket not connected, cannot send typing indicator');
      return;
    }
    final message = {
      'type': 'typing_indicator',
      'group_id': groupId,
      'is_typing': isTyping,
      'timestamp': DateTime.now().toIso8601String(),
    };
    debugPrint('[GroupChatSocketService] Sending typing indicator: $message');
    _channel!.sink.add(jsonEncode(message));
  }

  void sendRawMessage(String message) {
    if (_channel == null || !_isConnected) {
      debugPrint('[GroupChatSocketService] WebSocket not connected, cannot send raw message');
      return;
    }
    debugPrint('[GroupChatSocketService] Sending raw message: $message');
    _channel!.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    _connectionStatusController.add(false);
    debugPrint('[GroupChatSocketService] WebSocket disconnected');
  }

  void dispose() {
    disconnect();
    _connectionStatusController.close();
    debugPrint('[GroupChatSocketService] Disposed');
  }
}


