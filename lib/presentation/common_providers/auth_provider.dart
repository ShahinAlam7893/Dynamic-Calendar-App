import 'package:flutter/material.dart';
import 'package:circleslate/data/models/user_model.dart';
import 'package:circleslate/data/services/auth_service.dart';
import 'package:circleslate/core/errors/exceptions.dart';
import 'package:circleslate/core/utils/shared_prefs_helper.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _resetEmail; // To store the email for the password reset flow
  String? _otp; // New: to store the OTP from the server for testing purposes
  String? _otpExpiry; // New: to store the OTP expiry time from the server

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get resetEmail => _resetEmail;
  String? get otp => _otp;
  String? get otpExpiry => _otpExpiry;

  Future<bool> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.registerUser(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = 'An error occurred: ${e.message}';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authService.login(
        email: email,
        password: password,
      );

      // The API response shows the access token is nested in 'tokens' -> 'access'
      final tokens = response['tokens'];
      final token = tokens != null ? tokens['access'] : null;

      if (token != null) {
        await SharedPrefsHelper.saveToken(token);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Login successful, but no token was provided by the server.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on AppException catch (e) {
      _errorMessage = 'Login failed: ${e.message}';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred during login: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Updated method to handle forgot password logic
  Future<bool> forgotPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _resetEmail = email; // Store the email for later use
      _otp = null;
      _otpExpiry = null;
      notifyListeners();

      final response = await _authService.forgotPassword(email);

      // Extract the OTP and expiry from the response if it exists
      if (response != null && response['otp'] != null) {
        _otp = response['otp'];
        _otpExpiry = response['expires_at'];
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = 'Password reset failed: ${e.message}';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Method to handle OTP verification logic
  Future<bool> verifyOtp(String otp) async {
    try {
      if (_resetEmail == null) {
        _errorMessage = 'Email address not found. Please restart the password reset process.';
        notifyListeners();
        return false;
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.verifyOtp(_resetEmail!, otp);

      _isLoading = false;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = 'OTP verification failed: ${e.message}';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
