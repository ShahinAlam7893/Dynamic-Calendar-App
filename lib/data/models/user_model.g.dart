// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Child _$ChildFromJson(Map<String, dynamic> json) => Child(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  age: (json['age'] as num).toInt(),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$ChildToJson(Child instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'age': instance.age,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  bio: json['bio'] as String?,
  phoneNumber: json['phone_number'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  children: (json['children'] as List<dynamic>)
      .map((e) => Child.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'bio': instance.bio,
  'phone_number': instance.phoneNumber,
  'date_of_birth': instance.dateOfBirth,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'children': instance.children,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  fullName: json['full_name'] as String,
  profilePhoto: json['profile_photo'] as String?,
  dateJoined: json['date_joined'] as String,
  profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'full_name': instance.fullName,
  'profile_photo': instance.profilePhoto,
  'date_joined': instance.dateJoined,
  'profile': instance.profile,
};
