// lib/core/services/websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';


class ChatSocketService {
  WebSocketChannel? _channel;
  String? _conversationId;
  String? _token;
  final Uuid _uuid = const Uuid();

  final _messagesController = StreamController<String>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  Stream<String> get messages => _messagesController.stream;
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  bool _isConnected = false;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;

  // Track if controllers are closed to avoid adding events after close
  bool _messagesControllerClosed = false;
  bool _connectionStatusControllerClosed = false;

  Future<void> connect(String conversationId) async {
    if (conversationId.isEmpty) {
      throw Exception('conversationId is empty — cannot connect to WebSocket.');
    }

    _conversationId = conversationId;
    await _establishConnection();
  }

  Future<void> _establishConnection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('accessToken');

      if (_token == null) {
        throw Exception('Authentication token not found');
      }

      final wsUrl = 'ws://10.10.13.27:8000/ws/chat/$_conversationId/?token=$_token';
      debugPrint('[ChatSocketService] Connecting to WebSocket: $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _channel!.stream.listen(
            (data) {
          debugPrint('[ChatSocketService] Received data: $data');
          _handleMessage(data);
        },
        onDone: () {
          debugPrint('[ChatSocketService] WebSocket closed (onDone).');
          _handleDisconnection();
        },
        onError: (error) {
          debugPrint('[ChatSocketService] WebSocket error: $error');
          _handleConnectionError(error);
        },
        cancelOnError: true,
      );

      _isConnected = true;
      _reconnectAttempts = 0;
      if (!_connectionStatusControllerClosed) {
        _connectionStatusController.add(true);
      }
      _startHeartbeat();

      debugPrint('[ChatSocketService] WebSocket connected successfully');
    } catch (e) {
      debugPrint('[ChatSocketService] Failed to connect to WebSocket: $e');
      _handleConnectionError(e);
      rethrow;
    }
  }


  void _handleMessage(dynamic data) {
    try {
      final String text = data is String ? data : jsonEncode(data);
      final decoded = jsonDecode(text);

      // Handle different message types
      if (decoded['type'] == 'heartbeat') {
        _handleHeartbeat(decoded);
      } else {
        _messagesController.add(text);
      }
    } catch (e) {
      debugPrint('[ChatSocketService] Error parsing message, forwarding raw: $e');
      // forward raw data so UI can at least try to parse
      _messagesController.add(data is String ? data : data.toString());
    }
  }


  void _handleHeartbeat(Map<String, dynamic> data) {
    if (data['require_response'] == true) {
      _sendHeartbeatResponse();
    }
  }

  void _sendHeartbeatResponse() {
    if (isConnected) {
      try {
        final response = {
          'type': 'heartbeat_response',
          'timestamp': DateTime.now().toIso8601String(),
        };
        _channel!.sink.add(jsonEncode(response));
        debugPrint('[ChatSocketService] Sent heartbeat_response');
      } catch (e) {
        debugPrint('[ChatSocketService] Error sending heartbeat response: $e');
      }
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (isConnected) {
        _sendHeartbeat();
      }
    });
  }

  void _sendHeartbeat() {
    try {
      final heartbeat = {
        'type': 'heartbeat',
        'timestamp': DateTime.now().toIso8601String(),
      };
      _channel!.sink.add(jsonEncode(heartbeat));
      debugPrint('[ChatSocketService] Sent heartbeat');
    } catch (e) {
      debugPrint('[ChatSocketService] Error sending heartbeat: $e');
      _handleConnectionError(e);
    }
  }

  void _handleDisconnection() {
    _isConnected = false;
    if (!_connectionStatusControllerClosed) {
      _connectionStatusController.add(false);
    }
    _heartbeatTimer?.cancel();

    if (_reconnectAttempts < maxReconnectAttempts) {
      _scheduleReconnect();
    } else {
      debugPrint('[ChatSocketService] Max reconnection attempts reached');
    }
  }

  void _handleConnectionError(dynamic error) {
    _isConnected = false;
    if (!_connectionStatusControllerClosed) {
      _connectionStatusController.add(false);
    }
    _heartbeatTimer?.cancel();

    if (_reconnectAttempts < maxReconnectAttempts) {
      _scheduleReconnect();
    }

    try {
      if (!_messagesControllerClosed) {
        _messagesController.addError(error);
      }
    } catch (_) {}
  }

  void _scheduleReconnect() {
    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2);

    debugPrint('[ChatSocketService] Scheduling reconnection attempt $_reconnectAttempts in ${delay.inSeconds}s');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () async {
      if (_conversationId != null) {
        debugPrint('[ChatSocketService] Attempting reconnect attempt #$_reconnectAttempts');
        try {
          await _establishConnection();
        } catch (e) {
          debugPrint('[ChatSocketService] Reconnect attempt failed: $e');
        }
      }
    });
  }

  void sendMessage(String content, String receiverId, [String? clientMessageId]) {
    if (!isConnected) {
      throw Exception('WebSocket connection is not open.');
    }

    final messagePayload = {
      'type': 'new_message',
      'content': content,
      'receiver_id': int.tryParse(receiverId),
      'conversation_id': _conversationId,
      'timestamp': DateTime.now().toIso8601String(),
      'client_message_id': clientMessageId ?? _uuid.v4(),
    };

    final jsonMessage = jsonEncode(messagePayload);
    debugPrint('[ChatSocketService] Sending message: $jsonMessage');

    try {
      _channel!.sink.add(jsonMessage);
    } catch (e) {
      debugPrint('[ChatSocketService] Error sending message: $e');
      _handleConnectionError(e);
      rethrow;
    }
  }

  void sendTypingIndicator(String receiverId, bool isTyping, {required bool isGroup}) {
    if (!isConnected) return;

    final payload = {
      'type': 'typing_indicator',
      'receiver_id': int.tryParse(receiverId),
      'is_typing': isTyping,
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      _channel!.sink.add(jsonEncode(payload));
      debugPrint('[ChatSocketService] Sent typing indicator: $payload');
    } catch (e) {
      debugPrint('[ChatSocketService] Error sending typing indicator: $e');
    }
  }

  void markAsRead(List<String> messageIds) {
    if (!isConnected) return;

    final payload = {
      'type': 'mark_as_read',
      'message_ids': messageIds,
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      _channel!.sink.add(jsonEncode(payload));
      debugPrint('[ChatSocketService] Sent mark_as_read for ${messageIds.length} messages');
    } catch (e) {
      debugPrint('[ChatSocketService] Error marking messages as read: $e');
    }
  }

  bool get isConnected => _isConnected && _channel != null && (_channel!.closeCode == null);

  Future<void> reconnect() async {
    if (_conversationId != null) {
      dispose();
      _reconnectAttempts = 0;
      await _establishConnection();
    } else {
      debugPrint('[ChatSocketService] Cannot reconnect — conversationId is null');
    }
  }

  void dispose() {
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();

    // Mark controllers as closed to prevent adding events after this
    _messagesControllerClosed = true;
    _connectionStatusControllerClosed = true;

    if (!_messagesController.isClosed) {
      _messagesController.close();
    }
    if (!_connectionStatusController.isClosed) {
      _connectionStatusController.close();
    }

    try {
      _channel?.sink.close();
    } catch (e) {
      debugPrint('[ChatSocketService] Error closing channel: $e');
    }

    _channel = null;
    _isConnected = false;
    debugPrint('[ChatSocketService] Disposed');
  }
}
