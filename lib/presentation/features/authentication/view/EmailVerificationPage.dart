// lib/presentation/auth/EmailVerificationPage.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:circleslate/presentation/common_providers/auth_provider.dart';

// For self-containment in this Canvas, AppColors is defined here.
class AppColors {
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color textColorPrimary = Color(0xFF1B1D2A);
  static const Color textColorSecondary = Color(0x991B1D2A);
}

class EmailVerificationPage extends StatefulWidget {
  // The user's email is now passed dynamically to this page.
  final String userEmail;
  const EmailVerificationPage({super.key, required this.userEmail});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  // State to manage the loading indicator for the resend button
  bool _isResending = false;

  // Handles the logic for resending the email
  Future<void> _handleResendEmail() async {
    setState(() {
      _isResending = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.forgotPassword(widget.userEmail);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email resent successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? 'Failed to resend email.')),
        );
      }
      setState(() {
        _isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    context.pop();
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              // Calendar Icon
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_reset_outlined,
                  size: 60.0,
                  color: Colors.blue[400],
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
                    fontFamily: 'Poppins',
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: 'we have sent an email to '),
                    TextSpan(
                      text: widget.userEmail,
                      style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    const TextSpan(text: ' with a link to reset your password'),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),

              // Email Envelope Icon
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mail_outline,
                  size: 100.0,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 30.0),

              // Open your email Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // This is where you would use a package like `url_launcher`
                    // to open the user's email application.
                    // For now, it will navigate to the next page.
                    context.push('/otp_page');
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
                    onTap: _isResending ? null : _handleResendEmail,
                    child: _isResending
                        ? const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlue)
                        : const Text(
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
