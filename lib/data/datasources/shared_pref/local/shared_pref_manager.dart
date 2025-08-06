// lib/data/datasource/local/shared_pref/shared_pref_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefManager<T> {
  final String key; // Key under which the value will be stored

  SharedPrefManager({required this.key});

  Future<void> saveValue(T value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (value is String) {
      await sharedPreferences.setString(key, value);
    } else if (value is int) {
      await sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      await sharedPreferences.setBool(key, value);
    } else if (value is double) {
      await sharedPreferences.setDouble(key, value);
    } else {
      throw Exception("Type $T not supported by SharedPreferences");
    }
  }

  Future<T?> getValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.get(key) as T?;
  }

  Future<void> removeValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);
  }
}
