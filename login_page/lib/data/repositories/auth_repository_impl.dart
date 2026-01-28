import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalDataSource _localDataSource;

  AuthRepositoryImpl(this._localDataSource);

  @override
  Future<User> login(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // For demo purposes, create a mock user
    // In real app, you would make an API call here
    final user = User(
      id: '1',
      name: email.split('@').first,
      email: email,
      token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
    );

    await _localDataSource.saveUser(user);
    return user;
  }

  @override
  Future<User> register(String name, String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // For demo purposes, create a mock user
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
    );

    await _localDataSource.saveUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _localDataSource.isLoggedIn();
  }

  @override
  Future<User?> getCurrentUser() async {
    return await _localDataSource.getUser();
  }
}