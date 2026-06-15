import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/todo_model.dart';

class ProductRemoteDataSource {
  final http.Client _client;
  ProductRemoteDataSource([http.Client? client]) : _client = client ?? http.Client();

  Future<List<ProductModel>> fetchProducts({String? token}) async {
    final uri = Uri.parse('https://dummyjson.com/products');
    final res = await _client.get(uri);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}');
    }

    final obj = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (obj['products'] as List<dynamic>? ?? const <dynamic>[]);
    return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ProductModel> fetchProductById(int id, {String? token}) async {
    final uri = Uri.parse('https://dummyjson.com/products/$id');
    final res = await _client.get(uri);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}');
    }

    final obj = jsonDecode(res.body) as Map<String, dynamic>;
    return ProductModel.fromJson(obj);
  }
}
