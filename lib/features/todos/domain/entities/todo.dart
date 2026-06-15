class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String brand;
  final String thumbnail;
  final List<String> images;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.brand,
    required this.thumbnail,
    required this.images,
  });

  Product copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? brand,
    String? thumbnail,
    List<String>? images,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
    );
  }
}
