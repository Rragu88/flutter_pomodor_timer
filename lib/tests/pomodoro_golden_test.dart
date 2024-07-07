import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/widgets/main_screen.dart'; // Adjust the import to your actual file

void main() {
  // this is a golden test that renders the pomodoro widget and then compares
  // the rendered output to a reference image to ensure the UI looks as expected.
  testWidgets('Pomodoro screen golden test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Pomodoro(),
        ),
      ),
    );

    await expectLater(
      find.byType(Pomodoro),
      matchesGoldenFile('goldens/pomodoro_screen.png'),
    );
  });
}
