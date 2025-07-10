import 'package:travel/tasks/task_model.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  AddTask(this.title);
}

class UpdateTask extends TaskEvent {
  final Task task;
  UpdateTask(this.task);
}

class DeleteTask extends TaskEvent {
  final String id;
  DeleteTask(this.id);
}

class ToggleCompleteTask extends TaskEvent {
  final String id;
  ToggleCompleteTask(this.id);
}
