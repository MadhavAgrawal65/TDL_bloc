// lib/presentation/todo_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_tutorial/domain/models/todo.dart';
import 'package:todo_bloc_tutorial/presentation/todo_cubit.dart';

class TodoView extends StatelessWidget {
  const TodoView({Key? key}) : super(key: key);

  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController();
    DateTime? selectedDate;
    Priority selectedPriority = Priority.medium;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: textController, decoration: const InputDecoration(hintText: 'Todo text')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() => selectedDate = pickedDate);
                  }
                },
                child: Text(selectedDate != null ? 'Due: ${selectedDate!.toLocal()}' : 'Set due date'),
              ),
              const SizedBox(height: 16),
              DropdownButton<Priority>(
                value: selectedPriority,
                onChanged: (Priority? newValue) {
                  if (newValue != null) {
                    setState(() => selectedPriority = newValue);
                  }
                },
                items: Priority.values.map((Priority priority) {
                  return DropdownMenuItem<Priority>(
                    value: priority,
                    child: Text(priority.toString().split('.').last),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                todoCubit.addTodo(textController.text, selectedDate, selectedPriority);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoBox(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(
                  todo.text,
                  style: TextStyle(
                    decoration: todo.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (todo.dueDate != null)
                      Text('Due: ${todo.dueDate!.toLocal()}'),
                    Text('Priority: ${todo.priority.toString().split('.').last}'),
                  ],
                ),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) => todoCubit.toggleCompletion(todo),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => todoCubit.deleteTodo(todo),
                ),
                onTap: () => _showEditTodoBox(context, todo),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditTodoBox(BuildContext context, Todo todo) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController(text: todo.text);
    DateTime? selectedDate = todo.dueDate;
    Priority selectedPriority = todo.priority;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: textController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() => selectedDate = pickedDate);
                  }
                },
                child: Text(selectedDate != null ? 'Due: ${selectedDate!.toLocal()}' : 'Set due date'),
              ),
              const SizedBox(height: 16),
              DropdownButton<Priority>(
                value: selectedPriority,
                onChanged: (Priority? newValue) {
                  if (newValue != null) {
                    setState(() => selectedPriority = newValue);
                  }
                },
                items: Priority.values.map((Priority priority) {
                  return DropdownMenuItem<Priority>(
                    value: priority,
                    child: Text(priority.toString().split('.').last),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                todoCubit.updateTodo(
                  todo,
                  text: textController.text,
                  dueDate: selectedDate,
                  priority: selectedPriority,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}