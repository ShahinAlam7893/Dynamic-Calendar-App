import 'package:circleslate/data/datasources/shared_pref/local/shared_pref_manager.dart';

import 'entity/token_entity.dart';


class TokenManager extends SharedPrefManager<String> {
  // The key used to store the token entity in SharedPreferences.
  TokenManager() : super(key: 'auth_token_manager'); // Changed key for clarity

  Future<void> saveTokens(TokenEntity tokens) async {
    await saveValue(tokens.toJson());
  }

  Future<TokenEntity?> getTokens() async {
    final tokenString = await getValue();

    if (tokenString == null || tokenString.isEmpty) {
      return null;
    }

    try {
      return TokenEntity.fromJson(tokenString);
    } catch (e) {
      // Log the error if tokenString is malformed
      print('Error parsing TokenEntity from JSON: $e');
      return null;
    }
  }

  Future<void> removeTokens() async {
    await removeValue();
  }
}
