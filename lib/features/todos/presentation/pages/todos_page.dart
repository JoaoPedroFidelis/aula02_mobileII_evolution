import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/auth_session.dart';
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
      ref.read(productsViewModelProvider).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(productsViewModelProvider);
    final session = ref.watch(authSessionProvider);

    if (!session.isBootstrapping && !session.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).popUntil((r) => r.isFirst);
      });
    }

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
        title: Text('Produtos (${session.user?.displayName ?? '-'})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: vm.isLoading ? null : () => vm.loadProducts(forceRefresh: true),
          )
          ,
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: session.isSubmitting ? null : () => ref.read(authSessionProvider).logout(),
          ),
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

  Widget _body(ProductsViewModel vm) {
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
                onPressed: () => vm.loadProducts(forceRefresh: true),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => vm.loadProducts(forceRefresh: true),
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
          final product = vm.items[i - 1];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductDetailsPage(productId: product.id)),
              );
            },
            leading: product.thumbnail.trim().isEmpty
                ? const CircleAvatar(child: Icon(Icons.shopping_bag))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.thumbnail,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const CircleAvatar(
                        child: Icon(Icons.broken_image),
                      ),
                    ),
                  ),
            title: Text(product.title),
            subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
