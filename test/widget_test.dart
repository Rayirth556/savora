import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savora/main.dart';

void main() {
  testWidgets('Login screen loads with username and password fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(initialThemeMode: ThemeMode.system));

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
