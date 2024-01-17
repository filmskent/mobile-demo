// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/todo_list_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Add, Delete, Checkbox todoList test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => TodoListService(),
      child: const MyApp(),
    ));

    expect(find.byIcon(Icons.add), findsOneWidget);

    // Add items.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'list1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'ADD'));

    await tester.pump();

    expect(find.text('list1'), findsOneWidget);

    expect(
        tester
            .getSemantics(find.text("list1"))
            .getSemanticsData()
            .hasFlag(SemanticsFlag.isChecked),
        false);

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('list1'), findsNothing);
  });

  testWidgets('Not add when empty item test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => TodoListService(),
      child: const MyApp(),
    ));

    expect(find.byIcon(Icons.add), findsOneWidget);

    // Add items.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, 'ADD'));
    await tester.pump();

    expect(find.text('list1'), findsNothing);
  });
}
