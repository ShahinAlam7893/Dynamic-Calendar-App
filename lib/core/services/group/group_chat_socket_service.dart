import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../data/models/group_model.dart';

class GroupChatSocketService {
  WebSocketChannel? _channel;
  final String baseWsUrl = 'ws://10.10.13.27:8000/ws/chat/';
  final Function(Message) onMessageReceived;

  // Add a connection status controller
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  GroupChatSocketService({required this.onMessageReceived});

  Future<void> connect(String conversationId, String token) async {
    try {
      final wsUrl = '$baseWsUrl$conversationId/?token=$token';
      debugPrint('[GroupChatSocketService] Connecting to WebSocket: $wsUrl');
      debugPrint('conversation ID: $conversationId');
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _isConnected = true;
      _connectionStatusController.add(true);

      _channel!.stream.listen(
            (data) {
          final message = jsonDecode(data);
          debugPrint('[GroupChatSocketService] Received message: $message');

          onMessageReceived(Message.fromJson(message));
        },
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

  void sendMessage(String conversationId, String senderId, String content) {
    if (_channel == null) {
      debugPrint('[GroupChatSocketService] WebSocket not connected');
      return;
    }


    final message = {
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'message_type': 'text',
    };
    debugPrint('[GroupChatSocketService] Sending message: $message');
    debugPrint('conversatiogfdfn ID: $conversationId');

    _channel!.sink.add(jsonEncode(message));
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    _connectionStatusController.add(false);



    debugPrint('[GroupChatSocketService] WebSocket disconnected');
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
