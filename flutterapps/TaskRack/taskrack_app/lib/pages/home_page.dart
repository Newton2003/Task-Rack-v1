import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/folder.dart';
import 'add_edit_folder.dart';
import '../models/user_profile.dart';
import 'about_page.dart';
import 'folder_page.dart';
import 'edit_profile.dart';

class GlassMorphism extends StatelessWidget {
  const GlassMorphism({
    super.key,
    required this.child,
    required this.blur,
    required this.opacity,
    required this.color,
    this.borderRadius,
  });

  final Widget child;
  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Color accentColor;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomePage({
    super.key,
    required this.accentColor,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final userProfileBox = Hive.box<UserProfile>('user_profile');
    final glassColor = isDarkMode ? Colors.black : Colors.blue.shade100;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskRack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            tooltip: 'Edit Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.blue),
            tooltip: 'About',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
            tooltip: 'Toggle Theme',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [const Color.fromARGB(255, 36, 35, 35), Colors.black]
                : [
                    const Color.fromARGB(255, 227, 246, 253),
                    const Color.fromARGB(255, 238, 233, 233),
                  ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ValueListenableBuilder<Box<UserProfile>>(
              valueListenable: userProfileBox.listenable(),
              builder: (context, profileBox, _) {
                final profile = profileBox.get('profile');
                return Center(
                  child: Text(
                    'Welcome ${profile?.name ?? ''} 😊',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                "Folders",
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ValueListenableBuilder<Box<Folder>>(
                valueListenable: Hive.box<Folder>('folders').listenable(),
                builder: (context, folderBox, _) {
                  final folders = folderBox.values.toList();

                  if (folders.isEmpty) {
                    return Center(
                      child: Text(
                        'No folders added yet',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      final folder = folders[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: GlassMorphism(
                          blur: 10,
                          opacity: 0.2,
                          color: glassColor,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              FolderDetailsPage(folder: folder),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      folder.name,
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: accentColor,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AddEditFolderPage(
                                              existingFolder: folder,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        final confirmed =
                                            await showDialog<bool>(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: const Text(
                                                  'Delete Folder?',
                                                ),
                                                content: Text(
                                                  'Are you sure you want to delete "${folder.name}"? This will also delete its tasks.',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                            ) ??
                                            false;

                                        if (confirmed) {
                                          folder.delete();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditFolderPage()),
          );
        },
      ),
    );
  }
}
