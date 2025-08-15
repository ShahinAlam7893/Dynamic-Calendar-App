import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For formatting timestamps

import 'package:circleslate/core/constants/app_colors.dart';

// --- Notification Model ---
class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;
  final String? type; // e.g., 'event_update', 'ride_request', 'general'

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.type,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Sample notifications (you would fetch these from a service)
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'New Event: Soccer Practice!',
      body: 'Peter Johnson has created a new soccer practice event for Ella.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
      type: 'event_update',
    ),
    AppNotification(
      id: '2',
      title: 'Ride Request for Emma\'s Party',
      body: 'Sarah Martinez needs a ride for Emma to the birthday party.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: 'ride_request',
    ),
    AppNotification(
      id: '3',
      title: 'Group Chat Update: Moms Group',
      body: 'New messages in the Moms Group chat. Check it out!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: 'general',
    ),
    AppNotification(
      id: '4',
      title: 'Availability Changed',
      body: 'Your availability for July 25th has been updated to Busy.',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      isRead: true,
      type: 'general',
    ),
    AppNotification(
      id: '5',
      title: 'Reminder: Art Class Tomorrow',
      body: 'Don\'t forget about the Art Class tomorrow at 2:00 PM.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: false,
      type: 'event_update',
    ),
  ];

  void _markNotificationAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere(
        (notification) => notification.id == id,
      );
      if (index != -1) {
        _notifications[index].isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive font sizes
    final double appBarTitleFontSize = screenWidth * 0.05;
    final double notificationTitleFontSize = screenWidth * 0.042;
    final double notificationBodyFontSize = screenWidth * 0.035;
    final double notificationTimestampFontSize = screenWidth * 0.028;
    final double iconSize = screenWidth * 0.06;

    // Responsive spacing and padding
    final double mainPadding = screenWidth * 0.04;
    final double cardVerticalMargin = screenWidth * 0.02;
    final double cardPadding = screenWidth * 0.04;
    final double titleBodySpacing = screenWidth * 0.015;
    final double bodyTimestampSpacing = screenWidth * 0.01;
    final double leadingIconSpacing = screenWidth * 0.03;
    final double borderRadius = screenWidth * 0.03;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Consistent light grey background
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue, // Consistent app bar color
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: screenWidth * 0.06,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: appBarTitleFontSize,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Text(
                'No new notifications.',
                style: TextStyle(
                  fontSize: notificationBodyFontSize * 1.2,
                  color: AppColors.textColorSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(mainPadding),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return GestureDetector(
                  onTap: () {
                    _markNotificationAsRead(notification.id);
                    // Optionally navigate to a specific page based on notification type
                    // if (notification.type == 'event_update') {
                    //   context.push('/event_details/${notification.id}');
                    // }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Notification "${notification.title}" marked as read!',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: cardVerticalMargin),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    elevation: 0, // Consistent with other cards
                    color: notification.isRead
                        ? AppColors.notificationCardReadBg
                        : AppColors
                              .notificationCardUnreadBg, // Different background for unread
                    child: Padding(
                      padding: EdgeInsets.all(cardPadding),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Unread indicator or notification icon
                          Container(
                            width: iconSize,
                            height: iconSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: notification.isRead
                                  ? Colors.transparent
                                  : AppColors.unreadIndicatorColor.withOpacity(
                                      0.2,
                                    ),
                            ),
                            child: Center(
                              child: Icon(
                                notification.isRead
                                    ? Icons.check_circle_outline
                                    : Icons.circle,
                                color: notification.isRead
                                    ? AppColors.primaryBlue
                                    : AppColors.unreadIndicatorColor,
                                size: notification.isRead
                                    ? iconSize * 0.8
                                    : iconSize * 0.5,
                              ),
                            ),
                          ),
                          SizedBox(width: leadingIconSpacing),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontSize: notificationTitleFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColorPrimary,
                                    fontFamily: 'Poppins',
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: titleBodySpacing),
                                Text(
                                  notification.body,
                                  style: TextStyle(
                                    fontSize: notificationBodyFontSize,
                                    color: AppColors.textColorSecondary,
                                    fontFamily: 'Poppins',
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: bodyTimestampSpacing),
                                Text(
                                  DateFormat(
                                    'MMM d, yyyy HH:mm',
                                  ).format(notification.timestamp),
                                  style: TextStyle(
                                    fontSize: notificationTimestampFontSize,
                                    color: AppColors.textLight,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
