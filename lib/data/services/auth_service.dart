// lib/data/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart';
import 'package:circleslate/data/models/user_model.dart';
import 'package:circleslate/data/services/api_base_helper.dart';
import 'package:circleslate/core/errors/exceptions.dart';
import 'package:circleslate/core/utils/shared_prefs_helper.dart';

class AuthService {
  final ApiBaseHelper _apiHelper = ApiBaseHelper();

  Future<void> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    String? profilePictureUrl,
  }) async {
    try {
      final response = await _apiHelper.post(
        '/auth/register/',
        {
          'full_name': fullName,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  // FIX: This method now correctly returns the decoded JSON body.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiHelper.post(
        '/auth/login/',
        {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        // Decode the JSON body before returning it
        return json.decode(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  // FIX: This method now correctly returns the decoded JSON body.
  Future<Map<String, dynamic>> getProfile() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null) {
      throw UnauthorizedException('No auth token found.', '/profile');
    }

    try {
      final response = await _apiHelper.get(
        '/profile/',
        token: token,
      );
      if (response.statusCode == 200) {
        // Decode the JSON body before returning it
        return json.decode(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  // New method to request a password reset
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _apiHelper.post(
        '/auth/forgot-password/',
        {'email': email},
      );
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  // New method to verify the OTP
  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response = await _apiHelper.post(
        '/auth/verify-otp/',
        {
          'email': email,
          'otp': otp,
        },
      );
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
