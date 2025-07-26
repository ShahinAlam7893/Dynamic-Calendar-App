import 'package:circleslate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // For navigation


class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop(); // Use pop for back navigation
          },
        ),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'By accessing and using the Dynamic Social Calendar App, you agree to the following terms:',
                style: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.textColorPrimary,
                  fontFamily: 'Poppins',
                  height: 1.5, // Line height
                ),
              ),
              const SizedBox(height: 20.0),
              _buildTermsPoint(
                number: '1.',
                title: 'General Guidance Only:',
                content: 'The app offers general social coordination and insights. It is not a replacement for personalized consulting or professional services.',
              ),
              _buildTermsPoint(
                number: '2.',
                title: 'Data Privacy:',
                content: 'Your information is handled securely and in line with our Privacy Policy. We protect your children\'s data with highest security measures.',
              ),
              _buildTermsPoint(
                number: '3.',
                title: 'Disclaimer:',
                content: 'We are not liable for any decisions or outcomes resulting from the use of this app\'s features or social coordination advice.',
              ),
              _buildTermsPoint(
                number: '4.',
                title: 'Event Coordination:',
                content: 'Parents are responsible for supervising all planned activities. The app facilitates coordination but does not guarantee event outcomes.',
              ),
              _buildTermsPoint(
                number: '5.',
                title: 'Account Termination:',
                content: 'We reserve the right to terminate accounts that violate community guidelines or engage in inappropriate behavior.',
                isLast: true, // Mark as last to remove bottom padding if needed
              ),
            ],
          ),
        ),
      ),
      // The bottom navigation bar will be provided by SmoothNavigationWrapper
    );
  }

  Widget _buildTermsPoint({
    required String number,
    required String title,
    required String content,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0), // Add bottom padding unless it's the last item
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14.0,
                color: AppColors.textColorPrimary,
                fontFamily: 'Poppins',
                height: 1.5,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '$number ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.0,
              color: AppColors.textColorSecondary,
              fontFamily: 'Poppins',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
