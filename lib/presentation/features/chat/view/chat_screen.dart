import 'package:circleslate/presentation/features/chat/view/chat_screen.dart';
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For date and time formatting
import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
// ... (existing imports)

// --- Message Model ---
enum MessageSender { user, other }
enum MessageStatus { sent, delivered, seen }

class Message {
  final String text;
  final DateTime timestamp;
  final MessageSender sender;
  final String? senderImageUrl;
  final MessageStatus status;
  const Message({
    required this.text,
    required this.timestamp,
    required this.sender,
    this.senderImageUrl,
    this.status = MessageStatus.sent, // Default to sent
  });
}

class OneToOneConversationPage extends StatefulWidget {
  final String chatPartnerName;
  final bool isGroupChat; // New parameter to indicate if it's a group chat
  final bool isCurrentUserAdminInGroup; // New parameter for admin status

  const OneToOneConversationPage({
    super.key,
    required this.chatPartnerName,
    this.isGroupChat = false, // Default to false
    this.isCurrentUserAdminInGroup = false, // Default to false
  });

  @override
  State<OneToOneConversationPage> createState() =>
      _OneToOneConversationPageState();
}

class _OneToOneConversationPageState extends State<OneToOneConversationPage> {
  final TextEditingController _messageController = TextEditingController();

  final List<Message> messages = [
    Message(
      text:
      'Hi! Thanks for accepting to give Jenny a ride home from soccer practice! 😊',
      timestamp: DateTime(2025, 7, 25, 9, 0), // July 25, 9:00 AM
      sender: MessageSender.other,
      senderImageUrl:
      AppAssets.sarahMartinez, // Assuming Sarah Martinez is the other person
      status: MessageStatus.seen,
    ),
    Message(
      text:
      'No problem at all! Happy to help. Jenny and Ella are good friends 👍',
      timestamp: DateTime(2025, 7, 25, 9, 36), // July 25, 9:36 AM
      sender: MessageSender.user,
      senderImageUrl:
      AppAssets.jennyProfile, // Assuming Jenny is the current user
      status: MessageStatus.seen,
    ),
    Message(
      text:
      'Perfect! Practice should end around 4:00 PM. Should I tell Jenny to wait by the main entrance?',
      timestamp: DateTime(2025, 7, 25, 9, 56), // July 25, 9:56 AM
      sender: MessageSender.other,
      senderImageUrl: AppAssets.sarahMartinez,
      status: MessageStatus.seen,
    ),
    Message(
      text:
      'Yes, that works perfectly. I\'ll be there around 4:05 PM to pick up both girls. I drive a blue Honda Civic.',
      timestamp: DateTime(2025, 7, 25, 10, 6), // July 25, 10:06 AM
      sender: MessageSender.user,
      senderImageUrl: AppAssets.jennyProfile,
      status: MessageStatus.seen,
    ),
    // Example messages for different statuses
    Message(
      text: 'Just left home, see you soon!',
      timestamp: DateTime(2025, 7, 25, 10, 30),
      sender: MessageSender.user,
      senderImageUrl: AppAssets.jennyProfile,
      status: MessageStatus.delivered, // Sent but not seen (double gray check)
    ),
    Message(
      text: 'Okay, sounds good!',
      timestamp: DateTime(2025, 7, 25, 10, 35),
      sender: MessageSender.other,
      senderImageUrl: AppAssets.sarahMartinez,
      status: MessageStatus.sent, // Sent (single check)
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add(
          Message(
            text: _messageController.text,
            timestamp: DateTime.now(),
            sender: MessageSender.user, // Assuming current user sends messages
            senderImageUrl: AppAssets.jennyProfile, // Current user's profile
            status: MessageStatus.sent, // Default to sent when sending
          ),
        );
        _messageController.clear();
      });
    }
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
        title: Text(
          // Dynamic title based on chatPartnerName
          widget.chatPartnerName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          // Conditionally show group management icon
          if (widget.isGroupChat && widget.isCurrentUserAdminInGroup)
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white), // Group settings icon
              onPressed: () {
                context.push(RoutePaths.groupManagement);
              },
            ),
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
                final message =
                messages[index - 1]; // Adjust index for messages list
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: const Color(
                0x1A36D399), // Light green/teal background for date separator
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 11.0,
              color: Color(0xFF5A8DEE), // Blue text for date separator
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
          crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person),
                      ).image,
                    ),
                  ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.receiverBubbleColor
                          : AppColors.senderBubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(8.0),
                        topRight: const Radius.circular(8.0),
                        bottomLeft: isUser
                            ? const Radius.circular(12.0)
                            : const Radius.circular(4.0),
                        bottomRight: isUser
                            ? const Radius.circular(4.0)
                            : const Radius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(
                          0xFF1A1A1A,
                        ), // Dark text for message content
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
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person),
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
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        size: 14,
                        color: message.status == MessageStatus.seen
                            ? AppColors.primaryBlue
                            : AppColors.chatTimeColor,
                      ),
                      if (message.status == MessageStatus.seen ||
                          message.status == MessageStatus.delivered)
                        Icon(
                          Icons.check,
                          size: 14,
                          color: message.status == MessageStatus.seen
                              ? AppColors.primaryBlue
                              : AppColors.chatTimeColor,
                        ),
                    ],
                  ),
                const SizedBox(width: 4.0),
                Text(
                  DateFormat(
                    'h:mm a',
                  ).format(message.timestamp), // Format DateTime to string
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: Color(0x991A1A1A), // Grey for time text
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
          Icon(
            Icons.add_circle_outline,
            color: AppColors.textColorSecondary,
            size: 24,
          ), // Plus icon
          const SizedBox(width: 8.0),
          Icon(
            Icons.camera_alt_outlined,
            color: AppColors.textColorSecondary,
            size: 24,
          ), // Camera icon
          const SizedBox(width: 8.0),
          Icon(
            Icons.photo_library_outlined,
            color: AppColors.textColorSecondary,
            size: 24,
          ), // Gallery icon
          const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: const TextStyle(
                  color: AppColors.textColorSecondary,
                  fontSize: 14.0,
                  fontFamily: 'Poppins',
                ),
                filled: true,
                fillColor: AppColors.chatInputFillColor, // Light grey fill
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none, // No border
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                suffixIcon: Icon(
                  Icons.sentiment_satisfied_alt_outlined,
                  color: AppColors.textColorSecondary,
                  size: 24,
                ), // Emoji icon
              ),
              onSubmitted: (_) => _sendMessage(), // Send message on enter
            ),
          ),
          const SizedBox(width: 8.0),
          GestureDetector(
            onTap: _sendMessage, // Send message on tap
            child: Icon(
              Icons.send,
              color: AppColors.primaryBlue,
              size: 24,
            ), // Send icon
          ),
        ],
      ),
    );
  }
}