// lib/presentation/features/onboarding/view/onboarding_page_2.dart
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import 'onboarding_page_content.dart'; // Import the reusable content widget

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OnboardingPageContent(
      illustrationPath: AppAssets.onboardingIllustration2,
      title: AppStrings.onboardingCalendarTitle,
      description: AppStrings.onboardingCalendarDesc,
      titleStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: AppColors.primaryBlue,
      ),
      imageWidth: 287.0,
      imageHeight: 176.0,

    );
  }
}