import 'package:flutter/material.dart';

class AppColors {
  // Primary & Accent Colors
  static const Color primaryBlue = Color(0xFF5A8DEE);
  static const Color secondaryBlue = Color(0xFFD8ECFF); // Main app blue
  static const Color lightBlue = Color(0xFFC7E0FF); // Lighter blue for backgrounds
  static const Color accentGreen = Color(0xFF4CAF50); // Green for "available" or checkmarks

  // Text Colors
  static const Color textColorPrimary = Color(0xFF212121); // Dark grey for most text
  static const Color textColorSecondary = Color(0xFF757575); // Lighter grey for secondary text
  static const Color textColorWhite = Colors.white;

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light grey general background
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  // Button Colors
  static const Color buttonPrimary = primaryBlue;

  // Specific to Onboarding
  static const Color onboardingDotActive = primaryBlue;
  static const Color onboardingDotInactive = Color(0xD9D9D9);

  static var inputBorderColor = Color(0xFF1010101A);
  static const Color inputOutline = Color(0x1A101010);

  static var inputHintColor = Color(0x661B1D2A);

  static var iconColor = Color(0xFFF5F5F5);
  static const Color otpInputFill = Color(0x33FFFFFF);
  static const Color shadowColor = Color(0x0F0000000);
}
