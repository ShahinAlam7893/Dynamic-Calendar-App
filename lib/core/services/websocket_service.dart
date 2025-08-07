import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatSocketService {
  WebSocketChannel? _channel;
  String? id;
  String? _token;

  final _messagesController = StreamController<String>.broadcast();
  Stream<String> get messages => _messagesController.stream;

  Future<void> connect(String conversationId) async {
    id = conversationId;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('accessToken');

    if (_token == null) {
      throw Exception('Authentication token not found');
    }

    // Use the conversation ID directly (not generated chat ID)
    final wsUrl = 'ws://10.10.13.27:8000/ws/chat/$id/?token=$_token';

    print('Connecting to WebSocket: $wsUrl'); // Debug log

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _channel!.stream.listen(
            (data) {
          print('Received WebSocket data: $data'); // Debug log
          _messagesController.add(data);
        },
        onDone: () {
          print('WebSocket connection closed');
          _messagesController.close();
        },
        onError: (error) {
          print("WebSocket Error: $error");
          _messagesController.addError(error);
        },
      );

      print('WebSocket connected successfully');
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
      rethrow;
    }
  }

  // Send message method - simplified to match what server expects
  void sendMessage(String content, String receiverId) {
    if (_channel != null && _channel!.sink != null) {
      final messagePayload = {
        'type': 'new_message',
        'content': content,
        'receiver_id': receiverId,
        'timestamp': DateTime.now().toIso8601String(), // Add client-side timestamp
      };

      final jsonMessage = jsonEncode(messagePayload);
      print('Sending message: $jsonMessage');
      _channel!.sink.add(jsonMessage);
    } else {
      print('WebSocket connection is not open.');
      throw Exception('WebSocket connection is not open.');
    }
  }

  // Add connection status check
  bool get isConnected => _channel != null && _channel!.closeCode == null;

  void dispose() {
    _messagesController.close();
    _channel?.sink.close();
  }
}