// 📁 bloc/task_state.dart

import 'package:travel/tasks/task_model.dart';


/// 🟠 Base class for all states of TaskBloc
abstract class TaskState {}

/// 🔃 Initial state before loading tasks
class TaskInitial extends TaskState {}

/// ✅ State when tasks are successfully loaded
class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);
}
