import 'package:circleslate/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'; // Make sure you have this package in your pubspec.yaml
import 'package:circleslate/core//constants/app_colors.dart';
import 'package:go_router/go_router.dart';

// This would typically be in lib/core/constants/app_colors.dart
class AppColors {
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color inputBorderColor = Colors.grey;
  static const Color textColorSecondary = Color(0xFF333333);
  static const Color inputHintColor = Colors.grey;
  static const Color lightBlueBackground = Color(
    0x1AD8ECFF,
  ); // Corresponds to 0x1AD8ECFF
  static const Color textDark = Color(0xE51B1D2A); // Corresponds to 0xE51B1D2A
  static const Color textMedium = Color(
    0x991B1D2A,
  ); // Corresponds to 0x991B1D2A
  static const Color textLight = Color(0xB21B1D2A); // Corresponds to 0xB21B1D2A
  static const Color accentBlue = Color(
    0xFF5A8DEE,
  ); // Corresponds to 0xFF5A8DEE
  static const Color inputOutline = Color(0x1A101010);

  //static var textColorPrimary; // Corresponds to 0x1A101010
}

// This would typically be in lib/core/constants/app_assets.dart
// For demonstration, we'll use a placeholder for calendarIcon

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Ensure 'Poppins' font is added to your pubspec.yaml if you want to use it
        // Otherwise, Flutter will fall back to a default font.
        fontFamily: 'Poppins',
      ),
      home: SignUpPage(),
    );
  }
}

// This would typically be in lib/presentation/widgets/auth_input_field.dart
class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword; // Set to true for password fields
  final Widget? suffixIcon; // For custom suffix icons if needed
  final String? Function(String?)? validator; // Added validator property

  const AuthInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.validator, // Initialize validator
  }) : super(key: key);

  @override
  _AuthInputFieldState createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText =
        widget.isPassword; // Initially obscure if it's a password field
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
                  color: AppColors.textColorSecondary,
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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Global key for the form
  final _formKey = GlobalKey<FormState>();

  // Declare TextEditingControllers for each input field
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources when the widget is removed from the tree
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 24,
                  ), // Customize icon and color
                  onPressed: () {
                    print('button pressed');
                    context.pop();
                    // _pageController.previousPage(
                    //   duration: const Duration(milliseconds: 300),
                    //   curve: Curves.easeIn,
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
                child: Image.asset(
                  AppAssets
                      .calendarIcon, // This should be your circle-themed illustration
                  width: 80, // Adjust size of the image within the circle
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20.0),

              // Title
              const Text(
                'Dynamic Social Calendar',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark, // Using AppColors
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),

              // Subtitle
              const Text(
                'Connect, Plan, and Play Together',
                style: TextStyle(
                  fontSize: 12.0,
                  color: AppColors.textMedium, // Using AppColors
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4.0),
              const Text(
                'A secure platform for parents to coordinate children\'s activities',
                style: TextStyle(
                  fontSize: 10.0,
                  color: AppColors.textLight, // Using AppColors
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),

              // Form for input fields
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Full Name Input using AuthInputField
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

                    // Email Address Input using AuthInputField
                    AuthInputField(
                      controller: _emailController,
                      labelText: 'Email Address *',
                      hintText: 'Enter your email..',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        // Simple email validation regex
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),

                    // Password and Confirm Password using AuthInputField
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

              // Upload Photo Section
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10.0,
                ),
                child: DottedBorder(
                  color: Colors.blue.withOpacity(0.3), // Border color
                  strokeWidth: 2, // Border thickness
                  dashPattern: const [
                    6,
                    3,
                  ], // Dash pattern: [dash length, gap length]
                  borderType: BorderType.RRect, // Border type (Rounded)
                  radius: const Radius.circular(12.0), // Corner radius
                  child: Container(
                    width: double
                        .infinity, // Ensure it takes full width within DottedBorder
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ), // Adjusted padding
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueBackground, // Using AppColors
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      // Changed to Row for horizontal layout
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 40.0,
                          color: AppColors.textMedium, // Using AppColors
                        ),
                        const SizedBox(
                          width: 10.0,
                        ), // Added spacing between icon and text
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Align text to start
                          children: [
                            const Text(
                              'Upload your photo',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.accentBlue, // Using AppColors
                              ),
                            ),
                            const Text(
                              'JPG, PNG up to 5MB',
                              style: TextStyle(
                                fontSize: 10.0,
                                color: AppColors.textLight, // Using AppColors
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

              // Create Account Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar or proceed with signup
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      // Here you would typically send data to your backend
                      print('Full Name: ${_fullNameController.text}');
                      print('Email: ${_emailController.text}');
                      print('Password: ${_passwordController.text}');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue, // Using AppColors
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
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

              // Already have an account? Login
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
                        color: AppColors.primaryBlue, // Using AppColors
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Google Sign-in Icon
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
                    ); // Fallback icon, using AppColors
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
