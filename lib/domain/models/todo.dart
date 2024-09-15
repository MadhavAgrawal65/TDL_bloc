// lib/domain/models/todo.dart

enum Priority { low, medium, high }

class Todo {
  final int id;
  final String text;
  final bool isCompleted;
  final DateTime? dueDate;
  final Priority priority;

  Todo({
    required this.id,
    required this.text,
    this.isCompleted = false,
    this.dueDate,
    this.priority = Priority.medium,
  });

  Todo copyWith({
    int? id,
    String? text,
    bool? isCompleted,
    DateTime? dueDate,
    Priority? priority,
  }) {
    return Todo(
      id: id ?? this.id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }

  Todo toggleCompletion() {
    return copyWith(isCompleted: !isCompleted);
  }
}