import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro/providers/providers.dart';
import 'package:pomodoro/widgets/timer_buttons.dart';
import 'package:pomodoro/utils/update_progress.dart';
import 'package:pomodoro/widgets/pomodoro_timer.dart';
import 'package:pomodoro/widgets/settings_button.dart';

class Pomodoro extends ConsumerWidget {
  const Pomodoro({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroDuration = ref.watch(pomodoroDurationProvider);
    final shortBreakDuration = ref.watch(shortBreakDurationProvider);
    final longBreakDuration = ref.watch(longBreakDurationProvider);
    final remainingTime = ref.watch(remainingTimeProvider);
    final isSelected = ref.watch(isSelectedProvider);
    final googleFont = ref.watch(googleFontProvider);
    final timer = ref.watch(timerProvider);

    // this code ensures that the timer's state and progress are correctly
    // manaage and updated after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (remainingTime > 0) {
        updateProgress(ref, isSelected, remainingTime, pomodoroDuration,
            shortBreakDuration, longBreakDuration);
      } else {
        timer?.cancel();
        ref.read(isRunningProvider.notifier).state = false;
      }
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 33, 63),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'pomodoro',
              style: googleFont.copyWith(
                color: const Color.fromARGB(255, 215, 224, 255),
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 22, 25, 50),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(10),
              child: const TimerButtons(),
            ),
            const SizedBox(height: 50),
            const PomodoroTimer(),
            const SizedBox(height: 50),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SettingsButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
