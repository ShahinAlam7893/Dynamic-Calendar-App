import 'package:flutter/material.dart';
import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/presentation/features/authentication/view/EmailVerificationPage.dart';
import 'package:go_router/go_router.dart';

// For self-containment in this Canvas, AppColors and AuthInputField are defined here.
// In a real project, you would import them from your project structure.

class AppColors {
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color inputBorderColor = Colors.grey;
  static const Color textColorSecondary = Color(0xFF333333);
  static const Color inputHintColor = Colors.grey;
  static const Color lightBlueBackground = Color(0x1AD8ECFF);
  static const Color textDark = Color(0xE51B1D2A);
  static const Color textMedium = Color(0x991B1D2A);
  static const Color textLight = Color(0xB21B1D2A);
  static const Color accentBlue = Color(0xFF5A8DEE);
  static const Color inputOutline = Color(0x1A101010);
  static const Color emailIconBackground = Color(0x1AD8ECFF);
  static const Color otpInputFill = Color(0xFFF9FAFB);
}


class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const AuthInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.validator,
  }) : super(key: key);

  @override
  _AuthInputFieldState createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      validator: widget.validator, // Pass the validator to TextFormField
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            4,
          ), // Changed to 4.0 as per your latest code
          borderSide: const BorderSide(
            color: AppColors.inputOutline,
            width: 1,
          ), // Using AppColors
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.inputOutline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 1.5,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textColorSecondary,
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
        ), // Adjusted label style
        hintStyle: const TextStyle(
          color: AppColors.inputHintColor,
          fontSize: 10,
        ), // Adjusted hint style
        filled: true,
        fillColor: Colors.white, // As per your latest code
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 16.0,
        ), // Adjusted content padding
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Color(0x661B1D2A),
            //color: AppColors.textColorSecondary,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : widget
            .suffixIcon, // Use custom suffix if provided and not password
      ),
    );
  }
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reset Password Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', // Assuming 'Poppins' is available
      ),
      home: ResetPasswordPage(),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
                    // Handle back button press (e.g., Navigator.pop(context))
                    Navigator.of(context).pop(); // Makes the back arrow workable
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
                'Reset Password',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),

              // Subtitle
              const Text(
                'Please enter a new password for your account.',
                style: TextStyle(
                  fontSize: 12.0,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),

              // Form for input fields
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // New Password Input
                    AuthInputField(
                      controller: _newPasswordController,
                      labelText: 'New Password', // No asterisk in design
                      hintText: 'Enter new password..',
                      isPassword: true,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter your new password';
                      //   }
                      //   if (value.length < 6) {
                      //     return 'Password must be at least 6 characters';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 20.0),

                    // Confirm Password Input
                    AuthInputField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password', // No asterisk in design
                      hintText: 'Enter confirm password..',
                      isPassword: true,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please confirm your new password';
                      //   }
                      //   if (value != _newPasswordController.text) {
                      //     return 'Passwords do not match';
                      //   }
                      //   return null;
                      // },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),

              // Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/pass_cng_succussful');
                    // if (_formKey.currentState!.validate()) {
                    //   // If the form is valid, display a snackbar or proceed with password reset
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Resetting Password...')),
                    //   );
                    //   // Here you would typically send the new password to your backend
                    //   print('New Password: ${_newPasswordController.text}');
                    // }
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
                    'Done',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
