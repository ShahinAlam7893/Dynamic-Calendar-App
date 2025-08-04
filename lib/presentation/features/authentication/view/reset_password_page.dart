import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/presentation/common_providers/auth_provider.dart';
import 'package:circleslate/presentation/widgets/auth_input_field.dart';

// Assuming AppColors and AuthInputField are defined in your project.
class AppColors {
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color inputBorderColor = Colors.grey;
  static const Color textColorSecondary = Color(0x991B1D2A);
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
  final int maxLines;

  const AuthInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
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
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.inputOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.inputOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.primaryBlue),
        ),
        filled: true,
        fillColor: AppColors.otpInputFill,
        labelStyle: const TextStyle(color: AppColors.textMedium),
        hintStyle: const TextStyle(color: AppColors.inputHintColor),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : widget.suffixIcon,
      ),
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

  void _handlePasswordReset(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resetting password...')),
      );

      final success = await authProvider.resetPassword(
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (success) {
        // On success, navigate to the success page
        context.go('/pass_cng_succussful');
      } else {
        // On failure, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? 'Password reset failed.')),
        );
      }
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
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Create a New Password',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Your new password must be different from previous used passwords.',
                style: TextStyle(
                  fontSize: 12.0,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthInputField(
                      controller: _newPasswordController,
                      labelText: 'New Password *',
                      hintText: 'Enter new password...',
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    AuthInputField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password *',
                      hintText: 'Confirm new password...',
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading ? null : () => _handlePasswordReset(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 3,
                      ),
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
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
