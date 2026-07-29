import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('ThemeVerse showcase app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ThemeVerseShowcaseApp());
    await tester.pumpAndSettle();
    expect(find.text('ThemeVerse Engine'), findsAtLeast(1));
  });
}
