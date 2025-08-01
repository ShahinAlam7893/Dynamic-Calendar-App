import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/presentation/common_providers/auth_provider.dart';

// In your actual project, these classes would be separate files.
// For self-containment in this example, we'll keep them here.
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
  static const Color textColorPrimary = Color(0xE51B1D2A); // Added this for consistency
}
class AppAssets {
  static const String calendarIcon = 'assets/icons/calendar_icon.png'; // Placeholder for the asset path
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
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.inputOutline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.inputOutline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textColorSecondary,
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          color: AppColors.inputHintColor,
          fontSize: 10,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppColors.textColorSecondary,
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

// The main SignUpPage widget
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // This is the function that will be called on button press
  void _handleSignUp(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing...')),
      );

      final success = await authProvider.registerUser(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (success) {
        // Handle successful registration
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: AppColors.primaryBlue,
          ),
        );
        // Navigate to the home page or a verification page
        context.push('/login');
      } else {
        // Handle failed registration, show the error message from the provider
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Registration failed.'),
            backgroundColor: Colors.redAccent, // Use a red color for error messages
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // We use a Consumer to listen to the provider's state, specifically for loading
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
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
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      AppAssets.calendarIcon,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.calendar_month, color: AppColors.primaryBlue, size: 80),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Dynamic Social Calendar',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Connect, Plan, and Play Together',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppColors.textMedium,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    'A secure platform for parents to coordinate children\'s activities',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthInputField(
                          controller: _fullNameController,
                          labelText: 'Full Name *',
                          hintText: 'Enter your full name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        AuthInputField(
                          controller: _emailController,
                          labelText: 'Email Address *',
                          hintText: 'Enter your email..',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Expanded(
                              child: AuthInputField(
                                controller: _passwordController,
                                labelText: 'Password *',
                                hintText: 'Enter your password...',
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: AuthInputField(
                                controller: _confirmPasswordController,
                                labelText: 'Confirm Password *',
                                hintText: 'Enter confirm password...',
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    child: DottedBorder(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      strokeWidth: 2,
                      dashPattern: const [6, 3],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlueBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.camera_alt, size: 40.0, color: AppColors.textMedium),
                            const SizedBox(width: 10.0),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upload your photo',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.accentBlue,
                                  ),
                                ),
                                Text(
                                  'JPG, PNG up to 5MB',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : () => _handleSignUp(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 3,
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(fontSize: 15.0, color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/login');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    ),
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                      height: 30.0,
                      width: 30.0,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.g_mobiledata,
                          size: 30.0,
                          color: AppColors.primaryBlue,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}