// lib/app_theme.dart
import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart'; // Import your app colors

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryBlue,
    hintColor: AppColors.lightBlue, // Use for text fields hint
    scaffoldBackgroundColor: AppColors.backgroundWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundWhite,
      foregroundColor: AppColors.textColorPrimary,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.textColorPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textColorPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.textColorPrimary),
      displayMedium: TextStyle(color: AppColors.textColorPrimary),
      displaySmall: TextStyle(color: AppColors.textColorPrimary),
      headlineMedium: TextStyle(color: AppColors.textColorPrimary),
      headlineSmall: TextStyle(color: AppColors.textColorPrimary),
      titleLarge: TextStyle(color: AppColors.textColorPrimary),
      bodyLarge: TextStyle(color: AppColors.textColorPrimary),
      bodyMedium: TextStyle(color: AppColors.textColorPrimary),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.buttonPrimary,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary, // Background color for ElevatedButton
        foregroundColor: AppColors.textColorWhite, // Text color for ElevatedButton
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue, // Text color for OutlinedButton
        side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundLight,
      hintStyle: const TextStyle(color: AppColors.textColorSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    ),
    // Define other theme properties as needed based on your Figma file
  );
}