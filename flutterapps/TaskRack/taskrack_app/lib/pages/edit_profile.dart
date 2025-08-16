import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load current saved name
    final box = Hive.box<UserProfile>('user_profile');
    final profile = box.get('profile');
    if (profile != null) {
      _controller.text = profile.name;
    }
  }

  void _saveProfile() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid name')));
      return;
    }

    final box = Hive.box<UserProfile>('user_profile');
    final updatedProfile = UserProfile(name: name);
    await box.put('profile', updatedProfile);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Name updated successfully!')));

    Navigator.pop(context); // Go back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(onPressed: _saveProfile, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
