import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;
  final String? conversationId;
  final String? chatPartnerId;
  final String chatPartnerName;
  final bool isGroupChat;
  final String? conversationName;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    required this.conversationId,
    this.chatPartnerId,
    required this.chatPartnerName,
    required this.isGroupChat,
    this.conversationName,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'];
    String chatPartnerName = 'Unknown';
    if (sender != null && sender is Map) {
      chatPartnerName = (sender['full_name'] ?? 'Unknown').toString();
    }

    return AppNotification(
      id: json['id'],
      title: json['title'],
      body: json['message'],
      timestamp: DateTime.parse(json['created_at']),
      isRead: json['is_read'] ?? false,
      conversationId: json['conversation']?.toString(),
      chatPartnerId: sender != null && sender['id'] != null ? sender['id'].toString() : null,
      chatPartnerName: chatPartnerName,
      conversationName: json['conversation_name']?.toString(),
      isGroupChat: (json['conversation_name'] ?? '').toString().toLowerCase().contains('team'),
    );
  }

}


class NotificationService {
  final String _baseUrl = 'http://10.10.13.27:8000/api/chat/notifications/';

  /// Fetch notifications from API
  Future<List<AppNotification>> fetchNotifications({int limit = 5101}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('No access token found in SharedPreferences.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl?limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final notificationsJson = data['notifications'] as List;
      return notificationsJson
          .map((json) => AppNotification.fromJson(json))
          .toList();
    } else {
      throw Exception(
          'Failed to fetch notifications: ${response.statusCode} ${response.body}');
    }
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('No access token found in SharedPreferences.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl$notificationId/read/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to mark notification as read: ${response.statusCode} ${response.body}');
    }
  }


  Future<int> getUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) return 0;

    final response = await http.get(
      Uri.parse('http://10.10.13.27:8000/chat/notifications/unread-count/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['unread_count'] ?? 0;
    } else {
      return 0;
    }
  }
}
