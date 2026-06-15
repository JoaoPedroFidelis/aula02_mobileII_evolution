import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../data/repositories/todo_repository_impl.dart';

enum ProductsStatus { idle, loading, success, error }

class ProductsViewModel extends ChangeNotifier {
  final ProductRepository _repo;
  ProductsViewModel(this._repo);

  ProductsStatus status = ProductsStatus.idle;
  String? errorMessage;

  final List<Product> items = [];
  String? lastSyncLabel;

  bool get isLoading => status == ProductsStatus.loading;
  bool get hasError => status == ProductsStatus.error;

  Future<void> loadProducts({bool forceRefresh = false}) async {
    status = ProductsStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.fetchProducts(forceRefresh: forceRefresh);
      items
        ..clear()
        ..addAll(result.products);
      lastSyncLabel = result.lastSyncLabel;
      status = ProductsStatus.success;
    } catch (e) {
      errorMessage = 'Falha ao carregar: $e';
      status = ProductsStatus.error;
    } finally {
      notifyListeners();
    }
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) => ProductRepositoryImpl());

final productsViewModelProvider = ChangeNotifierProvider<ProductsViewModel>(
  (ref) => ProductsViewModel(ref.read(productRepositoryProvider)),
);
