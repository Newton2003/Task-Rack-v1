import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/folder.dart';
import 'add_edit_task.dart';

class FolderDetailsPage extends StatelessWidget {
  final Folder folder;

  const FolderDetailsPage({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final taskBox = Hive.box<Task>('tasks');

    return Scaffold(
      appBar: AppBar(title: Text(folder.name)),
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: taskBox.listenable(),
        builder: (context, box, _) {
          final folderTasks = box.values
              .where((task) => task.folderId == folder.key)
              .toList();

          if (folderTasks.isEmpty) {
            return const Center(child: Text("No tasks yet in this folder"));
          }

          return ListView.builder(
            itemCount: folderTasks.length,
            itemBuilder: (context, index) {
              final task = folderTasks[index];
              return Dismissible(
                key: Key(task.key.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Delete Task?'),
                          content: Text(
                            'Are you sure you want to delete "${task.title}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                },
                onDismissed: (direction) {
                  task.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task "${task.title}" deleted')),
                  );
                },
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.priority ?? "No priority"),
                  trailing: GestureDetector(
                    onTap: () {
                      task.isCompleted = !task.isCompleted;
                      task.save();
                    },
                    child: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.isCompleted ? Colors.green : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditTaskPage(
                          folderId: folder.key as int,
                          existingTask: task,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue, // match app accent
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditTaskPage(folderId: folder.key as int),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
