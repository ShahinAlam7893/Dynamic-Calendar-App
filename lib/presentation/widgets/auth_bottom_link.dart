// lib/presentation/widgets/auth_bottom_link.dart
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class AuthBottomLink extends StatelessWidget {
  final bool isLoginMode; // true for login page, false for signup page

  const AuthBottomLink({
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
              context.go(RoutePaths.signup); // Navigate to signup
            } else {
              context.go(RoutePaths.login); // Navigate to login
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