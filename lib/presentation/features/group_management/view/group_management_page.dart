import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
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
  final String imageUrl;
  MemberRole role; // Role can be changed

  GroupMember({
    required this.id,
    required this.name,
    required this.email,
    required this.children,
    required this.imageUrl,
    this.role = MemberRole.member, // Default to member
  });
}


class GroupManagementPage extends StatefulWidget {
  const GroupManagementPage({super.key});

  @override
  State<GroupManagementPage> createState() => _GroupManagementPageState();
}

class _GroupManagementPageState extends State<GroupManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<GroupMember> _allMembers = [];
  List<GroupMember> _filteredMembers = [];
  int _selectedIndex = 2; // Assuming 'Groups' is the 3rd tab (index 2)

  // Dummy data for group members
  final List<GroupMember> initialMembers = [
    GroupMember(
      id: '1',
      name: 'Peter Johnson',
      email: 'peterjohnson@gmail.com',
      children: 'Ella',
      imageUrl: AppAssets.peterJohnson,
      role: MemberRole.admin,
    ),
    GroupMember(
      id: '2',
      name: 'Sarah Wilson',
      email: 'sarahwilson@gmail.com',
      children: 'Jen',
      imageUrl: AppAssets.sarahMartinez, // Using Sarah Martinez for Sarah Wilson
      role: MemberRole.member,
    ),
    GroupMember(
      id: '3',
      name: 'Lisa Chen',
      email: 'lisachen@gmail.com',
      children: 'Alex, Maria',
      imageUrl: AppAssets.lisaProfile,
      role: MemberRole.member,
    ),
    GroupMember(
      id: '4',
      name: 'John Smith',
      email: 'johnsmith@gmail.com',
      children: 'Jake',
      imageUrl: AppAssets.johnProfile,
      role: MemberRole.member,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _allMembers = List.from(initialMembers);
    _filteredMembers = List.from(initialMembers);
    _searchController.addListener(_filterMembers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        return member.name.toLowerCase().contains(query) ||
            member.email.toLowerCase().contains(query) ||
            member.children.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Use GoRouter for navigation
      if (index == 0) {
        context.go(RoutePaths.home);
      } else if (index == 1) {
        context.go(RoutePaths.upcomingeventspage); // Corrected from upcomingeventspage
      } else if (index == 2) {
        // Already on groups page, do nothing or refresh
      } else if (index == 3) {
        // context.go(RoutePaths.availability); // Corrected from commented out
      } else if (index == 4) {
        // context.go(RoutePaths.settings); // Corrected from commented out
      }
    });
  }

  void _deleteMember(GroupMember member) {
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
                  color: AppColors.delete, // Use the delete color for the icon
                  size: 60.0,
                ),
                const SizedBox(height: 20.0),
                // Title
                const Text(
                  'Are you sure you want to Remove this Member?',
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
                            fontWeight: FontWeight.w500,
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
                          setState(() {
                            _allMembers.removeWhere((m) => m.id == member.id);
                            _filterMembers(); // Re-filter the list after deletion
                          });
                          Navigator.of(context).pop(); // Dismiss dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${member.name} has been removed.')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.delete, // Red for Remove button
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Remove',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
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

  void _toggleMemberRole(GroupMember member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Role'),
          content: Text('Change role for ${member.name} to:'),
          actions: <Widget>[
            TextButton(
              child: const Text('Member'),
              onPressed: () {
                setState(() {
                  member.role = MemberRole.member;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${member.name} is now a Member.')),
                );
              },
            ),
            TextButton(
              child: const Text('Admin'),
              onPressed: () {
                setState(() {
                  member.role = MemberRole.admin;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${member.name} is now an Admin.')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Function to navigate to AddMemberPage and handle the result
  void _navigateToAddMember() async {
    final newMember = await context.push(RoutePaths.addmemberpage);
    if (newMember != null && newMember is GroupMember) {
      setState(() {
        _allMembers.add(newMember); // Add new member to the list
        _filterMembers(); // Re-filter to include the new member
      });
    }
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
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Group Management',
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
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              context.go(RoutePaths.chatlistpage); // Corrected from chatlistpage
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search members or children',
                hintStyle: const TextStyle(color: AppColors.textColorSecondary, fontFamily: 'Poppins'),
                prefixIcon: const Icon(Icons.search, color: AppColors.textColorSecondary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Members',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColorPrimary, // Corrected from textColorPrimary
                    fontFamily: 'Poppins',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFD8ECFF), // Corrected from hardcoded color
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    '${_filteredMembers.length} members',
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.buttonPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredMembers.length,
              itemBuilder: (context, index) {
                final member = _filteredMembers[index];
                return _buildMemberCard(member);
              },
            ),
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('View More Tapped')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue, // Corrected from buttonPrimary
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  side: const BorderSide(color: AppColors.primaryBlue, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'View More',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              // const SizedBox(width: 50.0),
              FloatingActionButton(
                onPressed: _navigateToAddMember, // Call the navigation function
                backgroundColor: Colors.white,
                mini: true, // Make it a small button
                child: const Icon(Icons.add, color: AppColors.primaryBlue), // Corrected from buttonPrimary
              ),
            ],
          ),
        ],
      ),

    );
  }

  Widget _buildMemberCard(GroupMember member) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: Image.asset(
                    member.imageUrl,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
                  ).image,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            member.name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColorPrimary, // Corrected from textColorPrimary
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: member.role == MemberRole.admin
                                  ? AppColors.adminTagColor
                                  : AppColors.memberTagColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              member.role == MemberRole.admin ? 'Admin' : 'Member',
                              style: const TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.tagTextColor,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        member.email,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: AppColors.textColorSecondary, // Corrected from textColorSecondary
                          fontFamily: 'Poppins',
                        ),
                      ),
                      // const SizedBox(height: 4.0),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1, color: Colors.grey), // Divider line
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Children: ${member.children}',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColorSecondary, // Corrected from textColorSecondary
                    fontFamily: 'Poppins',
                  ),
                ),
                // Message Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      icon: Icons.chat_bubble_outline,
                      label: 'Message',
                      onTap: () {
                        context.go(RoutePaths.onetooneconversationpage, extra: member.name); // Corrected from onetooneconversationpage
                      },
                    ),
                    const SizedBox(width: 16.0),
                    // Role Manage Button
                    // _buildActionButton(
                    //   icon: Icons.manage_accounts_outlined,
                    //   label: 'Role Manage',
                    //   onTap: () => _toggleMemberRole(member),
                    // ),
                    // Delete Button
                    _buildActionButton(
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      color: AppColors.delete, // Corrected from delete
                      onTap: () => _deleteMember(member),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = AppColors.primaryBlue, // Default color
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4.0),
          // Text(
          //   label,
          //   style: TextStyle(
          //     fontSize: 12.0,
          //     color: color,
          //     fontFamily: 'Poppins',
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
        ],
      ),
    );
  }
}
