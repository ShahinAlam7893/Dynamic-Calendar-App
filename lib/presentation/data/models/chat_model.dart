
import '../../../data/models/group_model.dart';

enum ChatMessageStatus { sent, delivered, seen }
class Chat {
  final String conversationId;
  final String name;
  final String lastMessage;
  final String time;
  final String imageUrl;
  final int unreadCount;
  final bool isOnline;
  final ChatMessageStatus status;
  final bool isGroupChat;
  final bool? isCurrentUserAdminInGroup;
  final List<dynamic> participants;
  final String currentUserId;
  final GroupChat? groupChat;

  const Chat({
    required this.conversationId,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrl,
    this.unreadCount = 0,
    this.isOnline = false,
    this.status = ChatMessageStatus.seen,
    this.isGroupChat = false,
    this.isCurrentUserAdminInGroup,
    this.participants = const [],
    this.currentUserId = '',
    this.groupChat,
  });

  factory Chat.fromJson(Map<String, dynamic> json, {required String currentUserId}) {
    final lastMsg = json['last_message'];
    final participants = json['participants'] as List<dynamic>? ?? [];
    final firstParticipant = participants.isNotEmpty ? participants[0] : null;
    return Chat(
      conversationId: json['conversationId'] ?? json['id'] ?? 'Unknown',
      name: json['display_name'] ?? json['name'] ?? 'Unknown',
      lastMessage: lastMsg != null ? lastMsg['content'] ?? '' : '',
      time: lastMsg != null ? lastMsg['timestamp'] ?? '' : '',
      imageUrl: 'assets/images/default_user.png',
      unreadCount: json['unread_count'] ?? 0,
      isOnline: firstParticipant != null ? firstParticipant['is_online'] ?? false : false,
      status: ChatMessageStatus.seen,
      isGroupChat: json['is_group'] ?? false,
      isCurrentUserAdminInGroup: json['user_role'] == 'admin',
      participants: participants,
    );
  }

}