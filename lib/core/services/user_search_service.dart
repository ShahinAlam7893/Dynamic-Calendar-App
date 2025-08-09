// lib/core/services/user_search_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_search_result_model.dart';

class UserSearchService {
  static const String baseUrl = 'http://10.10.13.27:8000/api/chat';

  // Search users using REST API
  Future<List<UserSearchResult>> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('No access token found');
      }

      final url = Uri.parse('$baseUrl/search-users/?q=${Uri.encodeComponent(query)}');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        return results.map((userJson) => UserSearchResult.fromJson(userJson)).toList();
      } else {
        throw Exception('Failed to search users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching users: $e');
      rethrow;
    }
  }

  void dispose() {
    // Clean up any resources if needed
  }
}