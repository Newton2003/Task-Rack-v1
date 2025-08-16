import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/folder.dart';
import 'models/task.dart';
import 'models/user_profile.dart';
import 'pages/home_page.dart';
import 'pages/user_profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(FolderAdapter());
  Hive.registerAdapter(TaskAdapter());
  // Hive.registerAdapter(TaskPriorityAdapter());

  await Hive.openBox<UserProfile>('user_profile');
  await Hive.openBox<Folder>('folders');
  await Hive.openBox<Task>('tasks');
  await Hive.openBox('settings'); // ✅ for dark mode persistence

  final profileBox = Hive.box<UserProfile>('user_profile');
  final hasProfile = profileBox.get('profile') != null;

  runApp(MyApp(hasProfile: hasProfile));
}

class MyApp extends StatefulWidget {
  final bool hasProfile;
  const MyApp({super.key, required this.hasProfile});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    final settingsBox = Hive.box('settings');
    isDarkMode = settingsBox.get('isDarkMode', defaultValue: false);
  }

  void toggleTheme() {
    final settingsBox = Hive.box('settings');
    final newMode = !isDarkMode;
    settingsBox.put('isDarkMode', newMode); // ✅ save to Hive
    setState(() {
      isDarkMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskRack',
      theme: ThemeData(
        fontFamily: 'Nunito',
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ).copyWith(secondary: Colors.blue),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Nunito',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Pure AMOLED black
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blue,
          surface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        cardColor: Colors.grey[900],
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: widget.hasProfile
          ? HomePage(
              accentColor: Colors.blue,
              isDarkMode: isDarkMode,
              onToggleTheme: toggleTheme,
            )
          : const UserProfilePage(),
    );
  }
}
