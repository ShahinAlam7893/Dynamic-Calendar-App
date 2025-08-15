class DefaultGroup {
  final int id;
  final String name;
  final String description;
  final int memberCount;
  bool isMember;
  final String conversationId;

  DefaultGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.isMember,
    required this.conversationId,
  });

  factory DefaultGroup.fromJson(Map<String, dynamic> json) {
    return DefaultGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      memberCount: json['member_count'],
      isMember: json['is_member'],
      conversationId: json['conversation_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'member_count': memberCount,
      'is_member': isMember,
      'conversation_id': conversationId,
    };
  }
}