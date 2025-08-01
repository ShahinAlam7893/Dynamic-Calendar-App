import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'full_name')
  final String fullName;


  User({
    required this.id,
    required this.email,
    required this.fullName,
    // this.token,
  });

  // Factory constructor for deserialization (from JSON)
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // Method for serialization (to JSON)
  Map<String, dynamic> toJson() => _$UserToJson(this);
}