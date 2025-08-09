// lib/data/models/user_search_result_model.dart
class UserSearchResult {
  final int id;
  final String fullName;
  final String email;
  final String? profilePhotoUrl;
  final bool isOnline;

  UserSearchResult({
    required this.id,
    required this.fullName,
    required this.email,
    this.profilePhotoUrl,
    required this.isOnline,
  });

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      profilePhotoUrl: json['profile_photo_url'],
      isOnline: json['is_online'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'profile_photo_url': profilePhotoUrl,
      'is_online': isOnline,
    };
  }
}