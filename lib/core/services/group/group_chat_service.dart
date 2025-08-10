// group_chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/group_model.dart';

class GroupChatService {
  static const String baseUrl = 'http://10.10.13.27:8000/api/chat/conversations/';
  static Future<List<Chat>> fetchGroupChats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final currentUserId = prefs.getString('currentUserId'); // ✅ get from prefs

    if (token == null) {
      throw Exception('Access token not found');
    }
    if (currentUserId == null) {
      throw Exception('Current user ID not found');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> conversations = data['conversations'] ?? [];
      return conversations
          .map<Chat>((json) => Chat.fromJson(json, currentUserId: '')) // ✅ pass it here
          .where((chat) => chat.isGroup)
          .toList();
    } else {
      throw Exception('Failed to load group chats. Status Code: ${response.statusCode}');
    }
  }


  static Future<List<Message>> fetchMessages(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Access token not found');
    }

    final url = Uri.parse('$baseUrl$conversationId/messages/');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> messages = data['messages'] ?? [];
      return messages.map<Message>((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load group messages. Status Code: ${response.statusCode}');
    }
  }
}