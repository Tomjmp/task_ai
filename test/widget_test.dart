import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task_ai/main.dart';

void main() {
  testWidgets('La app arranca y muestra el título', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskAIApp());
    expect(find.text('TaskAI v1.0'), findsOneWidget);
  });
}