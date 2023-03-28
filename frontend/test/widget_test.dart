// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:report_ease/main.dart';
import 'package:report_ease/signin.dart';

void main() {
  testWidgets('Initial Signin page test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the Signin page is displayed.
    expect(find.byType(Signin), findsOneWidget);

    // Verify the presence of email and password input fields.
    expect(find.byKey(const ValueKey('email-field')), findsOneWidget);
    expect(find.byKey(const ValueKey('password-field')), findsOneWidget);

    // Verify the presence of the Signin and Signup buttons.
    expect(find.text('Signin'), findsOneWidget);
    expect(find.text('Signup'), findsOneWidget);
  });
}
