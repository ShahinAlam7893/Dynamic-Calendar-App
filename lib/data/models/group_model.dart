import 'package:circleslate/core/constants/app_assets.dart';

enum ChatMessageStatus { sent, delivered, seen }

class Participant {
  final String id;
  final String email;
  final String fullName;
  final String? profilePhotoUrl;
  final bool isOnline;
  final String role;
  final bool canRemove;

  Participant({
    required this.id,
    required this.email,
    required this.fullName,
    this.profilePhotoUrl,
    required this.isOnline,
    required this.role,
    required this.canRemove,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'].toString(),
      email: json['email'],
      fullName: json['full_name'],
      profilePhotoUrl: json['profile_photo_url'],
      isOnline: json['is_online'] ?? false,
      role: json['role'] ?? 'Member',
      canRemove: json['can_remove'] ?? false,
    );
  }
}

class Message {
  final String id;
  final String senderId;
  final String content;
  final String timestamp;
  final String messageType;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.messageType,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString(),
      senderId: json['sender'].toString(),
      content: json['content'],
      timestamp: json['timestamp'],
      messageType: json['message_type'] ?? 'text',
    );
  }
}

class Chat {
  final String id;
  final String? name;
  final bool isGroup;
  final List<Participant> participants;
  final String? lastMessage;
  final String? lastMessageTime;
  final int unreadCount;
  final String? displayName;
  final String? displayPhoto;
  final int participantCount;
  final String? userRole;
  final ChatMessageStatus status;
  final String currentUserId;

  Chat({
    required this.currentUserId,
    required this.id,
    this.name,
    required this.isGroup,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.displayName,
    this.displayPhoto,
    required this.participantCount,
    this.userRole,
    this.status = ChatMessageStatus.seen,
  });

  factory Chat.fromJson(Map<String, dynamic> json, {required String currentUserId}) {
    final lastMessage = json['last_message'] != null
        ? Message.fromJson(json['last_message'])
        : null;

    return Chat(
      currentUserId: currentUserId,
      id: json['id'].toString(),
      name: json['name'],
      isGroup: json['is_group'] ?? false,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((p) => Participant.fromJson(p))
          .toList() ??
          [],
      lastMessage: lastMessage?.content,
      lastMessageTime: lastMessage?.timestamp,
      unreadCount: json['unread_count'] ?? 0,
      displayName: json['display_name'],
      displayPhoto: json['display_photo'] ?? AppAssets.groupChatIcon,
      participantCount: json['participant_count'] ?? 0,
      userRole: json['user_role'],
      status: ChatMessageStatus.seen,
    );
  }
}
