Sure! Here's a more casual, humanized version of the README:

---

# To-Do List App

This is a simple and powerful to-do list app built with **Flutter**, **Dart**, **BLoC** for state management, and **Isar** for offline data storage. It lets you create, edit, and delete tasks, set priority levels, and get reminders for upcoming deadlines. The app uses the **MVVM** (Model-View-ViewModel) architecture, making it easy to maintain and scale.

## Features

### 1. **Manage Your Tasks**
   - **Add New Tasks:** Create a new task with a title, due date, and priority (Low, Medium, or High).
   - **Edit Tasks:** Change task details like title, due date, and priority anytime.
   - **Delete Tasks:** Remove tasks that you don’t need anymore.
   - **Mark Tasks as Complete:** Use a checkbox to mark tasks as done or unfinished.

### 2. **Prioritize Tasks**
   - Set tasks as Low, Medium, or High priority, and see them color-coded in the task list to easily spot what’s most important.

### 3. **Due Dates**
   - Pick a due date from the calendar. You can set dates within the next year to manage upcoming deadlines.

### 4. **Reminders**
   - **Local Notifications:** When a task has a due date, you'll get a reminder notification using `flutter_local_notifications` as the deadline approaches.
   - **Cancel Notifications:** Completed tasks automatically cancel any pending reminders.

### 5. **Offline Data with Isar**
   - Tasks are saved on your device using **Isar**. This means you can access your tasks even when you’re offline—no login or internet required.

### 6. **Task Sorting (Coming Soon)**
   - In the future, you’ll be able to sort tasks by due date, priority, or when they were created.

---

## App Structure

This app uses the **MVVM** (Model-View-ViewModel) architecture, which makes it easier to separate the UI from the business logic and keep the code organized.

### 1. **User Interface (UI)**
   - **TodoView & TodoPage:** These files handle the screens and user interactions. The UI is designed with Flutter’s Material components, featuring a button to add new tasks and list views to show your tasks.

### 2. **Business Logic (Domain)**
   - **Models (Todo):** The task model defines how a task is structured with fields like `id`, `title`, `dueDate`, `isCompleted`, and `priority`.
   - **Repository (TodoRepo):** This abstract class defines how we interact with tasks (add, edit, delete). It doesn’t care where the tasks are stored—just the operations themselves.

### 3. **Data Storage**
   - **IsarTodoRepo:** This class implements the `TodoRepo` and handles saving and loading tasks from the **Isar** database. It maps the task data to Isar-compatible objects and back again.

---

## State Management with BLoC

The app uses the **BLoC** (Business Logic Component) pattern to handle state changes. This helps keep the UI and logic separate, making the app more efficient and scalable.

- **TodoCubit:** This class extends `Cubit` and handles everything related to tasks—loading, adding, updating, and deleting them. It also manages notifications for tasks with due dates.

Any changes in state, like adding or deleting a task, automatically update the UI.

---

## Notifications

We use **flutter_local_notifications** to send reminders for tasks with upcoming due dates. Here’s how it works:
1. **Setup:** Notification settings are initialized for Android.
2. **Schedule Notifications:** When a task has a due date, a notification is scheduled to alert you as it approaches.
3. **Cancel Notifications:** If a task is marked complete or deleted, any pending notifications are canceled.

---

## Isar Database

**Isar** is a fast, offline-first database that works on your device. We use it to:
- **Store tasks locally** so you don’t need the internet to access your to-do list.
- **Fetch tasks** when the app starts.
- **Keep your data safe** even if you close or restart the app.

---

## How to Get Started

### Requirements
To run this app, you’ll need:
   - Flutter SDK
   - Dart
   - Android Studio or VS Code with Flutter extensions
   - A device or emulator to run the app

### Installation
1. Clone the repo.
2. Run `flutter pub get` to install dependencies.
3. Launch the app on your device or emulator using `flutter run`.

---

## BLoC Learning Resources

I followed this great **YouTube tutorial** to learn BLoC: [Flutter BLoC Pattern for Beginners](https://www.youtube.com/watch?v=brDKUf1yV6c&t=109s). It helped me understand how to manage state using BLoC, and I adapted it to fit the needs of this app.

---

## Final Thoughts

This to-do list app is a great tool for managing tasks. It works offline, sends notifications, and uses a solid architecture that makes it easy to maintain and expand. Feel free to play around with the code, and build out more features if you’d like!
# TDL_bloc
