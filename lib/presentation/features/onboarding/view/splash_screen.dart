import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Define a value notifier to update the loading progress
  final ValueNotifier<double> _loadingProgress = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _startLoadingAndNavigate();
  }

  void _startLoadingAndNavigate() async {
    const totalDuration = Duration(seconds: 3);
    const updateInterval = Duration(milliseconds: 50); // Update progress every 50ms
    int steps = (totalDuration.inMilliseconds / updateInterval.inMilliseconds).round();

    for (int i = 0; i <= steps; i++) {
      if (!mounted) return; // Check if the widget is still in the tree
      _loadingProgress.value = i / steps;
      await Future.delayed(updateInterval);
    }

    if (mounted) {
      context.go(RoutePaths.onboarding);
    }
  }

  @override
  void dispose() {
    _loadingProgress.dispose(); // Dispose the ValueNotifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment(-0.5, -1.0),
    end: Alignment(0.8, 1.0),
    colors: [
    Color(0xFF5A8DEE),
    Color(0xFFC2DBFF),
    ],
    ),
    ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center( // This Center widget will center its child (the Column)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers children vertically within the Column's available space
            crossAxisAlignment: CrossAxisAlignment.center, // Centers children horizontally
            children: [
              // Spacer 1 (flexible space above content block)
              // Combined with Spacer 2, this will center the block
              const Spacer(flex: 2),

              // App Logo
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30), // Circular shape
                ),
                child: Image.asset(
                  AppAssets.appLogo,
                  width: 120,
                  height: 120,
                ),
              ),
              const SizedBox(height: 24),
              // App Name
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: AppColors.textColorWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              // Tagline
              const Text(
                AppStrings.tagline,
                style: TextStyle(
                  color: AppColors.textColorWhite,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40), // Space between tagline and loader

              // Linear Progress Indicator
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6, // 60% of screen width
                child: ValueListenableBuilder<double>(
                  valueListenable: _loadingProgress,
                  builder: (context, progress, child) {
                    return LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.lightBlue.withOpacity(0.5), // Lighter background color
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.textColorWhite), // White progress bar
                      minHeight: 4, // Thickness of the progress bar
                      borderRadius: BorderRadius.circular(2), // Slightly rounded ends
                    );
                  },
                ),
              ),


              const Spacer(flex: 3), // More space below the loader to balance the view

              // Version Number (still at the bottom)
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  AppStrings.version,
                  style: TextStyle(
                    color: AppColors.textColorWhite,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}