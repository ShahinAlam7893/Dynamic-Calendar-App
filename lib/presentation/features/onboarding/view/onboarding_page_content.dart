import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';


class OnboardingPageContent extends StatelessWidget {
  final String illustrationPath;
  final String title;
  final String description;
  final String? onboardingWelcomeLogoName;
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
    this.onboardingWelcomeLogoName,
    this.bulletPoints,
    this.bottomContent,
    this.imageHeight,
    this.imageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Illustration
            SizedBox(
              height: screenHeight * 0.3,
              child: Image.asset(
                illustrationPath,
                width: imageWidth ?? screenWidth * 0.6,
                height: imageHeight ?? screenHeight * 0.3,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style:
                  titleStyle ??
                  const TextStyle(
                    fontSize: 32,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorPrimary,
                  ),
            ),

            const SizedBox(height: 16),

            if (onboardingWelcomeLogoName != null &&
                onboardingWelcomeLogoName!.isNotEmpty)
              Column(
                children: [
                  Text(
                    onboardingWelcomeLogoName!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),

            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style:
                  descriptionStyle ??
                  const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    // fontWeight: FontWeight.w500,
                    color: AppColors.textColorPrimary,
                    height: 1.5,
                  ),
            ),

            const SizedBox(height: 12),

            // Bullet Points
            if (bulletPoints != null && bulletPoints!.isNotEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: bulletPoints!
                    .map(
                      (text) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.buttonPrimary,
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                text,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
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

            const Spacer(),

            if (bottomContent != null) ...[
              bottomContent!,
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
