import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/presentation/features/settings/view/edit_profile_page.dart' hide AppColors, AppAssets;
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // ✅ For AuthProvider
import '../../../common_providers/auth_provider.dart'; // ✅ Your AuthProvider

// --- AuthInputField (Unchanged) ---
class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool readOnly;

  const AuthInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.validator,
    this.readOnly = false,
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
      readOnly: widget.readOnly,
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
  String _fullName = '';
  String _email = '';
  String _mobile = '';
  List<Map<String, String>> _children = [];
  String _profileImageUrl = '';

  @override
  void initState() {
    super.initState();

    // ✅ Fetch real profile data from AuthProvider
    Future.microtask(() async {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.fetchUserProfile();
      if (success && mounted) {
        final profile = authProvider.userProfile ?? {};

        setState(() {
          _fullName = profile['full_name'] ?? '';
          _email = profile['email'] ?? '';
          _mobile = profile['phone_number'] ?? '';
          _profileImageUrl = profile['profile_photo'] ?? '';
          // Convert children list from API to List<Map<String, String>>
          _children = (profile['children'] as List<dynamic>? ?? [])
              .map((child) => {
            'name': child['name']?.toString() ?? '',
            'age': child['age']?.toString() ?? '',
          })
              .toList();
        });

        debugPrint("✅ Loaded Profile: $_fullName, $_email, $_mobile");
      } else {
        debugPrint("❌ Failed to fetch profile data.");
      }
    });
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.error_outline, color: AppColors.unavailableRed, size: 60.0),
              const SizedBox(height: 20.0),
              const Text(
                'Are you sure you want to Log Out?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.textColorPrimary, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'This action cannot be undone. Are you sure you want to continue?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: AppColors.textColorSecondary, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 30.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      side: const BorderSide(color: AppColors.primaryBlue, width: 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: AppColors.primaryBlue, fontFamily: 'Poppins')),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logging Out...')));
                      context.go(RoutePaths.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.unavailableRed,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 3,
                    ),
                    child: const Text('Log Out', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Poppins')),
                  ),
                ),
              ]),
            ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.buttonPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () async {
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!')));
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: _profileImageUrl.isNotEmpty
                      ? (_profileImageUrl.startsWith("http")
                      ? NetworkImage(_profileImageUrl)
                      : AssetImage(_profileImageUrl) as ImageProvider)
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
            child: Text('Full Name', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.textColorPrimary, fontFamily: 'Poppins')),
          ),
          AuthInputField(controller: TextEditingController(text: _fullName), labelText: '', hintText: '', readOnly: true),
          const SizedBox(height: 20.0),

          // Email
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Email', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.textColorPrimary, fontFamily: 'Poppins')),
          ),
          AuthInputField(controller: TextEditingController(text: _email), labelText: '', hintText: '', readOnly: true),
          const SizedBox(height: 20.0),

          // Mobile
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Mobile', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.textColorPrimary, fontFamily: 'Poppins')),
          ),
          AuthInputField(controller: TextEditingController(text: _mobile), labelText: '', hintText: '', readOnly: true),
          const SizedBox(height: 20.0),

          // My Children
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('My Children', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.textColorPrimary, fontFamily: 'Poppins')),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.inputOutline, width: 1),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: _children.isEmpty
                  ? [const Text("No children added.")]
                  : _children.map((child) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('${child['name']}: ${child['age']}',
                            style: const TextStyle(fontSize: 16.0, color: AppColors.textColorPrimary, fontFamily: 'Poppins')),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 30.0),

          // Log Out Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showLogoutConfirmationDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.unavailableRed,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 3,
              ),
              child: const Text('Log Out', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins')),
            ),
          ),
          const SizedBox(height: 20.0),
        ]),
      ),
    );
  }
}
