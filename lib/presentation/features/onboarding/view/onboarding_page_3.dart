// lib/presentation/features/onboarding/view/onboarding_page_3.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../widgets/friend_avatar.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // Dynamic sizes
          double illustrationSize = screenWidth * 0.2;
          double avatarSize = screenWidth * 0.09;
          double titleFontSize = screenWidth * 0.075;
          double descriptionFontSize = screenWidth * 0.042;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.04,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Illustration
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryBlue.withOpacity(0.15),
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      child: Image.asset(
                        AppAssets.onboardingIllustration3,
                        width: illustrationSize,
                        height: illustrationSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Title
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColorPrimary,
                        ),
                        children: [
                          const TextSpan(text: 'Friend '),
                          TextSpan(
                            text: 'Circles',
                            style: TextStyle(color: AppColors.primaryBlue),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Description
                    Text(
                      AppStrings.onboardingCirclesDesc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: descriptionFontSize,
                        color: AppColors.textColorSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),

                    // Friend Avatars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FriendAvatar(radius: avatarSize, imageUrl: 'assets/images/father.png'),
                        FriendAvatar(radius: avatarSize, imageUrl: 'assets/images/mother.png'),
                        FriendAvatar(radius: avatarSize, imageUrl: 'assets/images/sister.png'),
                        FriendAvatar(radius: avatarSize, imageUrl: 'assets/images/son.png'),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Trusted Network Text
                    Text(
                      AppStrings.onboardingTrustedNetwork,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: descriptionFontSize * 0.9,
                        color: AppColors.textColorSecondary,
                      ),
                    ),
                  ],
                ),

                // Button (Bottom)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check_circle, color: AppColors.buttonPrimary, size: 20),
                  label: Text(
                    AppStrings.onboardingPrivateSecure,
                    style: const TextStyle(
                      color: AppColors.buttonPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: screenHeight * 0.015,
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
