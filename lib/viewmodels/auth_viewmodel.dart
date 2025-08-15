import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

class AuthViewModel extends Notifier<AppUser?> {
  @override
  AppUser? build() {
    // Load session on startup
    final repo = ref.read(authRepositoryProvider);
    return repo.getCurrentUser();
  }

  Future<void> signUp(String email, String name, String password) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signUp(email: email, name: name, password: password);
    final user = await repo.login(
      email: email,
      password: password,
    ); // auto-login
    state = user;
  }

  Future<void> login(String email, String password) async {
    final repo = ref.read(authRepositoryProvider);
    final user = await repo.login(email: email, password: password);
    state = user;
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = null;
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AppUser?>(
  AuthViewModel.new,
);
