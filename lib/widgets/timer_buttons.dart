import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro/providers/providers.dart';
import 'package:pomodoro/utils/update_progress.dart';

class TimerButtons extends ConsumerWidget {
  const TimerButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroDuration = ref.watch(pomodoroDurationProvider);
    final shortBreakDuration = ref.watch(shortBreakDurationProvider);
    final longBreakDuration = ref.watch(longBreakDurationProvider);
    final remainingTime = ref.watch(remainingTimeProvider);
    final isSelected = ref.watch(isSelectedProvider);
    final googleFont = ref.watch(googleFontProvider);
    final pageColor = ref.watch(pageColorProvider);
    final timer = ref.watch(timerProvider);

    return ToggleButtons(
      fillColor: pageColor,
      borderRadius: BorderRadius.circular(20),
      isSelected: isSelected,
      selectedColor: const Color.fromARGB(255, 30, 33, 63),
      onPressed: (int index) {
        // updates which toggleButton is selected
        ref.read(isSelectedProvider.notifier).state =
            List.generate(isSelected.length, (i) => i == index);

        // if you switch timers cancel the running timer and set
        // isRunning to false
        ref.read(isRunningProvider.notifier).state = false;
        timer?.cancel();

        // updates the time correctly based off of timer selected
        switch (index) {
          case 0:
            ref.read(remainingTimeProvider.notifier).state = pomodoroDuration;
            break;
          case 1:
            ref.read(remainingTimeProvider.notifier).state = shortBreakDuration;
            break;
          case 2:
            ref.read(remainingTimeProvider.notifier).state = longBreakDuration;
            break;
        }
        // then updates the progress
        updateProgress(ref, isSelected, remainingTime, pomodoroDuration,
            shortBreakDuration, longBreakDuration);
      },
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'pomodoro',
            style: googleFont.copyWith(
              // updates the color if selected
              color: isSelected[0]
                  ? const Color.fromARGB(255, 30, 33, 63)
                  : const Color.fromARGB(255, 215, 224, 255),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'short break',
            style: googleFont.copyWith(
              color: isSelected[1]
                  ? const Color.fromARGB(255, 30, 33, 63)
                  : const Color.fromARGB(255, 215, 224, 255),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'long break',
            style: googleFont.copyWith(
              color: isSelected[2]
                  ? const Color.fromARGB(255, 30, 33, 63)
                  : const Color.fromARGB(255, 215, 224, 255),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
