import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.image,
    required super.category,
    required super.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      price: (json['price'] ?? 0).toDouble(),
      description: (json['description'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      completed: (json['completed'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'image': image,
        'category': category,
        'completed': completed,
      };
}
