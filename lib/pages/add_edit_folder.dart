import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/folder.dart';

class AddEditFolderPage extends StatefulWidget {
  final Folder? existingFolder;

  const AddEditFolderPage({super.key, this.existingFolder});

  @override
  _AddEditFolderPageState createState() => _AddEditFolderPageState();
}

class _AddEditFolderPageState extends State<AddEditFolderPage> {
  late TextEditingController _nameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingFolder?.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveFolder() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Folder name cannot be empty')));
      return;
    }

    setState(() => _isSaving = true);

    final folderBox = Hive.box<Folder>('folders');

    if (widget.existingFolder != null) {
      widget.existingFolder!
        ..name = name
        ..save();
    } else {
      await folderBox.add(
        Folder(name: name, color: 'blue', createdAt: DateTime.now()),
      );
    }

    setState(() => _isSaving = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingFolder != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Folder' : 'Add Folder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Folder Name'),
              onChanged: (_) =>
                  setState(() {}), // To update Save button state dynamically
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_nameController.text.trim().isEmpty || _isSaving)
                  ? null
                  : _saveFolder,
              child: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
