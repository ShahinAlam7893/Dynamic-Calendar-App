import 'dart:convert';


class TokenEntity {
  final String accessToken;
  final String refreshToken;

  TokenEntity({
    required this.accessToken,
    required this.refreshToken,
  });

  String toJson() {
    final map = {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
    return jsonEncode(map);
  }


  factory TokenEntity.fromJson(String source) {
    final map = jsonDecode(source);
    return TokenEntity(
      accessToken: map['accessToken'] ?? '', // Provide default empty string if null
      refreshToken: map['refreshToken'] ?? '', // Provide default empty string if null
    );
  }

  @override
  String toString() {
    return 'TokenEntity(accessToken: $accessToken, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokenEntity &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode => accessToken.hashCode ^ refreshToken.hashCode;
}
