import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/tasks/bloc/task_event.dart';
import 'package:travel/tasks/bloc/task_state.dart';
import 'package:travel/tasks/task_model.dart';
import 'package:travel/tasks/task_service.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      final tasks = await FirebaseTaskService.fetchTasks();
      emit(TaskLoaded(tasks));
    });

    on<AddTask>((event, emit) async {
      if (state is TaskLoaded) {
        final current = (state as TaskLoaded).tasks;
        final newTask = Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: event.title,
        );
        await FirebaseTaskService.addTask(newTask);
        emit(TaskLoaded([...current, newTask]));
      }
    });

    on<UpdateTask>((event, emit) async {
      if (state is TaskLoaded) {
        final current = (state as TaskLoaded).tasks;
        await FirebaseTaskService.updateTask(event.task);
        final updatedList = current.map((task) => task.id == event.task.id ? event.task : task).toList();
        emit(TaskLoaded(updatedList));
      }
    });

    on<DeleteTask>((event, emit) async {
      if (state is TaskLoaded) {
        final current = (state as TaskLoaded).tasks;
        await FirebaseTaskService.deleteTask(event.id);
        final updatedList = current.where((task) => task.id != event.id).toList();
        emit(TaskLoaded(updatedList));
      }
    });

    on<ToggleCompleteTask>((event, emit) async {
      if (state is TaskLoaded) {
        final current = (state as TaskLoaded).tasks;
        final updatedList = <Task>[];

        for (final task in current) {
          if (task.id == event.id) {
            final updated = task.copyWith(isCompleted: !task.isCompleted);
            await FirebaseTaskService.updateTask(updated);
            updatedList.add(updated);
          } else {
            updatedList.add(task);
          }
        }

        emit(TaskLoaded(updatedList));
      }
    });
  }
}
