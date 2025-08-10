// group_chat_socket_service.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/group_model.dart';
import '../../../data/models/message_model.dart';

class GroupChatSocketService {
  WebSocketChannel? _channel;
  final String baseWsUrl = 'ws://10.10.13.27:8000/ws/chat/';
  final Function(Message) onMessageReceived;

  GroupChatSocketService({required this.onMessageReceived});

  Future<void> connect(String conversationId, String token) async {
    try {
      final wsUrl = '$baseWsUrl$conversationId/?token=$token';
      debugPrint('[GroupChatSocketService] Connecting to WebSocket: $wsUrl');
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _channel!.stream.listen(
            (data) {
          final message = jsonDecode(data);
          debugPrint('[GroupChatSocketService] Received message: $message');
          onMessageReceived(Message.fromJson(message));
        },
        onError: (error) {
          debugPrint('[GroupChatSocketService] WebSocket error: $error');
        },
        onDone: () {
          debugPrint('[GroupChatSocketService] WebSocket connection closed');
        },
      );
    } catch (e) {
      debugPrint('[GroupChatSocketService] Error connecting to WebSocket: $e');
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
    _channel!.sink.add(jsonEncode(message));
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    debugPrint('[GroupChatSocketService] WebSocket disconnected');
  }
}