import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:registration_form_app/models/user_model.dart';

class StorageService {
  static const String _usersKey = 'registered_users';

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    
    // Check if user already exists (update if same ID)
    final index = users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      users[index] = user;
    } else {
      users.add(user);
    }
    
    await _saveUsersList(users);
  }

  Future<void> deleteUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    users.removeWhere((user) => user.id == userId);
    await _saveUsersList(users);
  }

  Future<void> toggleUserStatus(String userId) async {
    final users = await getUsers();
    final index = users.indexWhere((user) => user.id == userId);
    
    if (index != -1) {
      final user = users[index];
      users[index] = user.copyWith(isActive: !user.isActive);
      await _saveUsersList(users);
    }
  }

  Future<List<UserModel>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    
    return usersJson.map((jsonString) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return UserModel.fromJson(json);
      } catch (e) {
        // If JSON parsing fails, return a default user
        return UserModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Invalid User',
          email: '',
          phone: '',
          address: '',
          registrationDate: DateTime.now(),
          isActive: false,
        );
      }
    }).toList();
  }

  Future<List<UserModel>> getActiveUsers() async {
    final users = await getUsers();
    return users.where((user) => user.isActive).toList();
  }

  Future<void> _saveUsersList(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList(_usersKey, usersJson);
  }
}