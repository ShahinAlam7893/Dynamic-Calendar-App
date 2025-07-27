import 'package:circleslate/core/constants/app_colors.dart';
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


class EditProfilePage extends StatefulWidget {
  final String initialFullName;
  final String initialEmail;
  final String initialMobile;
  final List<Map<String, String>> initialChildren;
  final String initialProfileImageUrl;

  const EditProfilePage({
    super.key,
    required this.initialFullName,
    required this.initialEmail,
    required this.initialMobile,
    required this.initialChildren,
    required this.initialProfileImageUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late List<TextEditingController> _childNameControllers;
  late List<TextEditingController> _childAgeControllers;
  late String _currentProfileImageUrl;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.initialFullName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _mobileController = TextEditingController(text: widget.initialMobile);
    _currentProfileImageUrl = widget.initialProfileImageUrl;

    _childNameControllers = widget.initialChildren
        .map((child) => TextEditingController(text: child['name']))
        .toList();
    _childAgeControllers = widget.initialChildren
        .map((child) => TextEditingController(text: child['age']))
        .toList();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    for (var controller in _childNameControllers) {
      controller.dispose();
    }
    for (var controller in _childAgeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addChildField() {
    setState(() {
      _childNameControllers.add(TextEditingController());
      _childAgeControllers.add(TextEditingController());
    });
  }

  void _removeChildField(int index) {
    setState(() {
      _childNameControllers[index].dispose();
      _childAgeControllers[index].dispose();
      _childNameControllers.removeAt(index);
      _childAgeControllers.removeAt(index);
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Collect updated children data
      List<Map<String, String>> updatedChildren = [];
      for (int i = 0; i < _childNameControllers.length; i++) {
        updatedChildren.add({
          'name': _childNameControllers[i].text,
          'age': _childAgeControllers[i].text,
        });
      }

      // Prepare data to return to the previous page (ProfilePage)
      final updatedData = {
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'children': updatedChildren,
        'profileImageUrl': _currentProfileImageUrl,
      };

      // In a real app, you would send this data to your backend API to save.
      // For this example, we'll just pop back with the data.
      context.pop(updatedData);
    }
  }

  // Placeholder for image picking logic
  void _pickImage() {
    // Implement image picking logic (e.g., using image_picker package)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker not implemented yet.')),
    );
    // After picking, update _currentProfileImageUrl
    // setState(() {
    //   _currentProfileImageUrl = 'new_image_path.png'; // Update with actual picked image path
    // });
  }

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
          'Edit Profile',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _currentProfileImageUrl.isNotEmpty
                          ? Image.asset(_currentProfileImageUrl).image
                          : null,
                      child: _currentProfileImageUrl.isEmpty
                          ? Icon(Icons.person, size: 60, color: Colors.grey.shade400)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage, // Call image picker on tap
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
                controller: _fullNameController,
                labelText: '',
                hintText: 'Nicolas David', // Example hint
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
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
                controller: _emailController,
                labelText: '',
                hintText: 'nicolas.david@email.com', // Example hint
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
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
                controller: _mobileController,
                labelText: '',
                hintText: '+1 (555) 123-4567', // Example hint
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              // My Children Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  GestureDetector(
                    onTap: _addChildField,
                    child: const Text(
                      '+ Add Another Child',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryBlue,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
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
                    for (int i = 0; i < _childNameControllers.length; i++)
                      _buildChildInputField(i),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Save',
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
      ),
      // The bottom navigation bar will be provided by SmoothNavigationWrapper
    );
  }

  Widget _buildChildInputField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AuthInputField(
              controller: _childNameControllers[index],
              labelText: 'Child\'s Name',
              hintText: 'Child\'s name please..',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter child\'s name';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            flex: 1,
            child: AuthInputField(
              controller: _childAgeControllers[index],
              labelText: 'Age',
              hintText: 'Age',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter age';
                }
                return null;
              },
            ),
          ),
          if (index > 0) // Show remove button for additional children
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: AppColors.unavailableRed),
              onPressed: () => _removeChildField(index),
            ),
        ],
      ),
    );
  }
}
