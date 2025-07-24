// lib/presentation/common_providers/auth_provider.dart
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // This will manage user login state (e.g., whether user is logged in or not)
  bool _isLoggedIn = false; // Initially not logged in

  bool get isLoggedIn => _isLoggedIn;

  // Placeholder methods for future use
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}