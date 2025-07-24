import 'package:flutter/material.dart';
import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/presentation/features/authentication/view/EmailVerificationPage.dart';
import 'package:go_router/go_router.dart';


// For self-containment in this Canvas, AppColors is defined here.
// In a real project, you would import them from your project structure.


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email Sent Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', // Assuming 'Poppins' is available
      ),
      home: EmailVerificationPage(),
    );
  }
}

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example email to display (you would pass this dynamically)
    const String userEmail = 'example@gmail.com';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: () {
                   Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              // Calendar Icon (from previous pages)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppAssets.calendarIcon, // This should be your circle-themed illustration
                  width: 80, // Adjust size of the image within the circle
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback for Image.asset if the asset is not found
                    return Icon(
                      Icons.calendar_month,
                      size: 60.0,
                      color: Colors.blue[400],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              // Title
              const Text(
                'Email Sent',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),

              // Subtitle with dynamic email
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColorSecondary,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins', // Ensure font consistency
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: 'we have sent an email to '),
                    TextSpan(
                      text: userEmail,
                      style: const TextStyle(
                        color: AppColors.primaryBlue, // Highlight email address
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    const TextSpan(text: ' with a link reset password'),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),

              // Email Envelope Icon
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  //color: AppColors.emailIconBackground, // Light blue background
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppAssets.emailIcon, // This should be your circle-themed illustration
                  width: 100, // Adjust size of the image within the circle
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback for Image.asset if the asset is not found
                    return Icon(
                      Icons.calendar_month,
                      size: 60.0,
                      color: Colors.blue[400],
                    );
                  },
                ),
              ),
              const SizedBox(height: 30.0),

              // Open your email Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/otp_page');
                    // Handle opening email app (platform-specific implementation needed)
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('Opening email app...')),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Open your email',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Email not received? Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Email not received? ',
                    style: TextStyle(fontSize: 10.0, color: Colors.grey, fontWeight: FontWeight.w300),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle resend email logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Resending email...')),
                      );
                    },
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
