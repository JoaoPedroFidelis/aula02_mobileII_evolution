import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

class TodoLocalDataSource {
  static const _kLastSync = 'todos_last_sync_iso';
  static const _kTodosCache = 'todos_cache_json';

  Future<void> saveLastSync(DateTime dt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastSync, dt.toIso8601String());
  }

  Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kLastSync);
    if (s == null || s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  Future<void> saveTodosCache(List<TodoModel> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final list = todos.map((e) => e.toJson()).toList();
    await prefs.setString(_kTodosCache, jsonEncode(list));
  }

  Future<List<TodoModel>?> getTodosCache() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kTodosCache);
    if (s == null || s.isEmpty) return null;
    try {
      final data = jsonDecode(s) as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map(TodoModel.fromJson)
          .toList();
    } catch (_) {
      return null;
    }
  }
}
