// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:hafiz_app/core/utils/pref_utils.dart';
import 'package:hafiz_app/injection_container.dart' as di;
import 'package:hafiz_app/main.dart';

void main() {
  testWidgets('Get started clicked open Home Screen',
      (WidgetTester tester) async {
    await PrefUtils().init();
    await di.init();
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pump();

    expect(find.text('Hafiz'), findsOneWidget);
    expect(find.text('Learn Quran and\nRecite everyday'), findsOneWidget);
  });
}
