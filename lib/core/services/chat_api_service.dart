import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/message_model.dart'; // Make sure this path is correct

class ChatApiService {
  final String _baseUrl = 'http://10.10.13.27:8000/api'; // Your REST API base URL

  Future<List<MessageModel>> fetchChatHistory(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Authorization token not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/chat/history/$chatId/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chat history: ${response.statusCode}');
    }
  }



  Future<void> sendMessage(String conversationId, String content, String receiverId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.post(
      Uri.parse('http://10.10.13.27:8000/api/conversations/$conversationId/messages/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'content': content,
        'receiver_id': receiverId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }
}