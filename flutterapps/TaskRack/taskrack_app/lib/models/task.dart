import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  int folderId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description; // Nullable so it's optional

  @HiveField(3)
  DateTime? dueDate; // Nullable if user might not set it

  @HiveField(4)
  String? priority; // ✅ Nullable so ?? "No priority" works

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  bool isCompleted; // ✅ Added to track completion

  Task({
    required this.folderId,
    required this.title,
    this.description,
    this.dueDate,
    this.priority,
    required this.createdAt,
    this.isCompleted = false, // ✅ default to false
  });
}
