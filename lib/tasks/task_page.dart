import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/tasks/bloc/task_bloc.dart';
import 'package:travel/tasks/bloc/task_event.dart';
import 'package:travel/tasks/bloc/task_state.dart';
import 'package:travel/tasks/task_model.dart';
import 'package:travel/core/theme_cubit.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
  }

  void _addTask() {
    final title = ctrl.text.trim();
    if (title.isNotEmpty) {
      context.read<TaskBloc>().add(AddTask(title));
      ctrl.clear();
    }
  }

  void _showEditDialog(Task task) {
    final editCtrl = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('✏️ Edit Task'),
        content: TextField(
          controller: editCtrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter new title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = editCtrl.text.trim();
              if (newTitle.isNotEmpty && newTitle != task.title) {
                final updatedTask = task.copyWith(title: newTitle);
                context.read<TaskBloc>().add(UpdateTask(updatedTask));
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: "Add New Task",
          hintText: "e.g. Buy groceries",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTask,
          ),
        ),
        onSubmitted: (_) => _addTask(),
      ),
    );
  }

  Widget _buildTaskList(TaskState state) {
    if (state is TaskInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TaskLoaded) {
      final tasks = state.tasks;

      if (tasks.isEmpty) {
        return const Center(
          child: Text("🚫 No tasks yet.\nTap ➕ to add one!", textAlign: TextAlign.center),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: tasks.length,
        itemBuilder: (_, i) {
          final task = tasks[i];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (_) {
                  final updated = task.copyWith(isCompleted: !task.isCompleted);
                  context.read<TaskBloc>().add(UpdateTask(updated));
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () => _showEditDialog(task),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      context.read<TaskBloc>().add(DeleteTask(task.id));
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return const Center(child: Text("❗ Something went wrong"));
  }

  Drawer _buildDrawer() {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Logged In"),
            accountEmail: Text(user?.email ?? "No email"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text("Toggle Theme"),
            trailing: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                return Switch(
                  value: mode == ThemeMode.dark,
                  onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📝 Your Tasks")),
      drawer: _buildDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              _buildTaskInput(),
              Expanded(child: BlocBuilder<TaskBloc, TaskState>(builder: (_, state) => _buildTaskList(state))),
            ],
          );
        },
      ),
    );
  }
}
