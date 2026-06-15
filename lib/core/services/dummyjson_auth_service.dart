import 'dart:convert';
import 'package:http/http.dart' as http;

import '../session/auth_user.dart';

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}

class DummyJsonAuthService {
  final http.Client _client;
  DummyJsonAuthService([http.Client? client]) : _client = client ?? http.Client();

  Future<AuthUser> login({required String username, required String password}) async {
    final uri = Uri.parse('https://dummyjson.com/auth/login');
    final res = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'username': username,
          'password': password,
        },
      ),
    );

    if (res.statusCode == 400 || res.statusCode == 401) {
      throw const InvalidCredentialsException();
    }
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}');
    }

    final obj = jsonDecode(res.body) as Map<String, dynamic>;
    return AuthUser.fromJson(obj);
  }
}
