import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widgets/todo_model.dart';

class TodoRemoteDataSource {
  final http.Client _client;
  TodoRemoteDataSource([http.Client? client]) : _client = client ?? http.Client();

  Future<List<TodoModel>> fetchTodos() async {
    final uri = Uri.parse('https://dummyjson.com/products');
    final res = await _client.get(uri);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}');
    }

    final obj = jsonDecode(res.body) as Map<String, dynamic>;
    final data = (obj['products'] as List<dynamic>? ?? const <dynamic>[]);
    return data.map((e) => TodoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<TodoModel> addTodo(String title) async {
    final uri = Uri.parse('https://dummyjson.com/products/add');
    final res = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title}),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}');
    }

    final obj = jsonDecode(res.body) as Map<String, dynamic>;
    return TodoModel.fromJson(obj);
  }

  Future<void> updateCompleted({required int id, required bool completed}) async {
    final uri = Uri.parse('https://dummyjson.com/products/$id');
    final res = await _client.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'completed': completed}),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}');
    }
  }
}
