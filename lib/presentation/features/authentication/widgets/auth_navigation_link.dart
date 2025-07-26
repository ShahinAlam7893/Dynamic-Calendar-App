// lib/presentation/features/authentication/widgets/auth_navigation_link.dart
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/core/constants/app_strings.dart';

class AuthNavigationLink extends StatelessWidget {
  final bool isLoginMode; // true for login page, false for signup page

  const AuthNavigationLink({
    Key? key,
    required this.isLoginMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLoginMode ? AppStrings.dontHaveAccount : AppStrings.alreadyHaveAccount,
          style: const TextStyle(
            color: AppColors.textColorPrimary,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            if (isLoginMode) {
              context.go(AppRoutes.signup); // Navigate to signup
            } else {
              context.go(AppRoutes.login); // Navigate to login
            }
          },
          child: Text(
            isLoginMode ? AppStrings.signUpLink : AppStrings.loginLink,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}