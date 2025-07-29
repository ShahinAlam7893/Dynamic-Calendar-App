import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ... (existing imports)

// --- Chat Model ---
enum ChatMessageStatus { sent, delivered, seen } // New enum for chat list item status

class Chat {
  final String name;
  final String lastMessage;
  final String time;
  final String imageUrl;
  final int unreadCount;
  final bool isOnline;
  final ChatMessageStatus status; // New field for message status in chat list
  final bool isGroupChat; // New field to distinguish group chats
  // You might add a list of member IDs and their roles for more complex group logic
  final bool? isCurrentUserAdminInGroup; // Added for demonstrating admin status in a group

  const Chat({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrl,
    this.unreadCount = 0,
    this.isOnline = false,
    this.status = ChatMessageStatus.seen, // Default status for demo data
    this.isGroupChat = false, // Default to false for demo data
    this.isCurrentUserAdminInGroup, // Initialize the new field
  });
}

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  int _selectedIndex = 0; // Default selected index for bottom nav bar
  final TextEditingController _searchController = TextEditingController(); // Controller for search field
  List<Chat> _filteredChats = []; // List to hold filtered chats

  // Placeholder for current user's admin status.
  // In a real application, this would come from your authentication system.
  bool _isCurrentUserAdmin = true; // Set to true for demonstration

  // Demo chat data
  final List<Chat> chats = const [
    Chat(
      name: 'Sarah Martinez',
      lastMessage: 'Perfect! Practice should end around 4:00 PM.',
      time: '9:56 AM',
      imageUrl: AppAssets.sarahMartinez,
      unreadCount: 0,
      isOnline: true,
      status: ChatMessageStatus.seen,
    ),
    Chat(
      name: 'Peter Johnson',
      lastMessage: 'Hey, are you free this weekend?',
      time: 'Yesterday',
      imageUrl: AppAssets.peterJohnson,
      unreadCount: 2,
      isOnline: false,
      status: ChatMessageStatus.delivered, // Example: delivered but not seen
    ),
    Chat(
      name: 'Family Group', // Group chat example
      lastMessage: 'Don\'t forget the snacks for the picnic!',
      time: 'Mon',
      imageUrl: AppAssets.groupChatIcon, // Use a generic group icon or specific asset
      unreadCount: 5,
      isOnline: true, // A group can be considered "online" if active members are online
      status: ChatMessageStatus.seen, // Status for the last message in the group
      isGroupChat: true,
      isCurrentUserAdminInGroup: true, // Example: Current user is admin in this group
    ),
    Chat(
      name: 'Mike Wilson',
      lastMessage: 'Thanks for the ride!',
      time: 'Mon',
      imageUrl: AppAssets.mikeWilson,
      unreadCount: 0,
      isOnline: true,
      status: ChatMessageStatus.seen,
    ),
    Chat(
      name: 'Jennifer Davis',
      lastMessage: 'See you there!',
      time: '1/20/25',
      imageUrl: AppAssets.jenniferDavis,
      unreadCount: 0,
      isOnline: false,
      status: ChatMessageStatus.sent, // Example: sent but not delivered/seen
    ),
    Chat(
      name: 'Lisa Smith',
      lastMessage: 'Are we still on for tomorrow?',
      time: '1/15/25',
      imageUrl: AppAssets.lisaProfile,
      unreadCount: 1,
      isOnline: true,
      status: ChatMessageStatus.delivered,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredChats = chats; // Initialize filtered chats with all chats
    _searchController.addListener(_filterChats); // Add listener for search input changes
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterChats() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChats = chats.where((chat) {
        return chat.name.toLowerCase().contains(query) ||
            chat.lastMessage.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          // Add "Create Group" button
          TextButton(
            onPressed: () {
              context.push('/group_chat');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create Group Tapped!')),
              );
            },
            child: const Text(
              'Create Group',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
      body: Column(
        // Use Column to stack search bar and list view
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search messages...',
                hintStyle: const TextStyle(
                    color: AppColors.textColorSecondary, fontFamily: 'Poppins'),
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textColorPrimary), // Changed to textMedium
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Adjust padding for list items
              itemCount: _filteredChats.length,
              itemBuilder: (context, index) {
                final chat = _filteredChats[index]; // Use filtered chats
                return _buildChatItem(context, chat);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, Chat chat) {
    return GestureDetector(
      onTap: () {
        // Pass chat name, isGroupChat, and admin status
        context.push(
          RoutePaths.onetooneconversationpage,
          extra: {
            'chatPartnerName': chat.name,
            'isGroupChat': chat.isGroupChat,
            'isCurrentUserAdminInGroup': chat.isGroupChat ? (chat.isCurrentUserAdminInGroup ?? false) : false,
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: Image.asset(
                      chat.imageUrl,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person),
                    ).image,
                  ),



                  // +++++++++++++++++++a person online or not +++++++++++++++++++++++++++++++
                  // if (chat.isOnline)
                  //   Positioned(
                  //     bottom: 0,
                  //     right: 0,
                  //     child: Container(
                  //       width: 12,
                  //       height: 12,
                  //       decoration: BoxDecoration(
                  //         color: AppColors.onlineIndicator,
                  //         shape: BoxShape.circle,
                  //         border: Border.all(color: Colors.white, width: 2),
                  //       ),
                  //     ),
                  //   ),

                  
                ],
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          chat.name,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A), // Using AppColors.textDark
                            fontFamily: 'Poppins',
                          ),
                        ),
                        if (chat.isGroupChat) // Display group icon if it's a group chat
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.group, // Group icon
                              size: 12,
                              color: AppColors.textColorSecondary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      chat.lastMessage,
                      style: TextStyle(
                        fontSize: 9.0,
                        color: chat.unreadCount > 0
                            ? AppColors.textColorPrimary
                            : AppColors.textColorSecondary, // Using AppColors
                        fontWeight:
                        chat.unreadCount > 0 ? FontWeight.w500 : FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    // Row for time and checkmark
                    children: [
                      Text(
                        chat.time,
                        style: TextStyle(
                          fontSize: 12.0,
                          // color: chat.unreadCount > 0 ? AppColors.unreadCountBg : AppColors.textColorSecondary, // Using AppColors
                          // fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 4.0), // Spacing between time and checkmark
                      if (chat.status == ChatMessageStatus.sent)
                        Icon(Icons.check,
                            size: 14,
                            color: AppColors.textColorSecondary), // Single gray check
                      if (chat.status == ChatMessageStatus.delivered)
                        Row(
                          children: const [
                            Icon(Icons.check,
                                size: 14, color: AppColors.textColorSecondary),
                            Icon(Icons.check,
                                size: 14,
                                color:
                                AppColors.textColorSecondary), // Double gray check
                          ],
                        ),
                      if (chat.status == ChatMessageStatus.seen)
                        Row(
                          children: const [
                            Icon(Icons.check,
                                size: 12, color: AppColors.primaryBlue),
                            Icon(Icons.check,
                                size: 12,
                                color:
                                AppColors.primaryBlue), // Double blue check
                          ],
                        ),
                    ],
                  ),
                  if (chat.unreadCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: AppColors.unreadCountBg,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          chat.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}