// lib/core/utils/shared_prefs_helper.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const _tokenKey = 'auth_token';

  // Saves the authentication token to shared preferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Retrieves the authentication token from shared preferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Clears the authentication token (e.g., on logout)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
