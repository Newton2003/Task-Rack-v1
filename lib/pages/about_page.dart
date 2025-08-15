import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final members = [
      'Imose Osayemwnere Newton  22/1976',
      'Onabanjo Deborah Adeola  22/2959',
      'Bashorun Faaiz Oluwafemi  22/3035',
      'Komolafe Fawaz  22/2283',
      'Olusona Oluwasemilore Emmanuel 22/2627',
      'Idowu Oluwatomisin David  22/2237',
      'Acho Ihim Chimeremeze  22/1659',
      'Ugo Chigozie Emmanuel  22/2608',
      'Ekpo Promise Aniedi  22/3082',
      'Osondu Oluebubechi Emmanuella  22/2627',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('About This App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Group Members:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...members.map(
              (member) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    member,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600, // slightly bolder
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'This app was built collaboratively to manage offline tasks efficiently, with a simple UI design.',
              style: TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
