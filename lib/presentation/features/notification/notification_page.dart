import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/datasources/shared_pref/local/token_manager.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService _notificationService = NotificationService();
  final TokenManager _tokenManager = TokenManager();

  bool _loading = true;
  String? _error;
  List<AppNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _debugTokenStorage();
    _loadNotifications();
  }

  Future<void> _debugTokenStorage() async {
    debugPrint("🛠 [NotificationPage] Debugging token storage...");
    final token = await _tokenManager.getTokens();
    if (token == null) {
      debugPrint("❌ [NotificationPage] TokenEntity is NULL in SharedPreferences.");
    } else {
      debugPrint("✅ [NotificationPage] TokenEntity found: $token");
    }
  }

  Future<void> _loadNotifications() async {
    debugPrint("🔍 [NotificationPage] Fetching notifications...");
    try {
      final notifications = await _notificationService.fetchNotifications(limit: 5101);
      setState(() {
        _notifications = notifications;
        _loading = false;
      });
      debugPrint("📦 [NotificationPage] Notifications fetched: ${notifications.length}");
    } catch (e) {
      debugPrint("⚠️ [NotificationPage] Error: $e");
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _handleNotificationTap(AppNotification notification) async {
    if (notification.conversationId == null) return;

    if (!notification.isRead) {
      await _notificationService.markAsRead(notification.id);
      setState(() {
        notification.isRead = true;
      });
    }

    if (notification.isGroupChat) {
      context.push(
        '/group_conversation',
        extra: {
          'conversationId': notification.conversationId,
          'groupName': notification.conversationName ?? notification.title,
          'currentUserId': 'currentUserId', // replace with actual
          'isGroupChat': true,
        },
      );
    } else {
      context.push(
        '/one-to-one-conversation',
        extra: {
          'conversationId': notification.conversationId,
          'chatPartnerId': notification.chatPartnerId ?? '',
          'chatPartnerName': notification.chatPartnerName, // or get from sender
          'currentUserId': 'currentUserId', // replace with actual
          'isGroupChat': false,
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: AppColors.buttonPrimary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text("Error: $_error"))
          : ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return GestureDetector(
            onTap: () => _handleNotificationTap(notification),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: notification.isRead
                    ? Colors.grey.shade200
                    : Colors.blue.shade50,
                border: Border(
                  left: BorderSide(
                    color: notification.isRead ? Colors.grey : Colors.blue,
                    width: 4,
                  ),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${notification.timestamp.toLocal()}".split('.')[0],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
