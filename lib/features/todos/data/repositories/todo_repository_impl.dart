import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_datasource.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';
import '../../../../core/domain/app_error.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource _remote = TodoRemoteDataSource();
  final TodoLocalDataSource _local = TodoLocalDataSource();

  @override
  Future<TodoFetchResult> fetchTodos({bool forceRefresh = false}) async {
    List<TodoModel>? cached;
    if (!forceRefresh) {
      cached = await _local.getTodosCache();
      if (cached != null && cached.isNotEmpty) {
        final lastSync = await _local.getLastSync();
        final label = lastSync?.toLocal().toString();
        return TodoFetchResult(
          todos: cached
              .map(
                (m) => Todo(
                  id: m.id,
                  title: m.title,
                  price: m.price,
                  description: m.description,
                  image: m.image,
                  category: m.category,
                  completed: m.completed,
                ),
              )
              .toList(),
          lastSyncLabel: label,
        );
      }
    }

    try {
      final models = await _remote.fetchTodos();
      final cachedById = {for (final m in (cached ?? <TodoModel>[])) m.id: m};
      final mergedModels = models
          .map(
            (m) => TodoModel(
              id: m.id,
              title: m.title,
              price: m.price,
              description: m.description,
              image: m.image,
              category: m.category,
              completed: cachedById[m.id]?.completed ?? m.completed,
            ),
          )
          .toList();
      final now = DateTime.now();
      await _local.saveLastSync(now);
      await _local.saveTodosCache(mergedModels);

      final lastSync = await _local.getLastSync();
      final label = lastSync?.toLocal().toString();

      return TodoFetchResult(
        todos: mergedModels
            .map(
              (m) => Todo(
                id: m.id,
                title: m.title,
                price: m.price,
                description: m.description,
                image: m.image,
                category: m.category,
                completed: m.completed,
              ),
            )
            .toList(),
        lastSyncLabel: label,
      );
    } catch (e) {
      if (cached != null && cached.isNotEmpty) {
        final lastSync = await _local.getLastSync();
        final label = lastSync?.toLocal().toString();
        return TodoFetchResult(
          todos: cached
              .map(
                (m) => Todo(
                  id: m.id,
                  title: m.title,
                  price: m.price,
                  description: m.description,
                  image: m.image,
                  category: m.category,
                  completed: m.completed,
                ),
              )
              .toList(),
          lastSyncLabel: label,
        );
      }
      throw const AppError('Falha na comunicação com a API');
    }
  }

  @override
  Future<Todo> addTodo(String title) async {
    final created = await _remote.addTodo(title);
    final cached = await _local.getTodosCache() ?? <TodoModel>[];
    final updated = [created, ...cached];
    await _local.saveTodosCache(updated);
    return Todo(
      id: created.id,
      title: created.title,
      price: created.price,
      description: created.description,
      image: created.image,
      category: created.category,
      completed: created.completed,
    );
  }

  @override
  Future<void> updateCompleted({required int id, required bool completed}) {
    return _remote.updateCompleted(id: id, completed: completed).then((_) async {
      final cached = await _local.getTodosCache();
      if (cached == null) return;
      final idx = cached.indexWhere((e) => e.id == id);
      if (idx < 0) return;
      final old = cached[idx];
      cached[idx] = TodoModel(
        id: old.id,
        title: old.title,
        price: old.price,
        description: old.description,
        image: old.image,
        category: old.category,
        completed: completed,
      );
      await _local.saveTodosCache(cached);
    });
  }
}
