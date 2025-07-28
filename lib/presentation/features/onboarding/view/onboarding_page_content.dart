// lib/presentation/features/onboarding/view/onboarding_page_content.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart'; // For checkmark icon

class OnboardingPageContent extends StatelessWidget {
  final String illustrationPath;
  final String title;
  final String description;
  final String? onboardingWelcomeLogoName; // Keep as nullable
  final List<String>? bulletPoints;
  final Widget? bottomContent;
  final double? imageWidth;
  final double? imageHeight;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;

  const OnboardingPageContent({
    Key? key,
    required this.illustrationPath,
    required this.title,
    this.titleStyle,
    required this.description,
    this.descriptionStyle,
    this.onboardingWelcomeLogoName, // It's optional, so it can be null
    this.bulletPoints,
    this.bottomContent,
    this.imageHeight,
    this.imageWidth

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 150.0),
      child: Column(
        children: [
          // Illustration
          Expanded(
            flex: 3,
            child: Image.asset(
              // REMOVE THE HARDCODED width: 150, height: 150 HERE
              // Use the passed parameters imageWidth and imageHeight
              width: imageHeight,
              height: imageWidth,
              illustrationPath,
              fit: BoxFit.contain,
            ),
          ),
          // const SizedBox(height: 0), // If you removed a SizedBox, ensure spacing is correct

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.textColorPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // FIX: Only show onboardingWelcomeLogoName if it's not null
          if (onboardingWelcomeLogoName != null && onboardingWelcomeLogoName!.isNotEmpty) // Check if not null and not empty
            Column( // Wrap in Column to provide vertical spacing if needed
              children: [
                Text(
                  onboardingWelcomeLogoName!, // Safe to use ! now, because of the if-condition
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 16), // Add spacing after logo name
              ],
            ),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0x991B1D2A),
              height: 1.5,
            ),
          ),
          if (bulletPoints != null && bulletPoints!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.center, // Center align the bullet section
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Ensure child Rows are centered
                children: bulletPoints!
                    .map(
                      (text) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Important: shrink Row width to content
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.buttonPrimary,
                          size: 13,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            text,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textColorPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ],

          const Spacer(),
          if (bottomContent != null) ...[
            bottomContent!,
          ],
        ],
      ),
    );
  }
}