import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- Contact Model (for Direct Invite) ---
class Contact {
  final String id;
  final String name;
  final String children;
  final String imageUrl;

  const Contact({
    required this.id,
    required this.name,
    required this.children,
    required this.imageUrl,
  });
}


class DirectInvitePage extends StatefulWidget {
  const DirectInvitePage({super.key});

  @override
  State<DirectInvitePage> createState() => _DirectInvitePageState();
}

class _DirectInvitePageState extends State<DirectInvitePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  final Set<String> _selectedContactIds = {}; // To keep track of selected contacts
  int _selectedIndex = 2; // Assuming 'Groups' is the 3rd tab (index 2)

  // Dummy data for contacts
  final List<Contact> initialContacts = [
    Contact(
      id: 'sarah_johnson',
      name: 'Sarah Johnson',
      children: 'Emma, Liam',
      imageUrl: AppAssets.sarahMartinez,
    ),
    Contact(
      id: 'mike_chen',
      name: 'Mike Chen',
      children: 'Sophia',
      imageUrl: AppAssets.mikeWilson,
    ),
    Contact(
      id: 'lisa_rodriguez',
      name: 'Lisa Rodriguez',
      children: 'Noah, Olivia',
      imageUrl: AppAssets.lisaProfile,
    ),
    Contact(
      id: 'david_kim',
      name: 'David Kim',
      children: 'Ethan',
      imageUrl: AppAssets.peterJohnson, // Using Peter Johnson for David Kim
    ),
    Contact(
      id: 'jennifer_brown',
      name: 'Jennifer Brown',
      children: 'Ava, Mason',
      imageUrl: AppAssets.jenniferprofile,
    ),
    Contact(
      id: 'tom_willson',
      name: 'Tom Willson',
      children: 'Isabella',
      imageUrl: AppAssets.tomWillson,
    ),
    Contact(
      id: 'amanda_davis',
      name: 'Amanda Davis',
      children: 'James, Charlotte',
      imageUrl: AppAssets.amandaDavis,
    ),
    Contact(
      id: 'robert_garcia',
      name: 'Robert Garcia',
      children: 'Benjamin',
      imageUrl: AppAssets.robertGarcia,
    ),
    Contact(
      id: 'sophie_miller',
      name: 'Sophie Miller',
      children: 'Leo, Chloe',
      imageUrl: AppAssets.sophieMiller,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _allContacts = List.from(initialContacts);
    _filteredContacts = List.from(initialContacts);
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _allContacts.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
            contact.children.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        context.go(RoutePaths.home);
      } else if (index == 1) {
        context.go(RoutePaths.upcomingeventspage);
      } else if (index == 2) {
        context.go(RoutePaths.groupManagement); // Assuming 'Groups' leads to GroupManagementPage
      } else if (index == 3) {
        // context.go(RoutePaths.availability);
      } else if (index == 4) {
        // context.go(RoutePaths.settings);
      }
    });
  }

  void _toggleContactSelection(String contactId, bool? isSelected) {
    setState(() {
      if (isSelected == true) {
        _selectedContactIds.add(contactId);
      } else {
        _selectedContactIds.remove(contactId);
      }
    });
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
          'Direct Invite',
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
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Direct Invitation send successfully done!')),
              );
              // context.go(RoutePaths.); // Redirect to chat list page
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
                hintText: 'Search by parents or children name',
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return _buildContactCard(contact);
              },
            ),
          ),
          // You might want an "Invite" button here, similar to "Add Member"
          // For now, it's not in the screenshot, so I'll omit it.
          // If needed, it would be a SizedBox with an ElevatedButton at the bottom.
        ],
      ),
    );
  }


  Widget _buildContactCard(Contact contact) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            // Avatar with error fallback
            ClipOval(
              child: Image.asset(
                contact.imageUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Name & Children Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColorPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    'Children: ${contact.children}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColorSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            // Checkbox
            Checkbox(
              value: _selectedContactIds.contains(contact.id),
              activeColor: AppColors.primaryBlue,
              onChanged: (bool? selected) {
                _toggleContactSelection(contact.id, selected);
              },
            ),
          ],
        ),
      ),
    );
  }

}
