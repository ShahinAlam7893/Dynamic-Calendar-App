import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/secondary_button.dart';

class OnboardingPage4 extends StatelessWidget {
  const OnboardingPage4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final imageSize = screenWidth * 0.25;
    final buttonWidth = screenWidth * 0.38;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(height: 20),

                // Illustration
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryBlue.withOpacity(0.15),
                  ),
                  padding: EdgeInsets.all(imageSize * 0.2),
                  child: Image.asset(
                    AppAssets.onboardingIllustration4,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: screenWidth * 0.09,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColorPrimary,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: 'Ready for '),
                      TextSpan(
                        text: 'Fun?',
                        style: TextStyle(color: AppColors.primaryBlue),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                Flexible(
                  child: Text(
                    AppStrings.onboardingReadyDesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.042,
                      color: AppColors.textColorSecondary,
                      height: 1.4,
                    ),
                  ),
                ),

                const Spacer(),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: buttonWidth,
                      child: PrimaryButton(
                        text: AppStrings.signUp,
                        onPressed: () {
                          context.push(RoutePaths.signup);
                        },
                      ),
                    ),
                    SizedBox(
                      width: buttonWidth,
                      child: SecondaryButton(
                        text: AppStrings.logIn,
                        onPressed: () {
                          context.push(RoutePaths.login);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10), // bottom spacing
              ],
            );
          },
        ),
      ),
    );
  }
}
