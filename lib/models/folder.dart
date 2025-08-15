import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId: 0)
class Folder extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String color; // e.g., "blue"

  @HiveField(2)
  DateTime createdAt;

  Folder({required this.name, required this.color, required this.createdAt});
}
