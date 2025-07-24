import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Verification Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', // Assuming 'Poppins' is available
      ),
      home: OtpVerificationPage(),
    );
  }
}

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
        (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    4,
        (index) => FocusNode(),
  );

  Timer? _timer;
  int _resendSeconds = 60; // Initial countdown time in seconds
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  // Start the countdown timer
  void _startResendTimer() {
    _resendSeconds = 60; // Reset timer
    _canResend = false;
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
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
                'OTP Verification',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),

              // Subtitle
              const Text(
                'Please check your email to see the verification code',
                style: TextStyle(
                  fontSize: 12.0,
                  color: AppColors.textColorSecondary,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),

              // OTP Code Label
              Align(
                alignment: Alignment.center,
                child: Text(
                  'OTP Code',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColorSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,  // Center the children in the row
                children: List.generate(4, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0), // Add space between the boxes
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0F000000), // Applying the shadow color
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: 50,  // Slightly increased width for better alignment with the image
                        height: 55, // Slightly increased height for better alignment
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1, // Only one digit per field
                          style: const TextStyle(
                            fontSize: 24.0,  // Increased font size to match the image
                            fontWeight: FontWeight.w500,  // Slightly bold font
                            color: AppColors.textColorPrimary,
                          ),
                          decoration: InputDecoration(
                            counterText: "", // Hide the character counter
                            filled: true,
                            fillColor: AppColors.otpInputFill,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),  // Rounded corners
                              borderSide: BorderSide(
                                color: AppColors.inputOutline,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),  // Rounded corners
                              borderSide: BorderSide(
                                color: AppColors.inputOutline,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),  // Rounded corners
                              borderSide: BorderSide(
                                color: AppColors.primaryBlue,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.length == 1 && index < 3) {
                              _otpFocusNodes[index + 1].requestFocus(); // Move to next field
                            } else if (value.isEmpty && index > 0) {
                              _otpFocusNodes[index - 1].requestFocus(); // Move to previous field
                            }
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30.0),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/password_reset');
                    // Combine OTP digits
                    String otp = _otpControllers.map((c) => c.text).join();
                    if (otp.length == 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Verifying OTP: $otp')),
                      );
                      // Here you would send the OTP to your backend for verification
                      print('Entered OTP: $otp');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a 4-digit OTP'),
                        ),
                      );
                    }
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
                    'Verify',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Resend code timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Resend code to : ',
                    style: TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: _canResend ? _startResendTimer : null, // Only tappable when canResend is true
                    child: Text(
                      _canResend
                          ? 'Resend'
                          : '00:${_resendSeconds.toString().padLeft(2, '0')}', // Format time as 00:XX
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: _canResend ? AppColors.primaryBlue : Colors.red,
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
