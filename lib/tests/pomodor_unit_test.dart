import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro/providers/providers.dart';
import 'package:pomodoro/utils/update_progress.dart';

void main() {
  // creates a provider container and expects the duration to be 25 * 60
  test('Pomodoro duration provider test', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final duration = container.read(pomodoroDurationProvider);
    expect(duration, 25 * 60);
  });

  // creates a provider container and expects the timer provider is null
  test('Timer provider test', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final timer = container.read(timerProvider);
    expect(timer, isNull);
  });

  // this test verifies that the updateProgress function correctly
  // updates the remainingTimeProvider and changes the isSelectedProvider state
  testWidgets('Update progress test', (WidgetTester tester) async {
    late WidgetRef widgetRef;

    // Create a widget that provides the WidgetRef
    final testWidget = ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          widgetRef = ref;
          return Container();
        },
      ),
    );

    // Pump the widget to get the WidgetRef
    await tester.pumpWidget(testWidget);

    final isSelected = widgetRef.read(isSelectedProvider);
    final remainingTime = widgetRef.read(remainingTimeProvider);
    final pomodoroDuration = widgetRef.read(pomodoroDurationProvider);
    final shortBreakDuration = widgetRef.read(shortBreakDurationProvider);
    final longBreakDuration = widgetRef.read(longBreakDurationProvider);

    updateProgress(widgetRef, isSelected, remainingTime, pomodoroDuration,
        shortBreakDuration, longBreakDuration);

    final updatedRemainingTime = widgetRef.read(remainingTimeProvider);
    expect(updatedRemainingTime, lessThan(remainingTime));

    final updatedIsSelected = widgetRef.read(isSelectedProvider);
    expect(updatedIsSelected, isNot(isSelected));
  });
}
