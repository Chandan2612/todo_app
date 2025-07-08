// import 'package:firebase_database/firebase_database.dart';
// import 'package:travel/tasks/task_model.dart';

// class FirebaseTaskService {
//   static final _dbRef = FirebaseDatabase.instance.ref().child("tasks");

//   static Future<List<Task>> fetchTasks() async {
//     try {
//       final snapshot = await _dbRef.get();
//       if (!snapshot.exists || snapshot.value == null) return [];

//       final rawData = snapshot.value as Map;
//       return rawData.entries.map((entry) {
//         final id = entry.key;
//         final data = Map<String, dynamic>.from(entry.value);
//         return Task.fromJson(data, id);
//       }).toList();
//     } catch (e) {
//       print("❌ Error fetching tasks: $e");
//       return [];
//     }
//   }

//   static Future<void> addTask(Task task) async {
//     try {
//       await _dbRef.child(task.id).set(task.toJson());
//     } catch (e) {
//       print("❌ Error adding task: $e");
//     }
//   }

//   static Future<void> updateTask(Task task) async {
//     try {
//       await _dbRef.child(task.id).update(task.toJson());
//     } catch (e) {
//       print("❌ Error updating task: $e");
//     }
//   }

//   static Future<void> deleteTask(String id) async {
//     try {
//       await _dbRef.child(id).remove();
//     } catch (e) {
//       print("❌ Error deleting task: $e");
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travel/tasks/task_model.dart';

class FirebaseTaskService {
  // 🔐 Get the current user's UID
  static String get _uid => FirebaseAuth.instance.currentUser?.uid ?? "unknown_user";

  // 📂 Get reference to /tasks/uid/
  static DatabaseReference get _userTaskRef => FirebaseDatabase.instance.ref().child("tasks").child(_uid);

  // 📥 Fetch tasks only for the current user
  static Future<List<Task>> fetchTasks() async {
    try {
      final snapshot = await _userTaskRef.get();
      if (!snapshot.exists || snapshot.value == null) return [];

      final rawData = snapshot.value as Map;
      return rawData.entries.map((entry) {
        final id = entry.key;
        final data = Map<String, dynamic>.from(entry.value);
        return Task.fromJson(data, id);
      }).toList();
    } catch (e) {
      print("❌ Error fetching tasks: $e");
      return [];
    }
  }

  // ➕ Add task under current user's node
  static Future<void> addTask(Task task) async {
    try {
      await _userTaskRef.child(task.id).set(task.toJson());
    } catch (e) {
      print("❌ Error adding task: $e");
    }
  }

  // ✏️ Update task for the current user
  static Future<void> updateTask(Task task) async {
    try {
      await _userTaskRef.child(task.id).update(task.toJson());
    } catch (e) {
      print("❌ Error updating task: $e");
    }
  }

  // ❌ Delete task for the current user
  static Future<void> deleteTask(String id) async {
    try {
      await _userTaskRef.child(id).remove();
    } catch (e) {
      print("❌ Error deleting task: $e");
    }
  }
}
