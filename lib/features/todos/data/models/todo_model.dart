import '../../domain/entities/todo.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.category,
    required super.brand,
    required super.thumbnail,
    required super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: (json['price'] ?? 0).toDouble(),
      category: (json['category'] ?? '').toString(),
      brand: (json['brand'] ?? '').toString(),
      thumbnail: (json['thumbnail'] ?? '').toString(),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .where((s) => s.trim().isNotEmpty)
              .toList() ??
          const <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'category': category,
        'brand': brand,
        'thumbnail': thumbnail,
        'images': images,
      };
}
