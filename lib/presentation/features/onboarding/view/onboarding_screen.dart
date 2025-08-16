// lib/presentation/features/onboarding/view/onboarding_screen.dart
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/page_indicator_dots.dart';

// Import the individual onboarding page files
import 'onboarding_page_content.dart'; // Keep this for OnboardingPage1 and general structure
import 'onboarding_page_2.dart'; // NEW
import 'onboarding_page_3.dart'; // NEW
import 'onboarding_page_4.dart'; // NEW

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _buildOnboardingPages(BuildContext context) {
    return [
      OnboardingPageContent(
        illustrationPath: AppAssets.onboardingIllustration1,
        imageHeight: 150,
        imageWidth: 150,
        title: AppStrings.onboardingWelcomeTitle,
        description: AppStrings.onboardingWelcomeDesc1,
        bulletPoints: [
          AppStrings.onboardingWelcomeBullet1,
          AppStrings.onboardingWelcomeBullet2,
          AppStrings.onboardingWelcomeBullet3,
        ],
      ),

      const OnboardingPage2(),

      const OnboardingPage3(),

      const OnboardingPage4(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = _buildOnboardingPages(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                ), // Adjust padding as needed
                child: Visibility(
                  visible:
                      _currentPage > 0, // Only visible if not on the first page
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textColorPrimary,
                      size: 24,
                    ), // Customize icon and color
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: pages,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button (visible on all but last page)
                  if (_currentPage < pages.length - 1)
                    TextButton(
                      onPressed: () {
                        context.go(
                          RoutePaths.login,
                        ); // Skip to Login/Signup (placeholder)
                      },
                      child: const Text(
                        AppStrings.skip,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.buttonPrimary,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 48), // Placeholder to keep alignment
                  // Page indicator dots
                  PageIndicatorDots(
                    pageCount: pages.length,
                    currentPage: _currentPage,
                  ),

                  // Next button (visible on all but last page)
                  if (_currentPage < pages.length - 1)
                    PrimaryButton(
                      width: 100,
                      height: 45,
                      text: AppStrings.next,
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                    )
                  else
                    const SizedBox(width: 100), // Placeholder to keep alignment
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
