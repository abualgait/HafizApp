import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import 'package:hafiz_app/injection_container.dart';
import '../../core/analytics/analytics_service.dart';
import 'package:hafiz_app/main.dart' show globalMessengerKey;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
      try {
        bool ok = await launchUrlString(url, mode: LaunchMode.externalApplication);
        if (!ok) {
          // Fallback to platform default (may open custom tabs/in-app)
          ok = await launchUrlString(url, mode: LaunchMode.platformDefault);
        }
        if (!ok) {
          globalMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text('Could not open: $url')),
          );
        }
        if (ok) {
          sl<AnalyticsService>().logLinkOpened(url);
        }
      } catch (e) {
        globalMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Could not open: $url')),
        );
      }
    }

    Future<void> showFeedbackDialog() async {
      final controller = TextEditingController();
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('about_feedback_title'.tr),
          content: TextField(
            controller: controller,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'about_feedback_hint'.tr,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final body = Uri.encodeComponent(controller.text);
                openExternal(
                    'mailto:motazhamada@gmail.com?subject=Hafiz%20App%20Feedback&body=$body');
                Navigator.of(ctx).pop();
              },
              child: const Text('Email'),
            ),
            FilledButton(
              onPressed: () async {
                final msg = controller.text.trim();
                try {
                  if (msg.isNotEmpty) {
                    await FirebaseCrashlytics.instance
                        .setCustomKey('user_feedback', msg);
                    await FirebaseCrashlytics.instance.setCustomKey(
                        'user_feedback_time',
                        DateTime.now().toIso8601String());
                    await FirebaseCrashlytics.instance.recordError(
                      Exception('UserFeedback'),
                      StackTrace.current,
                      reason: 'User submitted feedback',
                      fatal: false,
                    );
                    await sl<AnalyticsService>()
                        .logFeedbackSubmitted(method: 'crashlytics');
                  }
                  globalMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('about_feedback_sent'.tr)),
                  );
                } catch (_) {}
                if (context.mounted) Navigator.of(ctx).pop();
              },
              child: Text('about_feedback_send'.tr),
            ),
          ],
        ),
      );
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
                  subtitle: Text(
                    'https://github.com/abualgait',
                    style: linkStyle,
                  ),
                  onTap: () => openExternal('https://github.com/abualgait'),
                  onLongPress: () => copy('https://github.com/abualgait'),
                  trailing: const Icon(Icons.open_in_new),
                ),
                ListTile(
                  leading: const Icon(Icons.link_outlined),
                  title: Text('about_repo_prefix'.tr),
                  subtitle: Text(
                    'https://github.com/abualgait/HafizApp',
                    style: linkStyle,
                  ),
                  onTap: () =>
                      openExternal('https://github.com/abualgait/HafizApp'),
                  onLongPress: () =>
                      copy('https://github.com/abualgait/HafizApp'),
                  trailing: const Icon(Icons.open_in_new),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.feedback_outlined),
                  title: Text('about_feedback_title'.tr),
                  subtitle: Text('about_feedback_desc'.tr),
                  onTap: showFeedbackDialog,
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
