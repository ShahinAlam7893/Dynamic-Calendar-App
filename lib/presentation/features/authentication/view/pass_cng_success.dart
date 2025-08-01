// lib/presentation/auth/pass_cng_success.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// For self-containment in this Canvas, AppColors is defined here.
class AppColors {
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color inputBorderColor = Colors.grey;
  static const Color textColorSecondary = Color(0x991B1D2A);
  static const Color inputHintColor = Colors.grey;
  static const Color lightBlueBackground = Color(0x1AD8ECFF);
  static const Color textDark = Color(0xE51B1D2A);
  static const Color textMedium = Color(0x991B1D2A);
  static const Color textLight = Color(0xB21B1D2A);
  static const Color accentBlue = Color(0xFF5A8DEE);
  static const Color inputOutline = Color(0x1A101010);
  static const Color emailIconBackground = Color(0x1AD8ECFF);
  static const Color otpInputFill = Color(0xFFF9FAFB);
  static const Color successIconBackground = Color(0x1AD8ECFF);
  static const Color successIconColor = Color(0xFF4CAF50);
}

// NOTE: In a real app, this page would be part of a larger routing system.
// This main function is for demonstration purposes within this canvas.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Reset Success Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      home: const PasswordResetSuccessPage(),
    );
  }
}

class PasswordResetSuccessPage extends StatelessWidget {
  const PasswordResetSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: () {
                    // Navigate back using go_router
                    context.pop();
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              // Calendar Icon placeholder
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_reset_outlined,
                  size: 60.0,
                  color: Colors.blue[400],
                ),
              ),
              const SizedBox(height: 20.0),

              // Title
              const Text(
                'Cool!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),

              // Subtitle
              const Text(
                'Password Changed',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),

              const Text(
                'your password has been changed successfully.',
                style: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),

              // Success Checkmark Icon
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: AppColors.successIconBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 100,
                  color: AppColors.successIconColor,
                ),
              ),
              const SizedBox(height: 30.0),

              // Go to login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the login page and remove all previous routes
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Go to Login',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
