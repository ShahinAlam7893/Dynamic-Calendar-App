import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/group_model.dart';
import '../../data/models/chat_model.dart';

class ChatService {
  static const String baseUrl = 'http://10.10.13.27:8000/api/chat';

  /// Get or create a conversation, return its ID
  static Future<String?> getOrCreateConversation(
      String currentUserId,
      String partnerId, {
        required String partnerName,
      }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken'); // ✅ updated to use same key as fetchChats
      if (token == null) throw Exception("No access token found");

      // --- 1. Try to find existing conversation ---
      final existingResponse = await http.get(
        Uri.parse('$baseUrl/conversations/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (existingResponse.statusCode == 200) {
        final List conversations = jsonDecode(existingResponse.body);
        final existing = conversations.firstWhere(
              (conv) =>
          (conv['participants'] as List)
              .any((p) => p['id'] == partnerId) &&
              (conv['participants'] as List)
                  .any((p) => p['id'] == currentUserId),
          orElse: () => null,
        );
        if (existing != null) {
          debugPrint("Found existing conversation: ${existing['id']}");
          return existing['id'].toString();
        }
      }

      // --- 2. Create new conversation if not found ---
      final createResponse = await http.post(
        Uri.parse('$baseUrl/conversations/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'participants': [currentUserId, partnerId],
          'partner_name': partnerName,
        }),
      );

      if (createResponse.statusCode == 201) {
        final data = jsonDecode(createResponse.body);
        debugPrint("Created new conversation: ${data['id']}");
        return data['id'].toString();
      }

      debugPrint(
          "Error creating conversation: ${createResponse.statusCode} ${createResponse.body}");
      return null;
    } catch (e) {
      debugPrint("Error in getOrCreateConversation: $e");
      return null;
    }
  }

  static Future<List<Chat>> fetchChats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    debugPrint('[fetchChats] Access token: $token');

    if (token == null) {
      debugPrint('[fetchChats] Access token is null, throwing exception.');
      throw Exception('Access token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/conversations/'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('[fetchChats] Response status code: ${response.statusCode}');
    debugPrint('[fetchChats] Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> conversations = data['conversations'];

      debugPrint('[fetchChats] Number of conversations: ${conversations.length}');

      final chats = conversations.map<Chat>((json) {
        final chat = Chat.fromJson(json, currentUserId: '');

        debugPrint('[fetchChats] Parsed chat: ${chat.conversationId}, ${chat.conversationId}}');
        return chat;
      }).toList();

      return chats;
    } else {
      debugPrint('[fetchChats] Failed to load chats with status code: ${response.statusCode}');
      throw Exception('Failed to load chats. Status Code: ${response.statusCode}');
    }
  }


  // -------------------------------------------------------
  // ✅ Added Group Chat Related Methods
  // -------------------------------------------------------

  static Future<List<GroupChat>> fetchGroupChats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final currentUserId = prefs.getString('currentUserId');

    if (token == null) {
      throw Exception('Access token not found');
    }
    if (currentUserId == null) {
      throw Exception('Current user ID not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/conversations/'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> conversations = data['conversations'] ?? [];

      final groupChats = conversations
          .map<GroupChat>((json) => GroupChat.fromJson(json, currentUserId: currentUserId))
          .where((chat) => chat.isGroup)
          .toList();

      return groupChats;
    } else {
      throw Exception('Failed to load group chats. Status Code: ${response.statusCode}');
    }
  }

  // static Future<List<Message>> fetchMessages(String conversationId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('accessToken');
  //
  //   if (token == null) {
  //     throw Exception('Access token not found');
  //   }
  //
  //   final url = Uri.parse('$baseUrl/conversations/$conversationId/messages/');
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final List<dynamic> messages = data['messages'] ?? [];
  //     return messages.map<Message>((json) => Message.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load group messages. Status Code: ${response.statusCode}');
  //   }
  // }



  Future<GroupMembersResponse> fetchGroupMembers(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Access token not found');
    }

    final url = Uri.parse('$baseUrl/conversations/$conversationId/members/');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return GroupMembersResponse.fromJson(data);
    } else {
      throw Exception('Failed to load group members. Status Code: ${response.statusCode}');
    }
  }

}