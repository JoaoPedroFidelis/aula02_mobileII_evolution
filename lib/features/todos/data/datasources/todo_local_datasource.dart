import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

class ProductLocalDataSource {
  static const _kLastSync = 'products_last_sync_iso';
  static const _kProductsCache = 'products_cache_json';
  static const _kFavoriteIds = 'products_favorite_ids_json';

  Future<void> saveLastSync(DateTime dt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastSync, dt.toIso8601String());
  }

  Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kLastSync);
    if (s == null || s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  Future<void> saveProductsCache(List<ProductModel> products) async {
    final prefs = await SharedPreferences.getInstance();
    final list = products.map((e) => e.toJson()).toList();
    await prefs.setString(_kProductsCache, jsonEncode(list));
  }

  Future<List<ProductModel>?> getProductsCache() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kProductsCache);
    if (s == null || s.isEmpty) return null;
    try {
      final data = jsonDecode(s) as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<Set<int>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kFavoriteIds);
    if (s == null || s.isEmpty) return <int>{};
    try {
      final data = jsonDecode(s) as List<dynamic>;
      return data.whereType<num>().map((e) => e.toInt()).toSet();
    } catch (_) {
      return <int>{};
    }
  }

  Future<void> saveFavoriteIds(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final list = ids.toList()..sort();
    await prefs.setString(_kFavoriteIds, jsonEncode(list));
  }
}
