import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../core/i18n/locale_controller.dart';

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

    void copy(String text) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('lbl_copied'.tr)));
    }

    Future<void> openExternal(String url) async {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    }

    return Scaffold(
      appBar: AppBar(title: Text('about_title'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('app_name'.tr,
              style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text('about_intro'.tr, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text('about_ack_heading'.tr,
                      style: theme.textTheme.titleMedium),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text('about_ack_idea_by'.tr),
                  subtitle: Text('https://github.com/abualgait', style: linkStyle),
                  onTap: () => openExternal('https://github.com/abualgait'),
                  onLongPress: () => copy('https://github.com/abualgait'),
                  trailing: const Icon(Icons.open_in_new),
                ),
                ListTile(
                  leading: const Icon(Icons.link_outlined),
                  title: Text('about_repo_prefix'.tr),
                  subtitle: Text('https://github.com/abualgait/HafizApp',
                      style: linkStyle),
                  onTap: () => openExternal('https://github.com/abualgait/HafizApp'),
                  onLongPress: () => copy('https://github.com/abualgait/HafizApp'),
                  trailing: const Icon(Icons.open_in_new),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.feedback_outlined),
                  title: Text('about_feedback_title'.tr),
                  subtitle: Text('about_feedback_desc'.tr),
                  onTap: () => openExternal(
                      'mailto:hafiz.app.feedback@example.com?subject=Hafiz%20App%20Feedback&body=Describe%20your%20issue%20or%20suggestion...'),
                  trailing: const Icon(Icons.open_in_new),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text('about_sources_title'.tr,
                      style: theme.textTheme.titleMedium),
                ),
                ListTile(
                  leading: const Icon(Icons.public),
                  title: Text('about_source_quran_api'.tr, style: linkStyle),
                  onTap: () => openExternal('https://api.quran.com/api/v4'),
                  onLongPress: () => copy('https://api.quran.com/api/v4'),
                  trailing: const Icon(Icons.open_in_new),
                ),
                ListTile(
                  leading: const Icon(Icons.public),
                  title:
                      Text('about_source_tanzil'.tr, style: linkStyle),
                  onTap: () => openExternal('https://tanzil.net/download/'),
                  onLongPress: () => copy('https://tanzil.net/download/'),
                  trailing: const Icon(Icons.open_in_new),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text('about_language_title'.tr,
                      style: theme.textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            LocaleController.setLocale(const Locale('ar', 'EG'));
                          },
                          child: const Text('العربية'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            LocaleController.setLocale(const Locale('en', 'US'));
                          },
                          child: const Text('English'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('about_integrity_heading'.tr,
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('about_integrity_body'.tr),
        ],
      ),
    );
  }
}
