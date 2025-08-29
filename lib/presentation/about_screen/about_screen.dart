import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static Widget builder(BuildContext context) => const AboutScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('About Hafiz App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Hafiz App',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'This app is non‑profit and intended as a good deed for us and our families. '
              'We aim to provide a respectful, reliable Quran reading experience.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text('Acknowledgements', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'Original idea and initial project by: ',
            ),
            const SelectableText(
              'https://github.com/abualgait',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            const SizedBox(height: 4),
            const SelectableText(
              'Project repo: https://github.com/abualgait/HafizApp',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            const SizedBox(height: 8),
            const Text(
              'This version includes small fixes and updates by the current maintainer.',
            ),
            const SizedBox(height: 24),
            Text('Quran Text Integrity', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'Arabic Quran text is bundled locally from a verified source to prevent tampering and to work offline. '
              'If you find any issue, please report it so we can correct it swiftly.',
            ),
          ],
        ),
      ),
    );
  }
}

