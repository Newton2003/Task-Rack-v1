import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- needed for input formatter
import 'package:hive/hive.dart';
import '../models/user_profile.dart';
import 'home_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _controller = TextEditingController();

  void _saveProfile() async {
    String name = _controller.text.trim();
    if (name.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Name Required'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Text('Please enter your name to continue.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Capitalize first letter
    name = name[0].toUpperCase() + (name.length > 1 ? name.substring(1) : '');

    final box = Hive.box<UserProfile>('user_profile');
    final profile = UserProfile(name: name);
    await box.put('profile', profile);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomePage(
          accentColor: Colors.blue,
          isDarkMode: false,
          onToggleTheme: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your name',
              style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              style: TextStyle(fontFamily: 'Nunito'),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z ]'),
                ), // allow spaces
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Continue', style: TextStyle(fontFamily: 'Nunito')),
            ),
          ],
        ),
      ),
    );
  }
}
