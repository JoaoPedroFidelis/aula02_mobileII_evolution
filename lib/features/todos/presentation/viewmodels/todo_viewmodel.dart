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
  final Set<int> favoriteIds = <int>{};

  bool get isLoading => status == ProductsStatus.loading;
  bool get hasError => status == ProductsStatus.error;
  bool isFavorite(int productId) => favoriteIds.contains(productId);

  Future<void> loadProducts({bool forceRefresh = false}) async {
    status = ProductsStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final favorites = await _repo.fetchFavoriteIds();
      favoriteIds
        ..clear()
        ..addAll(favorites);

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

  Future<void> toggleFavorite(int productId) async {
    final next = !isFavorite(productId);
    try {
      await _repo.setFavorite(productId: productId, isFavorite: next);
      if (next) {
        favoriteIds.add(productId);
      } else {
        favoriteIds.remove(productId);
      }
      notifyListeners();
    } catch (e) {
      errorMessage = 'Falha ao atualizar favorito: $e';
      notifyListeners();
    }
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) => ProductRepositoryImpl());

final productsViewModelProvider = ChangeNotifierProvider<ProductsViewModel>(
  (ref) => ProductsViewModel(ref.read(productRepositoryProvider)),
);
