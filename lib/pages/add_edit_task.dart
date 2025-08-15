import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class AddEditTaskPage extends StatefulWidget {
  final int folderId;
  final Task? existingTask;

  const AddEditTaskPage({super.key, required this.folderId, this.existingTask});

  @override
  _AddEditTaskPageState createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String? _priority;

  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      final task = widget.existingTask!;
      _titleController.text = task.title;
      _descriptionController.text = task.description ?? '';
      _dueDate = task.dueDate;
      _priority = task.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task title cannot be empty')));
      return;
    }

    final taskBox = Hive.box<Task>('tasks');

    if (widget.existingTask != null) {
      // Update existing task
      final task = widget.existingTask!;
      task
        ..title = title
        ..description = _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim()
        ..dueDate = _dueDate
        ..priority = _priority
        ..save();
    } else {
      // Add new task
      taskBox.add(
        Task(
          folderId: widget.folderId,
          title: title,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          dueDate: _dueDate,
          priority: _priority,
          createdAt: DateTime.now(),
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTask != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title *'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 12),
            ListTile(
              title: Text(
                _dueDate == null
                    ? 'No due date'
                    : 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDueDate,
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              decoration: const InputDecoration(labelText: 'Priority'),
              value: _priority,
              items: [null, ..._priorities].map((p) {
                return DropdownMenuItem<String?>(
                  value: p,
                  child: Text(p ?? 'No priority'),
                );
              }).toList(),
              onChanged: (val) => setState(() => _priority = val),
            ),

            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text(isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
