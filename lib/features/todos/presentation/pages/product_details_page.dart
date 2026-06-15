import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/todo.dart';
import '../viewmodels/todo_viewmodel.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.read(productRepositoryProvider);
    final vm = ref.watch(productsViewModelProvider);
    final isFav = vm.isFavorite(widget.productId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do produto'),
        actions: [
          IconButton(
            onPressed: () => vm.toggleFavorite(widget.productId),
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            tooltip: isFav ? 'Remover dos favoritos' : 'Marcar como favorito',
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: repo.fetchProductById(widget.productId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || !snap.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Falha ao carregar detalhes do produto.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final product = snap.data!;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 500),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: product.thumbnail.trim().isEmpty
                          ? Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Center(child: Icon(Icons.image_not_supported)),
                            )
                          : Image.network(
                              product.thumbnail,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) {
                                return Container(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  child: const Center(child: Icon(Icons.broken_image)),
                                );
                              },
                            ),
                    ),
                  ),
                  if (product.images.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final url = product.images[i];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              url,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 80,
                                color: theme.colorScheme.surfaceContainerHighest,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    product.title,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                  ),
                  if (product.brand.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Marca: ${product.brand}', style: theme.textTheme.bodyMedium),
                  ],
                  if (product.category.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Categoria: ${product.category}', style: theme.textTheme.bodyMedium),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    product.description.trim().isEmpty ? 'Sem descrição.' : product.description,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
