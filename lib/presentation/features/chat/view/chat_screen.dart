import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- RoutePaths (Copied for self-containment) ---
class RoutePaths {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String forgotpassword = '/forgot-password';
  static const String emailVerification = '/email-verification';
  static const String otpVerificationPage = '/otp-verification';
  static const String resetPasswordPage = '/reset-password';
  static const String passwordResetSuccessPage = '/password-reset-success';
  static const String upcomingEvents = '/upcoming-events';
  static const String createEvent = '/create-event';
  static const String groups = '/groups';
  static const String availability = '/availability';
  static const String settings = '/settings';
  static const String eventDetails = '/event-details';
  static const String rideSharing = '/ride-sharing';
  static const String oneToOneConversation = '/one-to-one-conversation'; // New route for One-to-One Chat
}

// --- CustomBottomNavigationBar (Copied for self-containment) ---
class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note_outlined),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_outlined),
          label: 'Groups',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Availability',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed, // Ensures all labels are visible
      backgroundColor: Colors.white,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

// --- Message Model ---
enum MessageSender { user, other }

class Message {
  final String text;
  final String time;
  final MessageSender sender;
  final String? senderImageUrl;
  final bool isRead; // For read receipts

  const Message({
    required this.text,
    required this.time,
    required this.sender,
    this.senderImageUrl,
    this.isRead = false,
  });
}


class OneToOneConversationPage extends StatefulWidget {
  const OneToOneConversationPage({super.key});

  @override
  State<OneToOneConversationPage> createState() => _OneToOneConversationPageState();
}

class _OneToOneConversationPageState extends State<OneToOneConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  int _selectedIndex = 0; // Default selected index for bottom nav bar (not used on this page, but kept for consistency)

  final List<Message> messages = const [
    Message(
      text: 'Hi! Thanks for accepting to give Jenny a ride home from soccer practice! 😊',
      time: '9:00 AM',
      sender: MessageSender.other,
      senderImageUrl: AppAssets.sarahMartinez, // Assuming Sarah Martinez is the other person
      isRead: true,
    ),
    Message(
      text: 'No problem at all! Happy to help. Jenny and Ella are good friends �',
      time: '9:36',
      sender: MessageSender.user,
      senderImageUrl: AppAssets.johnProfile, // Assuming John is the current user
      isRead: true,
    ),
    Message(
      text: 'Perfect! Practice should end around 4:00 PM. Should I tell Jenny to wait by the main entrance?',
      time: '9:56 AM',
      sender: MessageSender.other,
      senderImageUrl: AppAssets.sarahMartinez,
      isRead: true,
    ),
    Message(
      text: 'Yes, that works perfectly. I\'ll be there around 4:05 PM to pick up both girls. I drive a blue Honda Civic.',
      time: '10:06 AM',
      sender: MessageSender.user,
      senderImageUrl: AppAssets.johnProfile,
      isRead: true,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Use GoRouter for navigation
      if (index == 0) {
        context.go(RoutePaths.home);
      } else if (index == 1) {
        context.go(RoutePaths.upcomingEvents);
      } else if (index == 2) {
        context.go(RoutePaths.groups);
      } else if (index == 3) {
        context.go(RoutePaths.availability);
      } else if (index == 4) {
        context.go(RoutePaths.settings);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
          'Message',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          // The screenshot doesn't show a chat icon here, so I'll omit it for accuracy.
          // If you want it, uncomment the following:
          // IconButton(
          //   icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          //   onPressed: () {
          //     // Handle chat button tap
          //   },
          // ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: messages.length + 1, // +1 for the "Today" separator
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildDateSeparator('Today');
                }
                final message = messages[index - 1]; // Adjust index for messages list
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
      // Bottom navigation bar is not shown in the chat screenshot,
      // but if you need it, uncomment the following:
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   selectedIndex: _selectedIndex,
      //   onItemTapped: _onItemTapped,
      // ),
    );
  }

  Widget _buildDateSeparator(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: AppColors.dateBackground, // Use a light grey for date background
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 12.0,
              color: AppColors.dateText, // Use a darker grey for date text
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final bool isUser = message.sender == MessageSender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min, // Wrap content
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isUser) // Profile picture for other sender
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: Image.asset(
                        message.senderImageUrl ?? AppAssets.profilePicture,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
                      ).image,
                    ),
                  ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.receiverBubbleColor : AppColors.senderBubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12.0),
                        topRight: const Radius.circular(12.0),
                        bottomLeft: isUser ? const Radius.circular(12.0) : const Radius.circular(4.0),
                        bottomRight: isUser ? const Radius.circular(4.0) : const Radius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: AppColors.textDark,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                if (isUser) // Profile picture for user sender
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: Image.asset(
                        message.senderImageUrl ?? AppAssets.profilePicture,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
                      ).image,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isUser) // Read receipt for user's messages
                  Icon(
                    Icons.check, // Single check for sent, double for read
                    size: 14,
                    color: message.isRead ? AppColors.primaryBlue : AppColors.chatTimeColor,
                  ),
                const SizedBox(width: 4.0),
                Text(
                  message.time,
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: AppColors.chatTimeColor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white, // White background for the input bar
      child: Row(
        children: [
          Icon(Icons.add_circle_outline, color: AppColors.textMedium, size: 24), // Plus icon
          const SizedBox(width: 8.0),
          Icon(Icons.camera_alt_outlined, color: AppColors.textMedium, size: 24), // Camera icon
          const SizedBox(width: 8.0),
          Icon(Icons.photo_library_outlined, color: AppColors.textMedium, size: 24), // Gallery icon
          const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: const TextStyle(color: AppColors.inputHintColor, fontSize: 14.0, fontFamily: 'Poppins'),
                filled: true,
                fillColor: AppColors.chatInputFillColor, // Light grey fill
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none, // No border
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                suffixIcon: Icon(Icons.sentiment_satisfied_alt_outlined, color: AppColors.textMedium, size: 24), // Emoji icon
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Icon(Icons.mic_none, color: AppColors.textMedium, size: 24), // Microphone icon
        ],
      ),
    );
  }
}
�