import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- Chat Model (Copied from chat_list_page.dart for self-containment) ---
enum ChatMessageStatus { sent, delivered, seen }

class Chat {
  final String name;
  final String lastMessage;
  final String time;
  final String imageUrl;
  final int unreadCount;
  final bool isOnline;
  final ChatMessageStatus status;
  final bool isGroupChat;

  const Chat({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrl,
    this.unreadCount = 0,
    this.isOnline = false,
    this.status = ChatMessageStatus.seen,
    this.isGroupChat = false,
  });
}

// --- Contact Model ---
class Contact {
  final String id; // Unique identifier for the contact
  final String name;
  final String description; // e.g., "Children: Emma, Liam"
  final String imageUrl;
  final bool isOnline;

  const Contact({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isOnline = false,
  });
}


class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final Set<Contact> _selectedContacts = {}; // Use a Set for unique selected contacts
  final _formKey = GlobalKey<FormState>(); // Form key for validation


  // Dummy data for available contacts
  final List<Contact> availableContacts = const [
    Contact(
      id: 'sarah_johnson',
      name: 'Sarah Johnson',
      description: 'Children: Emma, Liam',
      imageUrl: AppAssets.sarahMartinez,
      isOnline: true,
    ),
    Contact(
      id: 'mike_chen',
      name: 'Mike Chen',
      description: 'Children: Sophia',
      imageUrl: AppAssets.mikeWilson,
      isOnline: false,
    ),
    Contact(
      id: 'lisa_rodriguez',
      name: 'Lisa Rodriguez',
      description: 'Children: Noah, Olivia',
      imageUrl: AppAssets.lisaProfile,
      isOnline: true,
    ),
    Contact(
      id: 'david_kim',
      name: 'David Kim',
      description: 'Children: Ethan',
      imageUrl: AppAssets.peterJohnson,
      isOnline: false,
    ),
    Contact(
      id: 'jennifer_davis',
      name: 'Jennifer Davis',
      description: 'Children: Mia',
      imageUrl: AppAssets.jenniferDavis,
      isOnline: true,
    ),
    Contact(
      id: 'davide_kim',
      name: 'davide kim',
      description: 'Children: Alex',
      imageUrl: AppAssets.davidkimProfile,
      isOnline: false,
    ),
  ];

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _createGroup() {
    if (_formKey.currentState!.validate()) {
      if (_selectedContacts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one member for the group.')),
        );
        return;
      }

      final String groupName = _groupNameController.text.trim();
      final String groupMembers = _selectedContacts.map((c) => c.name.split(' ')[0]).join(', '); // Get first name of members

      // Create a new Chat object for the group
      final newGroupChat = Chat(
        name: groupName,
        lastMessage: 'You created the group with $groupMembers.',
        time: 'Now', // Or use a formatted DateTime.now()
        imageUrl: AppAssets.groupChatIcon,
        unreadCount: 0,
        isOnline: true,
        status: ChatMessageStatus.seen,
        isGroupChat: true,
      );

      // FIX: Defer the pop operation to the next frame to avoid the !_debugLocked assertion
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Navigator.pop(context, newGroupChat);
      // });
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
            context.pop();
            // Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Create Group',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Group Name',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorPrimary, // Changed from textColorPrimary
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      hintStyle: const TextStyle(color: AppColors.textColorSecondary, fontFamily: 'Poppins'), // Changed from textColorSecondary
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Group name cannot be empty';
                      }
                      return null;
                    },

                  ),
                  const Text(
                    'Search Name',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorPrimary, // Changed from textColorPrimary
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    // controller: _groupNameController,
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      hintStyle: const TextStyle(color: AppColors.textColorSecondary, fontFamily: 'Poppins'), // Changed from textColorSecondary
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Find a contact to add to the group';
                      }
                      return null;
                    },

                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: availableContacts.length,
                itemBuilder: (context, index) {
                  final contact = availableContacts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor: AppColors.primaryBlue,
                      checkColor: Colors.white,
                      value: _selectedContacts.contains(contact),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedContacts.add(contact);
                          } else {
                            _selectedContacts.remove(contact);
                          }
                        });
                      },
                      title: Text(
                        contact.name,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColorPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      subtitle: Text(
                        contact.description,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: AppColors.textColorSecondary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      secondary: Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            // Ensure backgroundImage always receives a valid ImageProvider
                            backgroundImage: contact.imageUrl.isNotEmpty
                                ? AssetImage(contact.imageUrl)
                                : AssetImage(AppAssets.profilePicture), // Fallback
                          ),
                          if (contact.isOnline)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: AppColors.onlineIndicator,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: SizedBox(
                height: 32,
                width: 81,
                child: ElevatedButton(
                  onPressed: _createGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Create Group',
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
