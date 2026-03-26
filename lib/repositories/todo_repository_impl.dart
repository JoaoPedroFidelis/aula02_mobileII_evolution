import '../models/todo.dart';
import '../services/todo_repository.dart';
import '../utils/todo_remote_datasource.dart';
import '../screens/todo_local_datasource.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource _remote = TodoRemoteDataSource();
  final TodoLocalDataSource _local = TodoLocalDataSource();

  @override
  Future<TodoFetchResult> fetchTodos({bool forceRefresh = false}) async {
    // neste projeto didático, sempre busca remoto e salva lastSync local
    final models = await _remote.fetchTodos();
    final now = DateTime.now();
    await _local.saveLastSync(now);

    final lastSync = await _local.getLastSync();
    final label = lastSync?.toLocal().toString();

    return TodoFetchResult(
      todos: models
          .map((m) => Todo(id: m.id, title: m.title, price: m.price, completed: m.completed))
          .toList(),
      lastSyncLabel: label,
    );
  }

  @override
  Future<Todo> addTodo(String title) async {
    final created = await _remote.addTodo(title);
    return Todo(id: created.id, title: created.title, price: created.price, completed: created.completed);
  }

  @override
  Future<void> updateCompleted({required int id, required bool completed}) {
    return _remote.updateCompleted(id: id, completed: completed);
  }
}
