import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static Widget builder(BuildContext context) => const AboutScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = PrefUtils().getIsDarkMode();
    final linkStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isDark ? const Color(0xFF87D1A4) : const Color(0xFF006754),
      decoration: TextDecoration.underline,
    );

    Future<void> copy(String text) async {
      await Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('lbl_copied'.tr)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('about_title'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('app_name'.tr,
                style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('about_intro'.tr, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Text('about_ack_heading'.tr, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('about_ack_idea_by'.tr),
            const SizedBox(height: 8),
            GestureDetector(
              onLongPress: () => copy('https://github.com/abualgait'),
              child: Text('https://github.com/abualgait', style: linkStyle),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onLongPress: () => copy('https://github.com/abualgait/HafizApp'),
              child: Text('about_repo_prefix'.tr +
                  ' https://github.com/abualgait/HafizApp', style: linkStyle),
            ),
            const SizedBox(height: 8),
            Text('about_maintainer_note'.tr),
            const SizedBox(height: 24),
            Text('about_integrity_heading'.tr,
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('about_integrity_body'.tr),
          ],
        ),
      ),
    );
  }
}
