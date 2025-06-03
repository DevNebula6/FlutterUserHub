import 'package:equatable/equatable.dart';

class TodoResponse extends Equatable {
  final List<Todo> todos;
  final int total;
  final int skip;
  final int limit;

  const TodoResponse({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory TodoResponse.fromJson(Map<String, dynamic> json) {
    return TodoResponse(
      todos: (json['todos'] as List).map((todo) => Todo.fromJson(todo)).toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [todos, total, skip, limit];
}

class Todo extends Equatable {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const Todo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? 0,
      todo: json['todo'] ?? '',
      completed: json['completed'] ?? false,
      userId: json['userId'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, todo, completed, userId];
}
