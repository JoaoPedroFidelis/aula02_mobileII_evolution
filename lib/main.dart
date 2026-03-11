import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/presentation/app_root.dart';
import 'features/todos/domain/repositories/todo_repository.dart';
import 'features/todos/data/repositories/todo_repository_impl.dart';
import 'features/todos/presentation/viewmodels/todo_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<TodoRepository>(create: (_) => TodoRepositoryImpl()),
        ChangeNotifierProvider(
          create: (ctx) => TodoViewModel(ctx.read<TodoRepository>()),
        ),
      ],
      child: const AppRoot(),
    ),
  );
}
