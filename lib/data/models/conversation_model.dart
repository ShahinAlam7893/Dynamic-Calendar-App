import 'package:json_annotation/json_annotation.dart';

part 'conversation_model.g.dart';

@JsonSerializable()
class Conversation {
  final String id;
  final String name;
  @JsonKey(name: 'is_group')
  final bool isGroup;
  @JsonKey(name: 'display_name')
  final String displayName;
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.name,
    required this.isGroup,
    required this.displayName,
    required this.unreadCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}

@JsonSerializable()
class ConversationListResponse {
  final List<Conversation> conversations;
  final int count;

  ConversationListResponse({
    required this.conversations,
    required this.count,
  });

  factory ConversationListResponse.fromJson(Map<String, dynamic> json) => _$ConversationListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationListResponseToJson(this);
}


class Conversation2 {
  final String id;
  final String displayName;
  final bool isGroup;
  final int unreadCount;
  final DateTime updatedAt;
  final String? lastMessage;
  final String? lastMessageStatus;


  Conversation2({
    required this.id,
    required this.displayName,
    required this.isGroup,
    required this.unreadCount,
    required this.updatedAt,
    required this.lastMessage,
    required this.lastMessageStatus,
  });

  factory Conversation2.fromJson(Map<String, dynamic> json) {
    return Conversation2(
      id: json['id'],
      displayName: json['display_name'],
      isGroup: json['is_group'],
      unreadCount: json['unread_count'],
      updatedAt: DateTime.parse(json['updated_at']),
      lastMessage: json['last_message'],
      lastMessageStatus: json['last_message_status'],
    );
  }

}
