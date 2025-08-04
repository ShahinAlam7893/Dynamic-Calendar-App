import 'dart:io';
import 'package:http/http.dart';
import 'package:circleslate/data/services/api_base_helper.dart'; // Import the base helper
import 'package:circleslate/core/errors/exceptions.dart'; // Import custom exceptions

class UserService {
  final ApiBaseHelper _apiBaseHelper;

  UserService(this._apiBaseHelper);

  Future<Response> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    File? profileImage,
  }) async {
    try {
      // Collect all the text fields for the request
      final Map<String, String> fields = {
        'full_name': fullName,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      };

      // Define the file field name as expected by your backend
      const String fileField = 'profileImage';

      // Use the new postMultipart method from ApiBaseHelper.
      // We pass the profileImage file object directly.
      final response = await _apiBaseHelper.postMultipart(
        '/auth/register/',
        fields,
        file: profileImage,
        fileField: fileField,
      );

      return response;
    } on Exception catch (e) {
      return Response('An unexpected error occurred: Failed to post multipart data. Check server logs for details. Error: $e', 500);
    }
  }

// Other user service methods would go here...
}
