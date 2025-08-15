import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';

import '../core/hive_keys.dart';
import '../models/app_user.dart';

String _hashPassword(String raw) => sha256.convert(utf8.encode(raw)).toString();

class AuthRepository {
  Box get _usersBox => Hive.box(HiveKeys.users);
  Box get _sessionBox => Hive.box(HiveKeys.session);

  Future<void> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    email = email.trim().toLowerCase();
    if (_usersBox.containsKey(email)) {
      throw Exception('Email already registered');
    }
    await _usersBox.put(email, {
      'name': name.trim(),
      'passwordHash': _hashPassword(password),
    });
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    email = email.trim().toLowerCase();
    final data = _usersBox.get(email);
    if (data == null) {
      throw Exception('No account found for this email');
    }
    final savedHash = data['passwordHash'] as String?;
    if (savedHash != _hashPassword(password)) {
      throw Exception('Invalid password');
    }
    final user = AppUser(
      email: email,
      name: (data['name'] as String?) ?? 'User',
    );
    await _sessionBox.put(HiveKeys.currentEmail, email);
    return user;
  }

  Future<void> logout() async {
    await _sessionBox.delete(HiveKeys.currentEmail);
  }

  AppUser? getCurrentUser() {
    final email = _sessionBox.get(HiveKeys.currentEmail) as String?;
    if (email == null) return null;
    final data = _usersBox.get(email);
    if (data == null) return null;
    return AppUser(email: email, name: (data['name'] as String?) ?? 'User');
  }
}
