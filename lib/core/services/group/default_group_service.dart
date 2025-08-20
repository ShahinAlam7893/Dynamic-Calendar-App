import 'dart:convert';
import 'package:circleslate/core/network/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/default_group_model.dart';



class DefaultGroupService {
  static const String _baseUrl =
      '${Urls.baseUrl}/chat/default-groups/';

  Future<List<DefaultGroup>> fetchDefaultGroups() async {
    print('Fetching default groups from $_baseUrl');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) {
        print('No access token found');
        throw Exception('No access token found');
      }
      print('Using token: Bearer $token');

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('HTTP GET response status: ${response.statusCode}');
      print('HTTP GET response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Decoded JSON data: $data');
        return data.map((json) => DefaultGroup.fromJson(json)).toList();
      } else {
        print(
          'Failed to fetch default groups with status: ${response.statusCode}',
        );
        throw Exception(
          'Failed to fetch default groups: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching default groups: $e');
      throw Exception('Error fetching default groups: $e');
    }
  }

  Future<Map<String, dynamic>> joinGroup(int groupId) async {
    print('Joining group with ID: $groupId');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) {
        print('No access token found');
        throw Exception('No access token found');
      }
      print('Using token: Bearer $token');

      final response = await http.post(
        Uri.parse('${_baseUrl}join/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'group_ids': [groupId],
        }),
      );
      print('HTTP POST response status: ${response.statusCode}');
      print('HTTP POST response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to join group with status: ${response.statusCode}');
        throw Exception('Failed to join group: ${response.statusCode}');
      }
    } catch (e) {
      print('Error joining group: $e');
      throw Exception('Error joining group: $e');
    }
  }

  Future<Map<String, dynamic>> leaveGroup(int groupId) async {
    print('Leaving group with ID: $groupId');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) {
        print('No access token found');
        throw Exception('No access token found');
      }
      print('Using token: Bearer $token');

      final response = await http.post(
        Uri.parse('${_baseUrl}leave/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'group_ids': [groupId],
        }),
      );
      print('HTTP POST response status: ${response.statusCode}');
      print('HTTP POST response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to leave group with status: ${response.statusCode}');
        throw Exception('Failed to leave group: ${response.statusCode}');
      }
    } catch (e) {
      print('Error leaving group: $e');
      throw Exception('Error leaving group: $e');
    }
  }

  Future<List<DefaultGroup>> fetchMyGroups() async {
    print('Fetching my groups from ${_baseUrl}my-groups/');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) {
        print('No access token found');
        throw Exception('No access token found');
      }
      print('Using token: Bearer $token');

      final response = await http.get(
        Uri.parse('${_baseUrl}my-groups/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('HTTP GET response status: ${response.statusCode}');
      print('HTTP GET response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Decoded JSON data: $data');
        return data.map((json) => DefaultGroup.fromJson(json)).toList();
      } else {
        print('Failed to fetch my groups with status: ${response.statusCode}');
        throw Exception('Failed to fetch my groups: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching my groups: $e');
      throw Exception('Error fetching my groups: $e');
    }
  }
}
