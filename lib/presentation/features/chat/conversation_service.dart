import 'dart:convert';
import 'package:circleslate/presentation/features/chat/view/chat_list_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static const String baseUrl = 'http://10.10.13.27:8000/api/chat/conversations/';

  static Future<List<Chat>> fetchChats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> conversations = data['conversations'];
      return conversations.map<Chat>((json) => Chat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chats. Status Code: ${response.statusCode}');
    }
  }
}
