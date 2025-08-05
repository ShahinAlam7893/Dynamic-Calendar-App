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

        print(_accessToken);

        _setLoading(false);
        notifyListeners();
        return true;
      }

      return _setError(data['message'] ?? 'Login failed.');
    } catch (e) {
      return _setError(e.toString());
    }
  }

  Future<bool> addChild(String name, int age) async {
    final url = Uri.parse('http://10.10.13.27:8000/api/auth/children/');

    // 🛠 Debug: Print request details
    print('--- ADD CHILD API CALL ---');
    print('URL: $url');
    print('Headers: {Content-Type: application/json, Authorization: Bearer $_accessToken}');
    print('Body: ${jsonEncode({'name': name, 'age': age})}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
      body: jsonEncode({'name': name, 'age': age}),
    );

    // 🛠 Debug: Print response details
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('✅ Child added successfully!');
      return true;
    } else {
      print('❌ Failed to add child: ${response.body}');
      return false;
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



  // -------------------- FETCH USER PROFILE (For Home Screen) --------------------
  Future<bool> fetchUserProfile() async {
    print("🔍 fetchUserProfile() called");

    if (_accessToken == null) {
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
          "children": data["profile"]?["children"] ?? []
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


// -------------------- UPDATE USER PROFILE --------------------
  Future<bool> updateUserProfile(Map<String, dynamic> updatedData) async {
    try {
      print('🔄 Starting profile update...');
      print('📦 Updated data: $updatedData');

      final token = await _accessToken; // Get saved token
      print('🔑 Token loaded: ${token != null ? 'Yes' : 'No'}');
      print('🔑 Token loaded: ${token}');

      if (token == null) {
        print('❌ No token found. Cannot update profile.');
        return false;
      }

      final uri = Uri.parse('http://10.10.13.27:8000/api/auth/profile/update/');
      final request = http.MultipartRequest('PATCH', uri);

      // Authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Text fields
      if (updatedData['full_name'] != null) {
        request.fields['full_name'] = updatedData['full_name'];
        print('📝 Added field: full_name = ${updatedData['full_name']}');
      }

      // Profile phone number (nested field)
      if (updatedData['phone_number'] != null) {
        request.fields['profile.phone_number'] = updatedData['phone_number'];
        print('📞 Added field: profile.phone_number = ${updatedData['phone_number']}');
      }

      // Children (if needed)
      if (updatedData['children'] != null) {
        request.fields['profile.children'] = jsonEncode(updatedData['children']);
      }

      // Profile photo
      if (updatedData['profile_image'] != null &&
          File(updatedData['profile_image']).existsSync()) {
        print('📷 Adding profile image: ${updatedData['profile_image']}');
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_photo', // API expects this name
            updatedData['profile_image'],
          ),
        );
      } else {
        print('⚠️ No profile image to upload.');
      }

      // Print all request fields before sending
      print('📤 Final request fields: ${request.fields}');
      print('📤 Final request files: ${request.files.map((f) => f.filename).toList()}');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Profile updated successfully!');
        await fetchUserProfile(); // <--- refresh after update
        return true;
      }
      else {
        print('❌ Update failed.');
        return false;
      }
    } catch (e) {
      print('💥 Error updating profile: $e');
      return false;
    }
  }

  // Future<bool> updateUserProfile(Map<String, dynamic> updatedData) async {
  //   _setLoading(true);
  //   void _clearError() {
  //     _errorMessage = null;
  //     notifyListeners();
  //   }
  //
  //   try {
  //     if (updatedData.containsKey('profile_image') &&
  //         updatedData['profile_image'] is String &&
  //         updatedData['profile_image'].isNotEmpty) {
  //       // Multipart if image is provided
  //       return await _updateProfileWithImage(updatedData);
  //     } else {
  //       // JSON only if no new image
  //       return await _updateProfileWithJson(updatedData);
  //     }
  //   } catch (e) {
  //     print('Error in updateUserProfile: $e');
  //     return _setError('An unexpected error occurred during profile update: $e');
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

// -------------------- UPDATE WITH MULTIPART IMAGE --------------------

  Future<bool> _updateProfileWithImage(Map<String, dynamic> updatedData) async {
    try {
      final profileImageFile = File(updatedData['profile_image']);

      final Map<String, dynamic> profileData = {
        'bio': updatedData['bio'] ?? '',
        'phone_number': updatedData['phone_number'] ?? '',
        'date_of_birth': updatedData['date_of_birth'] ?? '',
        'created_at': updatedData['created_at'] ?? '',
        'updated_at': updatedData['updated_at'] ?? '',
        'children': updatedData['children'] ?? [], // Already a List<Map<String, dynamic>>
      };

      final Map<String, String> fields = {
        'full_name': updatedData['full_name'] ?? '',
        'profile': jsonEncode(profileData),
      };

      final response = await _apiBaseHelper.putMultipart(
        ApiEndpoints.updateProfile,
        fields,
        token: _accessToken,
        file: profileImageFile,
        fileField: 'profile_photo',
      );

      print("📡 Multipart Status Code: ${response.statusCode}");
      print("📡 Multipart Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return _setError('Profile update with image failed: Empty response.');
        }
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('user')) {
          _userProfile = data['user'];
          notifyListeners();
          return true;
        } else {
          return _setError('Invalid API response for image upload: ${data['message'] ?? 'No user data.'}');
        }
      } else {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return _setError(data['message'] ?? 'Failed to update profile with image.');
        }
        return _setError('Failed to update profile with image: Empty error response.');
      }
    } catch (e) {
      print('Error in _updateProfileWithImage: $e');
      return _setError('Failed to send multipart data: $e');
    }
  }

// -------------------- UPDATE WITH JSON ONLY --------------------

  Future<bool> _updateProfileWithJson(Map<String, dynamic> updatedData) async {
    try {
      final Map<String, dynamic> requestBody = {
        'full_name': updatedData['full_name'] ?? '',
        'profile': {
          'bio': updatedData['bio'] ?? '',
          'phone_number': updatedData['phone_number'] ?? '',
          'date_of_birth': updatedData['date_of_birth'] ?? '',
          'created_at': updatedData['created_at'] ?? '',
          'updated_at': updatedData['updated_at'] ?? '',
          'children': updatedData['children'] ?? [],
        },
        if (updatedData.containsKey('profile_image') &&
            updatedData['profile_image'] is String)
          'profile_photo': updatedData['profile_image'],
      };

      final response = await _apiBaseHelper.put(
        ApiEndpoints.updateProfile,
        requestBody,
        token: _accessToken,
      );

      print('📡 JSON Status Code: ${response.statusCode}');
      print('📡 JSON Response Body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return _setError('Profile update failed: Empty response.');
        }
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('user')) {
          _userProfile = data['user'];
          notifyListeners();
          return true;
        } else {
          return _setError('Invalid API response: ${data['message'] ?? 'No user data.'}');
        }
      } else {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return _setError(data['message'] ?? 'Failed to update profile.');
        }
        return _setError('Failed to update profile: Empty error response.');
      }
    } catch (e) {
      print('Error in _updateProfileWithJson: $e');
      return _setError('Unexpected error during profile update: $e');
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
