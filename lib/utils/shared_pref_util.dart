import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class SharedPrefsUtil {
  static const String tasksKey = 'tasks';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks.map((task) => jsonEncode(task.toMap())).toList();
    await prefs.setStringList(tasksKey, taskList);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList(tasksKey);
    if (taskList == null) return [];
    return taskList.map((taskStr) {
      final Map<String, dynamic> map = jsonDecode(taskStr);
      return Task.fromMap(map);
    }).toList();
  }
}
