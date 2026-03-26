import 'package:flutter/material.dart';

import '../../domain/entities/todo.dart';

class ProductDetailsPage extends StatelessWidget {
  final Todo product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do produto')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 500),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: product.image.trim().isEmpty
                      ? Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: const Center(child: Icon(Icons.image_not_supported)),
                        )
                      : Image.network(
                          product.image,
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
              if (product.category.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Categoria: ${product.category}',
                  style: theme.textTheme.bodyMedium,
                ),
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
      ),
    );
  }
}
