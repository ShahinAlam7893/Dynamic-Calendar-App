import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/presentation/features/settings/view/edit_profile_page.dart' hide AppColors, AppAssets;
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // For navigation


// --- AuthInputField (Copied for self-containment) ---
class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool readOnly; // Added readOnly property

  const AuthInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.validator,
    this.readOnly = false, // Default to false
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
      readOnly: widget.readOnly, // Apply readOnly property
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
        labelStyle: const TextStyle(color: AppColors.textColorSecondary, fontSize: 11.0, fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: AppColors.textColorSecondary, fontSize: 10),
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


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Example user data (dynamic data would come from a state management solution or API)
  String _fullName = 'Peter Johnson';
  String _email = 'peter.johnson@email.com';
  String _mobile = '+1 (555) 123-4567';
  List<Map<String, String>> _children = [
    {'name': 'Ella Jonson', 'age': '10 years old'},
  ];
  String _profileImageUrl = AppAssets.peterJohnson; // Placeholder for Peter Johnson's image

  @override
  void initState() {
    super.initState();
    // In a real app, you would fetch user data here
  }

  // Function to show the logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Icon(
                  Icons.error_outline,
                  color: AppColors.unavailableRed, // Red color for warning
                  size: 60.0,
                ),
                const SizedBox(height: 20.0),
                // Title
                const Text(
                  'Are you sure you want to Log Out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColorPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10.0),
                // Subtitle
                const Text(
                  'This action cannot be undone. Are you sure you want to continue?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColorSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 30.0),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss dialog
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          side: const BorderSide(color: AppColors.primaryBlue, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss dialog
                          // Perform actual logout action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logging Out...')),
                          );
                          // Navigate to login/onboarding page after logout
                          context.go(RoutePaths.login); // Example: navigate to login page
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.unavailableRed, // Red for Log Out button
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor: AppColors.buttonPrimary, // Use primary blue for the app bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop(); // Use pop for back navigation
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () async {
              // Navigate to Edit Profile page and wait for result
              final updatedData = await context.push<Map<String, dynamic>>(
                RoutePaths.editProfile,
                extra: {
                  'fullName': _fullName,
                  'email': _email,
                  'mobile': _mobile,
                  'children': _children,
                  'profileImageUrl': _profileImageUrl,
                },
              );

              if (updatedData != null) {
                setState(() {
                  _fullName = updatedData['fullName'] ?? _fullName;
                  _email = updatedData['email'] ?? _email;
                  _mobile = updatedData['mobile'] ?? _mobile;
                  _children = List<Map<String, String>>.from(updatedData['children'] ?? _children);
                  _profileImageUrl = updatedData['profileImageUrl'] ?? _profileImageUrl;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _profileImageUrl.isNotEmpty
                        ? Image.asset(_profileImageUrl).image // Use Image.asset for local assets
                        : null,
                    child: _profileImageUrl.isEmpty
                        ? Icon(Icons.person, size: 60, color: Colors.grey.shade400)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Full Name
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Full Name',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            AuthInputField(
              controller: TextEditingController(text: _fullName),
              labelText: '',
              hintText: '',
              readOnly: true, // Read-only on profile page
            ),
            const SizedBox(height: 20.0),

            // Email
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Email',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            AuthInputField(
              controller: TextEditingController(text: _email),
              labelText: '',
              hintText: '',
              readOnly: true, // Read-only on profile page
            ),
            const SizedBox(height: 20.0),

            // Mobile
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Mobile',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            AuthInputField(
              controller: TextEditingController(text: _mobile),
              labelText: '',
              hintText: '',
              readOnly: true, // Read-only on profile page
            ),
            const SizedBox(height: 20.0),

            // My Children Section
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'My Children',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: AppColors.inputOutline, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  for (var child in _children)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${child['name']}: ${child['age']}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: AppColors.textColorPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          // No "Add Another Child" here, it's on Edit Profile
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),

            // Log Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.unavailableRed, // Red for Log Out
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      // The bottom navigation bar will be provided by SmoothNavigationWrapper
    );
  }
}
