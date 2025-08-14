import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  String category; // NEW

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.category = "General",
  });
}
