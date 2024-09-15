import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_tutorial/domain/models/todo.dart' as todo_model;
import 'package:todo_bloc_tutorial/domain/repository/todo_repo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TodoCubit extends Cubit<List<todo_model.Todo>> {
  final TodoRepo todoRepo;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  TodoCubit(this.todoRepo)
      : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(),
        super([]) {
    loadTodos();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> loadTodos() async {
    final todoList = await todoRepo.getTodos();
    emit(todoList);
    loadTodos();
  }

  Future<void> addTodo(String text, DateTime? dueDate, todo_model.Priority priority) async {
    final newTodo = todo_model.Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      text: text,
      dueDate: dueDate,
      priority: priority,
    );
    await todoRepo.addTodo(newTodo);
    if (dueDate != null) {
      await _scheduleNotification(newTodo);
    }
    loadTodos();
  }

  Future<void> deleteTodo(todo_model.Todo todo) async {
    await todoRepo.deleteTodo(todo);
    await _cancelNotification(todo.id);
    loadTodos();
  }

  Future<void> toggleCompletion(todo_model.Todo todo) async {
    final updatedTodo = todo.toggleCompletion();
    await todoRepo.updateTodo(updatedTodo);
    if (updatedTodo.isCompleted) {
      await _cancelNotification(updatedTodo.id);
    } else if (updatedTodo.dueDate != null) {
      await _scheduleNotification(updatedTodo);
    }
    loadTodos();
  }

  Future<void> updateTodo(todo_model.Todo todo, {String? text, DateTime? dueDate, todo_model.Priority? priority}) async {
    final updatedTodo = todo.copyWith(
      text: text,
      dueDate: dueDate,
      priority: priority,
    );
    await todoRepo.updateTodo(updatedTodo);
    await _cancelNotification(todo.id);
    if (updatedTodo.dueDate != null && !updatedTodo.isCompleted) {
      await _scheduleNotification(updatedTodo);
    }
    loadTodos();
  }

  Future<void> _scheduleNotification(todo_model.Todo todo) async {
    if (todo.dueDate == null) return;

    tz.initializeTimeZones();
    final scheduledDate = tz.TZDateTime.from(todo.dueDate!, tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'todo_notifications',
      'Todo Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      todo.id,
      'Todo Reminder',
      todo.text,
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    loadTodos();
  }
  Future<void> _cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    loadTodos();
  }
}