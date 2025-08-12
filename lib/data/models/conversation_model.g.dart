// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
  id: json['id'] as String,
  fullName: json['full_name'] as String,
);

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{'id': instance.id, 'full_name': instance.fullName};

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
  id: json['id'] as String,
  name: json['name'] as String,
  isGroup: json['is_group'] as bool,
  displayName: json['display_name'] as String,
  unreadCount: (json['unread_count'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  participants: (json['participants'] as List<dynamic>)
      .map((e) => Participant.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_group': instance.isGroup,
      'display_name': instance.displayName,
      'unread_count': instance.unreadCount,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'participants': instance.participants,
    };

ConversationListResponse _$ConversationListResponseFromJson(
  Map<String, dynamic> json,
) => ConversationListResponse(
  conversations: (json['conversations'] as List<dynamic>)
      .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
      .toList(),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$ConversationListResponseToJson(
  ConversationListResponse instance,
) => <String, dynamic>{
  'conversations': instance.conversations,
  'count': instance.count,
};
