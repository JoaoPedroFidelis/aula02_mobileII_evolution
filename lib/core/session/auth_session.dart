import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/dummyjson_auth_service.dart';
import 'auth_user.dart';

class AuthSession extends ChangeNotifier {
  static const _kUserJson = 'auth_user_json';

  final DummyJsonAuthService _authService;
  AuthSession([DummyJsonAuthService? authService]) : _authService = authService ?? DummyJsonAuthService();

  AuthUser? user;
  bool isBootstrapping = true;
  bool isSubmitting = false;
  String? errorMessage;

  bool get isAuthenticated => user != null;

  Future<void> bootstrap() async {
    isBootstrapping = true;
    errorMessage = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kUserJson);
    if (s != null && s.isNotEmpty) {
      try {
        final obj = jsonDecode(s) as Map<String, dynamic>;
        user = AuthUser.fromJson(obj);
      } catch (_) {
        user = null;
        await prefs.remove(_kUserJson);
      }
    }

    isBootstrapping = false;
    notifyListeners();
  }

  Future<void> login({required String username, required String password}) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final loggedUser = await _authService.login(username: username, password: password);
      user = loggedUser;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kUserJson, jsonEncode(loggedUser.toJson()));
    } on InvalidCredentialsException {
      errorMessage = 'Usuário ou senha inválidos.';
      rethrow;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    user = null;
    errorMessage = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserJson);
  }
}

final authSessionProvider = ChangeNotifierProvider<AuthSession>((ref) {
  final session = AuthSession();
  session.bootstrap();
  return session;
});
