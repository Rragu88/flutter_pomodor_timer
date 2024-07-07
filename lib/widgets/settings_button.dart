import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro/providers/providers.dart';
import 'package:pomodoro/widgets/settings_modal.dart';
import 'package:pomodoro/utils/reset_timer.dart';

// function to display the modal and receives an onApply callback
void showSettingsModal(
    BuildContext context, Function(int, int, int, TextStyle, Color) onApply) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return SettingsModal(
        onApply: onApply,
      );
    },
  );
}

class SettingsButton extends ConsumerWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroDuration = ref.watch(pomodoroDurationProvider);
    final shortBreakDuration = ref.watch(shortBreakDurationProvider);
    final remainingTime = ref.watch(remainingTimeProvider);
    final isSelected = ref.watch(isSelectedProvider);
    final timer = ref.watch(timerProvider);

    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        // opens the modal
        showSettingsModal(context, (int pomodoroTime, int shortTime,
            int longTime, TextStyle font, Color color) {
          // sets the state based off of the setting coming
          // from the modal
          ref.read(pomodoroDurationProvider.notifier).state = pomodoroTime * 60;
          ref.read(shortBreakDurationProvider.notifier).state = shortTime * 60;
          ref.read(longBreakDurationProvider.notifier).state = longTime * 60;
          ref.read(googleFontProvider.notifier).state = font;
          ref.read(pageColorProvider.notifier).state = color;

          resetTimer(ref, isSelected, remainingTime, pomodoroDuration,
              shortBreakDuration, timer);
        });
      },
      iconSize: 35,
      color: const Color.fromARGB(255, 215, 224, 255),
    );
  }
}
