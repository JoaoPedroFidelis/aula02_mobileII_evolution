import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_datasource.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';
import '../../../../core/domain/app_error.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote = ProductRemoteDataSource();
  final ProductLocalDataSource _local = ProductLocalDataSource();

  @override
  Future<ProductFetchResult> fetchProducts({bool forceRefresh = false}) async {
    List<ProductModel>? cached;
    if (!forceRefresh) {
      cached = await _local.getProductsCache();
      if (cached != null && cached.isNotEmpty) {
        final lastSync = await _local.getLastSync();
        final label = lastSync?.toLocal().toString();
        return ProductFetchResult(
          products: cached
              .map(
                (m) => Product(
                  id: m.id,
                  title: m.title,
                  description: m.description,
                  price: m.price,
                  category: m.category,
                  brand: m.brand,
                  thumbnail: m.thumbnail,
                  images: m.images,
                ),
              )
              .toList(),
          lastSyncLabel: label,
        );
      }
    }

    try {
      final models = await _remote.fetchProducts();
      final now = DateTime.now();
      await _local.saveLastSync(now);
      await _local.saveProductsCache(models);

      final lastSync = await _local.getLastSync();
      final label = lastSync?.toLocal().toString();

      return ProductFetchResult(
        products: models
            .map(
              (m) => Product(
                id: m.id,
                title: m.title,
                description: m.description,
                price: m.price,
                category: m.category,
                brand: m.brand,
                thumbnail: m.thumbnail,
                images: m.images,
              ),
            )
            .toList(),
        lastSyncLabel: label,
      );
    } catch (e) {
      if (cached != null && cached.isNotEmpty) {
        final lastSync = await _local.getLastSync();
        final label = lastSync?.toLocal().toString();
        return ProductFetchResult(
          products: cached
              .map(
                (m) => Product(
                  id: m.id,
                  title: m.title,
                  description: m.description,
                  price: m.price,
                  category: m.category,
                  brand: m.brand,
                  thumbnail: m.thumbnail,
                  images: m.images,
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
  Future<Product> fetchProductById(int id) async {
    try {
      final model = await _remote.fetchProductById(id);

      final cached = await _local.getProductsCache() ?? <ProductModel>[];
      final idx = cached.indexWhere((e) => e.id == id);
      if (idx >= 0) {
        cached[idx] = model;
      } else {
        cached.insert(0, model);
      }
      await _local.saveProductsCache(cached);

      return Product(
        id: model.id,
        title: model.title,
        description: model.description,
        price: model.price,
        category: model.category,
        brand: model.brand,
        thumbnail: model.thumbnail,
        images: model.images,
      );
    } catch (_) {
      final cached = await _local.getProductsCache();
      final found = cached?.cast<ProductModel?>().firstWhere((e) => e?.id == id, orElse: () => null);
      if (found != null) {
        return Product(
          id: found.id,
          title: found.title,
          description: found.description,
          price: found.price,
          category: found.category,
          brand: found.brand,
          thumbnail: found.thumbnail,
          images: found.images,
        );
      }
      rethrow;
    }
  }

  @override
  Future<Set<int>> fetchFavoriteIds() => _local.getFavoriteIds();

  @override
  Future<void> setFavorite({required int productId, required bool isFavorite}) async {
    final ids = await _local.getFavoriteIds();
    if (isFavorite) {
      ids.add(productId);
    } else {
      ids.remove(productId);
    }
    await _local.saveFavoriteIds(ids);
  }
}
