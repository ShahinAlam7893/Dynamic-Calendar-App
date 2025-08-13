import 'dart:convert';
import 'package:circleslate/core/network/endpoints.dart';
import 'package:circleslate/presentation/features/ride_request/view/ride_sharing_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RideService {
  static const String baseUrl =
      Urls.baseUrl; // Update this with your actual base URL

  static Future<List<RideRequest>> fetchRideRequests(
    String eventId,
    String eventDate,
    String eventTime,
    String eventLocation,
  ) async {
    final token = await _getToken(); // Get token from shared preferences
    print("🔑 Token: $token"); // Print the token for debugging

    final url = Uri.parse(
      '$baseUrl/event/events/2cb1f0e5-d8e3-42e9-9a2c-f1535aec3bb8/ride-requests/',
    );
    print("🌐 Request URL: $eventId");

    print("🌐 Request URL: $url"); // Print the URL for debugging

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      print(
        "📬 Response Status Code: ${response.statusCode}",
      ); // Print status code
      print("📬 Response Body: ${response.body}"); // Print response body

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((rideRequestJson) {
          return RideRequest.fromJson(
            rideRequestJson,
            eventDate,
            eventTime,
            eventLocation,
          );
        }).toList();
      } else {
        throw Exception('Failed to load ride requests');
      }
    } catch (error) {
      print('❌ Error fetching ride requests: $error');
      return [];
    }
  }

  // Function to retrieve the token from SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    print(
      "🔑 Retrieved token from SharedPreferences: $token",
    ); // Print the retrieved token
    return token;
  }
}
