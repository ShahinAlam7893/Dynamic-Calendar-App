// lib/data/models/user_model.dart
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class Child {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'age')
  final int age;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);
  Map<String, dynamic> toJson() => _$ChildToJson(this);
}

@JsonSerializable()
class Profile {
  @JsonKey(name: 'bio')
  final String? bio;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'children')
  final List<Child> children;

  Profile({
    this.bio,
    this.phoneNumber,
    this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
    required this.children,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'full_name')
  final String fullName;

  @JsonKey(name: 'profile_photo')
  final String? profilePhoto;

  @JsonKey(name: 'date_joined')
  final String dateJoined;

  @JsonKey(name: 'profile')
  final Profile profile;

  @JsonKey(name: 'is_online')
  final bool isOnline;


  User({
    required this.id,
    required this.email,
    required this.fullName,
    this.profilePhoto,
    required this.dateJoined,
    required this.profile,
    required this.isOnline,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
