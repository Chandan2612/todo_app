// 📁 bloc/task_event.dart

import 'package:travel/tasks/task_model.dart';


/// 🔁 Base class for all Task Events
abstract class TaskEvent {}

/// 🔄 Load all tasks from Firebase
class LoadTasks extends TaskEvent {}

/// ➕ Add a new task
class AddTask extends TaskEvent {
  final String title;
  AddTask(this.title);
}

/// 📝 Update an existing task
class UpdateTask extends TaskEvent {
  final Task task;
  UpdateTask(this.task);
}

/// ❌ Delete a task
class DeleteTask extends TaskEvent {
  final String id;
  DeleteTask(this.id);
}

/// ✅ Toggle task completion
class ToggleCompleteTask extends TaskEvent {
  final String id;
  ToggleCompleteTask(this.id);
}
