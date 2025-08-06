import 'package:circleslate/data/datasources/shared_pref/local/shared_pref_manager.dart';

class LoginManager extends SharedPrefManager<bool>{
  LoginManager() : super(key: 'token_manager');
}