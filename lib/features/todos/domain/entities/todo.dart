class Todo {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category;
  final bool completed;

  const Todo({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
    required this.completed,
  });

  Todo copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? image,
    String? category,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
      category: category ?? this.category,
      completed: completed ?? this.completed,
    );
  }
}
