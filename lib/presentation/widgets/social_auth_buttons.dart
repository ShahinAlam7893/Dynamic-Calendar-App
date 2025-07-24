// lib/presentation/widgets/social_auth_buttons.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class SocialAuthButtons extends StatelessWidget {
  final bool isLoginMode; // true for login, false for signup

  const SocialAuthButtons({
    Key? key,
    required this.isLoginMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            isLoginMode ? AppStrings.orLoginWith : AppStrings.orSignUpWith,
            style: const TextStyle(
              color: AppColors.textColorSecondary,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google
            InkWell(
              onTap: () {
                // TODO: Implement Google authentication
                print('${isLoginMode ? 'Login' : 'Sign up'} with Google');
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(AppAssets.googleLogoIcon),
              ),
            ),
            // const SizedBox(width: 20),
            // // Facebook
            // InkWell(
            //   onTap: () {
            //
            //     print('${isLoginMode ? 'Login' : 'Sign up'} with Facebook');
            //   },
            //   child: CircleAvatar(
            //     radius: 25,
            //     backgroundColor: Colors.transparent,
            //     backgroundImage: AssetImage(AppAssets.facebookIcon),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}