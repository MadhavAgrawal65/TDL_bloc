// lib/data/models/isar_todo.dart

import 'package:isar/isar.dart';
import 'package:todo_bloc_tutorial/domain/models/todo.dart';

part 'isar_todo.g.dart';

@collection
class TodoIsar {
  Id id = Isar.autoIncrement;
  late String text;
  late bool isCompleted;
  DateTime? dueDate;
  @enumerated
  late Priority priority;

  Todo toDomain() {
    return Todo(
      id: id,
      text: text,
      isCompleted: isCompleted,
      dueDate: dueDate,
      priority: priority,
    );
  }

  static TodoIsar fromDomain(Todo todo) {
    return TodoIsar()
      ..id = todo.id
      ..text = todo.text
      ..isCompleted = todo.isCompleted
      ..dueDate = todo.dueDate
      ..priority = todo.priority;
  }
}