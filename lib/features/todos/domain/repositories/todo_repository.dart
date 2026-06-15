import '../entities/todo.dart';

abstract class ProductRepository {
  Future<ProductFetchResult> fetchProducts({bool forceRefresh = false});
  Future<Product> fetchProductById(int id);
}

class ProductFetchResult {
  final List<Product> products;
  final String? lastSyncLabel;

  const ProductFetchResult({required this.products, required this.lastSyncLabel});
}
