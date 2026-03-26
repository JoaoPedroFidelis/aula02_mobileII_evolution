import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/todo_viewmodel.dart';
import 'product_details_page.dart';

class TodosPage extends ConsumerStatefulWidget {
  const TodosPage({super.key});

  @override
  ConsumerState<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends ConsumerState<TodosPage> {
  String? _lastErrorShown;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(todoViewModelProvider).loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(todoViewModelProvider);

    if (vm.errorMessage != null && vm.items.isNotEmpty && _lastErrorShown != vm.errorMessage) {
      _lastErrorShown = vm.errorMessage;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final messenger = ScaffoldMessenger.of(context);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: vm.isLoading ? null : () => vm.loadTodos(forceRefresh: true),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final title = await showDialog<String>(
      //       context: context,
      //       builder: (_) => const AddTodoDialog(),
      //     );
      //     if (title != null && title.trim().isNotEmpty) {
      //       await vm.addTodo(title.trim());
      //     }
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: _body(vm),
    );
  }

  Widget _body(TodoViewModel vm) {
    if (vm.isLoading && vm.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.errorMessage != null && vm.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(vm.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => vm.loadTodos(forceRefresh: true),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => vm.loadTodos(forceRefresh: true),
      child: ListView.separated(
        itemCount: vm.items.length + 1,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          if (i == 0) {
            final last = vm.lastSyncLabel ?? 'n/a';
            return ListTile(
              title: const Text('Última sincronização'),
              subtitle: Text(last),
            );
          }
          final todo = vm.items[i - 1];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductDetailsPage(product: todo)),
              );
            },
            leading: todo.image.trim().isEmpty
                ? const CircleAvatar(child: Icon(Icons.shopping_bag))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      todo.image,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const CircleAvatar(
                        child: Icon(Icons.broken_image),
                      ),
                    ),
                  ),
            title: Text(todo.title),
            subtitle: Text('R\$ ${todo.price.toStringAsFixed(2)}'),
            trailing: IconButton(
              onPressed: () => vm.toggleCompleted(todo.id, !todo.completed),
              icon: Icon(todo.completed ? Icons.star : Icons.star_border),
            ),
          );
        },
      ),
    );
  }
}
