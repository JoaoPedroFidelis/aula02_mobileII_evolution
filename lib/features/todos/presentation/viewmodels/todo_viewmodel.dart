import 'package:flutter/foundation.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';

enum TodosStatus { idle, loading, success, error }

class TodoViewModel extends ChangeNotifier {
  final TodoRepository _repo;
  TodoViewModel(this._repo);

  TodosStatus status = TodosStatus.idle;
  String? errorMessage;

  final List<Todo> items = [];
  String? lastSyncLabel;

  bool get isLoading => status == TodosStatus.loading;
  bool get hasError => status == TodosStatus.error;

  Future<void> loadTodos({bool forceRefresh = false}) async {
    status = TodosStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.fetchTodos(forceRefresh: forceRefresh);
      items
        ..clear()
        ..addAll(result.todos);
      lastSyncLabel = result.lastSyncLabel;
      status = TodosStatus.success;
    } catch (e) {
      errorMessage = 'Falha ao carregar: $e';
      status = TodosStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) {
      errorMessage = 'Título não pode ser vazio.';
      notifyListeners();
      return;
    }
    try {
      final created = await _repo.addTodo(title);
      items.insert(0, created);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Falha ao adicionar: $e';
      notifyListeners();
    }
  }

  Future<void> toggleCompleted(int id, bool completed) async {
    final idx = items.indexWhere((t) => t.id == id);
    if (idx < 0) return;

    final old = items[idx];
    items[idx] = old.copyWith(completed: completed);
    notifyListeners();

    try {
      await _repo.updateCompleted(id: id, completed: completed);
    } catch (e) {
      items[idx] = old;
      errorMessage = 'Falha ao atualizar: $e';
      notifyListeners();
    }
  }
}
