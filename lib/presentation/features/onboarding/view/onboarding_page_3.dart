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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0), // Adjust vertical padding as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
        children: [
          // Circular Illustration Container
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue.withOpacity(0.15), // Light blue background for the circle
            ),
            padding: const EdgeInsets.all(24.0), // Padding inside the circle
            child: Image.asset(
              AppAssets.onboardingIllustration3, // This should be your circle-themed illustration
              width: 120, // Adjust size of the image within the circle
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32), // Space between illustration and title

          // Title: "Friend Circles" with "Circles" in blue
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                // fontFamily: 'Poppins', // Uncomment and ensure Poppins is added in pubspec.yaml if desired
                color: AppColors.textColorPrimary, // Default text color for "Friend"
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Friend '), // "Friend" in primary text color
                TextSpan(text: 'Circles', style: TextStyle(color: AppColors.primaryBlue)), // "Circles" in blue
              ],
            ),
          ),
          const SizedBox(height: 16), // Space between title and description

          // Description
          Text(
            AppStrings.onboardingCirclesDesc, // This should be "See when friends are available for playdates!"
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textColorSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40), // Space between description and friend avatars

          // Friend Avatars Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              FriendAvatar(radius: 35, imageUrl: 'assets/images/father.png'),
              FriendAvatar(radius: 35, imageUrl: 'assets/images/mother.png'),
              FriendAvatar(radius: 35, imageUrl: 'assets/images/sister.png'),
              FriendAvatar(radius: 35, imageUrl: 'assets/images/son.png'),
            ],


          ),
          const SizedBox(height: 16), // Space between avatars and "trusted network" text

          // "Your trusted friend network" text
          Text(
            AppStrings.onboardingTrustedNetwork,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textColorSecondary,
            ),
          ),
          const SizedBox(height: 24), // Space before the "Private & Secure Groups" button

          // "Private & Secure Groups" Button-like element
          ElevatedButton.icon(
            onPressed: () {
              // Action when this button is pressed (e.g., learn more about security)
            },
            icon: const Icon(Icons.check_circle, color: AppColors.buttonPrimary, size: 20), // Checkmark icon
            label: Text(
              AppStrings.onboardingPrivateSecure, // "Private & Secure Groups"
              style: const TextStyle(color: AppColors.buttonPrimary, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryBlue, // Blue background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Internal padding
              elevation: 0, // No shadow for a flatter look
            ),
          ),

          const Spacer(), // Pushes content upwards, pushing navigation to bottom
        ],
      ),
    );
  }
}