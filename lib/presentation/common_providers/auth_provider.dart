import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circleslate/data/services/user_service.dart';
import 'package:circleslate/data/services/api_base_helper.dart';
import 'package:http/http.dart'as http;


class ApiEndpoints {
  static const String register = '/auth/register/';
  static const String login = '/auth/login/';
  static const String forgotPassword = '/auth/forgot-password/';
  static const String verifyOtp = '/auth/verify-otp/';
  static const String resetPassword = '/auth/reset-password/';
  static const String userProfile = '/auth/profile/';
  static const String updateProfile = '/auth/profile/update/';
}

class AuthProvider extends ChangeNotifier {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  final UserService _userService;

  bool _isLoading = false;
  String? _errorMessage;
  String? _userEmail;
  String? _userOtp;
  String? _accessToken;
  String? _refreshToken;
  Map<String, dynamic>? _userProfile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoggedIn => _accessToken != null;

  AuthProvider() : _userService = UserService(ApiBaseHelper()) {
    _loadTokensFromStorage();
  }

  // -------------------- REGISTER --------------------
  Future<bool> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    dynamic profileImage,
  }) async {
    _setLoading(true);

    if (password != confirmPassword) {
      return _setError('Passwords do not match.');
    }

    try {
      final response = await _userService.registerUser(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        profileImage: profileImage,
      );

      _setLoading(false);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return _setError('An unexpected error occurred: $e');
    }
  }

  // -------------------- LOGIN --------------------
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final response = await _apiBaseHelper.post(
        ApiEndpoints.login,
        {"email": email, "password": password},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['tokens'] != null) {
        _accessToken = data['tokens']['access'];
        _refreshToken = data['tokens']['refresh'];
        await _saveTokensToStorage();

        _setLoading(false);
        notifyListeners();
        return true;
      }

      return _setError(data['message'] ?? 'Login failed.');
    } catch (e) {
      return _setError(e.toString());
    }
  }

  // -------------------- FETCH USER PROFILE (For Home Screen) --------------------
  Future<bool> fetchUserProfile() async {
    print("🔍 fetchUserProfile() called");

    if (_accessToken == null) {
      print("❌ No access token found. Please login first.");
      return _setError("No access token found. Please login again.");
    }

    _setLoading(true);

    try {
      final response = await _apiBaseHelper.get(
        ApiEndpoints.userProfile,
        token: _accessToken,
      );

      print("📡 API Status Code: ${response.statusCode}");
      print("📡 API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        _userProfile = {
          "id": data["id"],
          "email": data["email"],
          "full_name": data["full_name"],
          "profile_photo": data["profile_photo"],
          "date_joined": data["date_joined"],
          "bio": data["profile"]?["bio"] ?? "",
          "phone_number": data["profile"]?["phone_number"] ?? "",
          "date_of_birth": data["profile"]?["date_of_birth"] ?? "",
          "children": data["children"] ?? []
        };

        print("✅ Parsed User Profile: $_userProfile");

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        return _setError("Failed to load profile data.");
      }
    } catch (e) {
      print("❌ Error loading profile: $e");
      return _setError("Error loading profile: $e");
    }
  }


  // -------------------- FORGOT PASSWORD --------------------
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _userEmail = email;

    try {
      final response = await _apiBaseHelper.post(
        ApiEndpoints.forgotPassword,
        {'email': email},
      );

      _setLoading(false);
      return response.statusCode == 200;
    } catch (e) {
      return _setError('Failed to send OTP. Please try again.');
    }
  }

  // -------------------- VERIFY OTP --------------------
  Future<bool> verifyOtp(String otp) async {
    if (_userEmail == null) {
      return _setError('No email provided for verification.');
    }

    _setLoading(true);

    try {
      final response = await _apiBaseHelper.post(
        ApiEndpoints.verifyOtp,
        {'email': _userEmail, 'otp': otp},
      );

      _setLoading(false);

      if (response.statusCode == 200) {
        _userOtp = otp;
        return true;
      }
      return _setError(response.body);
    } catch (e) {
      return _setError('OTP verification failed. Please try again.');
    }
  }

  // -------------------- RESET PASSWORD --------------------
  Future<bool> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (_userEmail == null) {
      return _setError('Email is missing for password reset.');
    }
    if (_userOtp == null) {
      return _setError('OTP is missing for password reset.');
    }
    if (newPassword != confirmPassword) {
      return _setError('Passwords do not match.');
    }

    _setLoading(true);

    try {
      final response = await _apiBaseHelper.post(
        ApiEndpoints.resetPassword,
        {
          'email': _userEmail,
          'otp': _userOtp,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );

      _setLoading(false);

      if (response.statusCode == 200) {
        _userEmail = null;
        _userOtp = null;
        return true;
      }

      final data = jsonDecode(response.body);
      return _setError(data['message'] ?? 'Password reset failed.');
    } catch (e) {
      return _setError('An unexpected error occurred during password reset.');
    }
  }


  // -------------------- UPDATE USER PROFILE --------------------
  // This method updates the user's profile information. It handles both
  // standard form data and multipart data if a new profile image is provided.
  Future<bool> updateUserProfile(Map<String, dynamic> updatedData) async {
    _setLoading(true);
    void _clearError() {
      _errorMessage = null;
    }

    try {
      // Check if a new profile image is being uploaded
      if (updatedData.containsKey('profile_image') && updatedData['profile_image'] is String) {
        // Handle multipart request for image upload
        return await _updateProfileWithImage(updatedData);
      } else {
        // Handle standard JSON request for text data only
        return await _updateProfileWithJson(updatedData);
      }
    } catch (e) {
      return _setError('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Helper method for updating the profile with a new image using multipart request.
  Future<bool> _updateProfileWithImage(Map<String, dynamic> updatedData) async {
    final uri = Uri.parse('https://your-api-url.com${ApiEndpoints.updateProfile}');
    final request = http.MultipartRequest('PUT', uri);


    if (_accessToken == null) {
      return _setError('Access token is missing.');
    }
    request.headers['Authorization'] = 'Bearer $_accessToken';

    // Add text fields
    request.fields['full_name'] = updatedData['full_name'] ?? '';
    request.fields['email'] = updatedData['email'] ?? '';
    request.fields['phone_number'] = updatedData['phone_number'] ?? '';

    // Convert children list to a JSON string
    if (updatedData.containsKey('children')) {
      request.fields['children'] = jsonEncode(updatedData['children']);
    }

    // Add the image file
    final profileImageFile = File(updatedData['profile_image']);
    if (await profileImageFile.exists()) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_image',
        profileImageFile.path,
      ));
    } else {
      return _setError('Profile image file not found.');
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _userProfile = data['user']; // Assuming the API returns the updated user object
      notifyListeners();
      return true;
    } else {
      final data = jsonDecode(response.body);
      return _setError(data['message'] ?? 'Failed to update profile.');
    }
  }

  // Helper method for updating the profile with a standard JSON request (no image).
  Future<bool> _updateProfileWithJson(Map<String, dynamic> updatedData) async {
    final response = await _apiBaseHelper.put(
      ApiEndpoints.updateProfile,
      updatedData,
      token: _accessToken,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _userProfile = data['user']; // Assuming the API returns the updated user object
      notifyListeners();
      return true;
    } else {
      final data = jsonDecode(response.body);
      return _setError(data['message'] ?? 'Failed to update profile.');
    }
  }


  // -------------------- TOKEN STORAGE --------------------
  Future<void> _saveTokensToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (_accessToken != null) prefs.setString("accessToken", _accessToken!);
    if (_refreshToken != null) prefs.setString("refreshToken", _refreshToken!);
  }

  Future<void> _loadTokensFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString("accessToken");
    _refreshToken = prefs.getString("refreshToken");
  }

  // -------------------- HELPERS --------------------
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
