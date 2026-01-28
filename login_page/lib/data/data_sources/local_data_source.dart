import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';

class LocalDataSource {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';

  final SharedPreferences _prefs;

  LocalDataSource(this._prefs);

  Future<void> saveUser(User user) async {
    await _prefs.setString(_userKey, json.encode(user.toJson()));
    if (user.token != null) {
      await _prefs.setString(_tokenKey, user.token!);
    }
    await _prefs.setBool(_isLoggedInKey, true);
  }

  Future<User?> getUser() async {
    final userString = _prefs.getString(_userKey);
    if (userString != null) {
      final userMap = json.decode(userString) as Map<String, dynamic>;
      return User.fromJson(userMap);
    }
    return null;
  }

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<bool> isLoggedIn() async {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_isLoggedInKey);
  }
}