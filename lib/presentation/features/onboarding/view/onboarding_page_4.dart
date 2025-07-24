// lib/presentation/features/onboarding/view/onboarding_page_4.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/secondary_button.dart';
import '../../../routes/route_paths.dart';

class OnboardingPage4 extends StatelessWidget {
  const OnboardingPage4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Illustration
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue.withOpacity(0.15),
            ),
            padding: const EdgeInsets.all(32.0),
            child: Image.asset(
              AppAssets.onboardingIllustration4,
              width: 100, // Adjust size as needed
              height: 100, // Adjust size as needed
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),

          // Title: "Ready for Fun?" with "Fun?" in blue
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorPrimary,
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Ready for '),
                TextSpan(text: 'Fun?', style: TextStyle(color: AppColors.primaryBlue)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            AppStrings.onboardingReadyDesc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textColorSecondary,
              height: 1.5,
            ),
          ),

          const Spacer(flex: 2), // Add more space above the buttons to center them vertically

          // Buttons
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 133, // Adjust button width as needed
                  child: PrimaryButton(
                    text: AppStrings.signUp,
                    onPressed: () {
                      context.go(RoutePaths.signup); // Navigate to Signup (placeholder)
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 133, // Adjust button width as needed
                  child: SecondaryButton(
                    text: AppStrings.logIn,
                    onPressed: () {
                      context.go(RoutePaths.login); // Navigate to Login (placeholder)
                    },
                  ),
                ),
              ],
            ),
          ),

          const Spacer(flex: 1), // Add some space below the buttons for the page indicator
        ],
      ),
    );
  }
}