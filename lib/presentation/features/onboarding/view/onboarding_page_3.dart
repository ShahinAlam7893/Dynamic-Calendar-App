// lib/presentation/features/onboarding/view/onboarding_page_3.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart'; // Ensure this path is correct for your illustration
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../widgets/friend_avatar.dart'; // Make sure you have created this file

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24), // top spacing

              // Circular Illustration Container
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue.withOpacity(0.15),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Image.asset(
                  AppAssets.onboardingIllustration3,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorPrimary,
                  ),
                  children: [
                    const TextSpan(text: 'Friend '),
                    TextSpan(text: 'Circles', style: TextStyle(color: AppColors.primaryBlue)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                AppStrings.onboardingCirclesDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textColorSecondary,
                  height: 1.5,
                ),
              ),
              // const SizedBox(height: 40),

              // Friend avatars
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FriendAvatar(radius: 35, imageUrl: 'assets/images/father.png'),
                  FriendAvatar(radius: 35, imageUrl: 'assets/images/mother.png'),
                  FriendAvatar(radius: 35, imageUrl: 'assets/images/sister.png'),
                  FriendAvatar(radius: 35, imageUrl: 'assets/images/son.png'),
                ],
              ),
              const SizedBox(height: 16),

              // Trusted network text
              Text(
                AppStrings.onboardingTrustedNetwork,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textColorSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Button
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle, color: AppColors.buttonPrimary, size: 20),
                label: Text(
                  AppStrings.onboardingPrivateSecure,
                  style: const TextStyle(color: AppColors.buttonPrimary, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  elevation: 0,
                ),
              ),

              const SizedBox(height: 32), // bottom spacing
            ],
          ),
        ),
      ),
    );
  }
}