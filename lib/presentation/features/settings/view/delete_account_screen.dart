// lib/presentation/features/settings/view/delete_account_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:circleslate/core/constants/app_colors.dart'; // Ensure this import path is correct
import 'package:circleslate/core/constants/app_strings.dart'; // Ensure this import path is correct
import 'package:circleslate/core/constants/app_assets.dart'; // Ensure this import path is correct
import 'package:circleslate/presentation/widgets/primary_button.dart'; // Reusing your PrimaryButton

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  // You can add logic here for deletion, e.g., showing a loading indicator
  // or interacting with an authentication service.

  void _confirmDeleteAccount() {
    // In a real application, you would perform the actual deletion here.
    // This might involve:
    // 1. Showing a loading spinner.
    // 2. Calling an API endpoint to delete the user's account.
    // 3. Handling success (e.g., navigating to login, showing a success message).
    // 4. Handling errors (e.g., showing an error message).

    // For demonstration, let's just print to console and then navigate back
    // or to the login screen as if deletion was successful.
    print('Attempting to delete account...');
    // Simulate a delay for API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully!')),
        );
        // After deletion, typically navigate to login or splash screen
        // context.go(AppRoutes.login); // Assuming you have a login route
        context.pop(); // For now, just pop back
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue, // Blue app bar as per image
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back arrow
          onPressed: () {
            context.pop(); // Go back to the previous screen (e.g., settings)
          },
        ),
        title: const Text(
          AppStrings.deleteAccountTitle, // "Delete Account"
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins', // Assuming Poppins is your main font
          ),
        ),
        centerTitle: true, // Center title as per image
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Trash Can Icon
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1), // Light blue background for icon
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline, // Trash can icon
                  size: 60,
                  color: AppColors.primaryBlue, // Blue icon color
                ),
              ),
              const SizedBox(height: 30),

              // Main Title
              const Text(
                AppStrings.deleteAccountTitle, // "Delete Account"
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorPrimary, // Dark text color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Confirmation Text
              const Text(
                AppStrings.deleteAccountConfirmation, // "Are you sure..."
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColorSecondary, // Medium grey text
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Warning Box
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE), // Light red background for warning
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.red.shade300, width: 1), // Red border
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded, // Warning icon
                      color: Colors.red.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppStrings.deleteAccountWarning, // Warning text
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Delete Account Button (Red)
              PrimaryButton(
                text: AppStrings.deleteAccountButton, // "Delete Account"
                onPressed: _confirmDeleteAccount,
                backgroundColor: Colors.red.shade600, // Red background
                textColor: Colors.white,
              ),
              const SizedBox(height: 20),

              // Cancel Button (White/Light)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop(); // Go back
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    foregroundColor: AppColors.textColorSecondary, // Grey text
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(color: Colors.grey.shade300, width: 1), // Light grey border
                    ),
                    elevation: 0, // No shadow
                  ),
                  child: const Text(
                    AppStrings.cancelDeleteButton, // "Cancel"
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
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