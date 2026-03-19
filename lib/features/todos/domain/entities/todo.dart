class Todo {
  final int id;
  final String title;
  final double price;
  final bool completed;

  const Todo({
    required this.id,
    required this.title,
    required this.price,
    required this.completed,
  });

  Todo copyWith({int? id, String? title, double? price, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      completed: completed ?? this.completed,
    );
  }
}
