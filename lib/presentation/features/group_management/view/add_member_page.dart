import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/presentation/features/group_management/view/add_member_page.dart' hide AppColors, AppAssets;
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// --- GroupMember Model (Copied from group_management_page.dart) ---
enum MemberRole { admin, member }

class GroupMember {
  final String id; // Unique ID for each member
  final String name;
  final String email;
  final String children;
  MemberRole role; // Role can be changed
  final String imageUrl; // Added imageUrl for consistency

  GroupMember({
    required this.id,
    required this.name,
    required this.email,
    required this.children,
    required this.imageUrl,
    this.role = MemberRole.member, // Default to member
  });
}


class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}
// ... (imports and other code remain unchanged)

class _AddMemberPageState extends State<AddMemberPage> {
  final TextEditingController _parentsNameController = TextEditingController();
  final TextEditingController _parentsEmailController = TextEditingController();
  final TextEditingController _myChildrenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isNameAutoPopulated = false;

  String? _selectedRole = 'Member'; // Default role

  final Map<String, Map<String, String>> _parentData = {
    'nicolas.david@email.com': {
      'name': 'Nicolas David',
      'children': 'Nick Rio',
      'imageUrl': AppAssets.davidkimProfile,
    },
    'peterjohnson@gmail.com': {
      'name': 'Peter Johnson',
      'children': 'Ella',
      'imageUrl': AppAssets.peterJohnson,
    },
    'sarahwilson@gmail.com': {
      'name': 'Sarah Wilson',
      'children': 'Jen',
      'imageUrl': AppAssets.sarahMartinez,
    },
    'lisachen@gmail.com': {
      'name': 'Lisa Chen',
      'children': 'Alex, Maria',
      'imageUrl': AppAssets.lisaProfile,
    },
    'johnsmith@gmail.com': {
      'name': 'John Smith',
      'children': 'Jake',
      'imageUrl': AppAssets.johnProfile,
    },
  };

  @override
  void initState() {
    super.initState();
    _parentsEmailController.addListener(_autoPopulateParentInfo);
  }

  @override
  void dispose() {
    _parentsNameController.dispose();
    _parentsEmailController.removeListener(_autoPopulateParentInfo);
    _parentsEmailController.dispose();
    _myChildrenController.dispose();
    super.dispose();
  }

  void _autoPopulateParentInfo() {
    final email = _parentsEmailController.text.trim().toLowerCase();
    if (_parentData.containsKey(email)) {
      final data = _parentData[email]!;
      if (_parentsNameController.text != (data['name'] ?? '') || !_isNameAutoPopulated) {
        _parentsNameController.text = data['name'] ?? '';
        _isNameAutoPopulated = true;
      }
      _myChildrenController.text = data['children'] ?? '';
    } else {
      _myChildrenController.clear();
      if (_isNameAutoPopulated) {
        _parentsNameController.clear();
        _isNameAutoPopulated = false;
      }
    }
  }

  void _addMember() {
    if (_formKey.currentState!.validate()) {
      final String parentsName = _parentsNameController.text.trim();
      final String parentsEmail = _parentsEmailController.text.trim();
      final String childrenNames = _myChildrenController.text.trim();
      final MemberRole role = _selectedRole == 'Admin' ? MemberRole.admin : MemberRole.member;

      String imageUrl = AppAssets.profilePicture;
      final parentInfo = _parentData[parentsEmail.toLowerCase()];
      if (parentInfo != null && parentInfo.containsKey('imageUrl')) {
        imageUrl = parentInfo['imageUrl']!;
      }

      final newMember = GroupMember(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: parentsName,
        email: parentsEmail,
        children: childrenNames,
        role: role,
        imageUrl: imageUrl,
      );

      Navigator.pop(context, newMember);
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      context.go(RoutePaths.home);
    } else if (index == 1) {
      context.go(RoutePaths.upcomingeventspage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Member',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        //     onPressed: () {
        //       context.go(RoutePaths.chatlistpage);
        //     },
        //   ),
        // ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Parents Name
              const Text(
                'Parents Name',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _parentsNameController,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter parent\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              // Parents Email
              const Text(
                'Parents Email',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _parentsEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'nicolas.david@email.com',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter parent\'s email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              // Role Dropdown
              const Text(
                'Role',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                items: ['Admin', 'Member'].map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please select a role';
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              // My Children
              const Text(
                'My Children',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _myChildrenController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Nick Rio',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 40.0),

              // Add Member Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addMember,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Add Member',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
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
