import 'package:json_annotation/json_annotation.dart';

part 'conversation_model.g.dart';

@JsonSerializable()
class Participant {
  final String id;
  @JsonKey(name: 'full_name')
  final String fullName;

  Participant({
    required this.id,
    required this.fullName,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}

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

  final List<Participant> participants;

  Conversation({
    required this.id,
    required this.name,
    required this.isGroup,
    required this.displayName,
    required this.unreadCount,
    required this.createdAt,
    required this.updatedAt,
    required this.participants,
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
