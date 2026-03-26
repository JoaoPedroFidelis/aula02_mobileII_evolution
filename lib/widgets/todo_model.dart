import '../models/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    required super.price,
    required super.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      price: (json['price'] ?? 0).toDouble(),
      completed: false,
      // completed: (json['completed'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'completed': completed,
      };
}
