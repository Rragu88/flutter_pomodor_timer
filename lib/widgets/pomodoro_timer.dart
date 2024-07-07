import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro/providers/providers.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pomodoro/utils/update_progress.dart';
import 'package:pomodoro/utils/reset_timer.dart';

class PomodoroTimer extends ConsumerWidget {
  const PomodoroTimer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroDuration = ref.watch(pomodoroDurationProvider);
    final shortBreakDuration = ref.watch(shortBreakDurationProvider);
    final longBreakDuration = ref.watch(longBreakDurationProvider);
    final remainingTime = ref.watch(remainingTimeProvider);
    final progress = ref.watch(progressProvider);
    final isRunning = ref.watch(isRunningProvider);
    final isSelected = ref.watch(isSelectedProvider);
    final googleFont = ref.watch(googleFontProvider);
    final pageColor = ref.watch(pageColorProvider);
    final timer = ref.watch(timerProvider);

    // this function starts the timer
    void startTimer() {
      timer?.cancel();
      ref.read(timerProvider.notifier).state =
          Timer.periodic(const Duration(seconds: 1), (timer) {
        ref.read(isRunningProvider.notifier).state = true;
        if (remainingTime > 0) {
          ref.read(remainingTimeProvider.notifier).state--;
        } else {
          timer.cancel();
          ref.read(isRunningProvider.notifier).state = false;
          updateProgress(ref, isSelected, remainingTime, pomodoroDuration,
              shortBreakDuration, longBreakDuration);
        }
      });
    }

    // pause the timer
    void pauseTimer() {
      timer?.cancel();
      ref.read(isRunningProvider.notifier).state = false;
    }

    // converts remainingTime into a string formatted MM:SS
    String timerText =
        '${(remainingTime ~/ 60).toString().padLeft(2, '0')}:${(remainingTime % 60).toString().padLeft(2, '0')}';

    return SizedBox(
      width: 350.0,
      height: 350.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 350.0,
            height: 350.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 14, 17, 42),
                Color.fromARGB(255, 46, 50, 90)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
          ),
          Container(
            width: 320.0,
            height: 320.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(80, 14, 17, 42),
            ),
            child: CircularPercentIndicator(
              radius: 150,
              lineWidth: 9.0,
              percent: progress,
              center: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timerText,
                      style: googleFont.copyWith(
                        color: const Color.fromARGB(255, 215, 224, 255),
                        fontSize: 95.0,
                        letterSpacing: -5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // if statement to display the correct button based
                    // of what the timer is doing
                    if (!isRunning && remainingTime > 0)
                      TextButton(
                        onPressed: startTimer,
                        child: Text(
                          'START',
                          style: googleFont.copyWith(
                            color: const Color.fromARGB(255, 215, 224, 255),
                            fontSize: 14,
                            letterSpacing: 13.13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (isRunning)
                      TextButton(
                        onPressed: pauseTimer,
                        child: Text(
                          'PAUSE',
                          style: googleFont.copyWith(
                            color: const Color.fromARGB(255, 215, 224, 255),
                            fontSize: 14,
                            letterSpacing: 13.13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (!isRunning && remainingTime == 0)
                      TextButton(
                        onPressed: () => resetTimer(
                            ref,
                            isSelected,
                            pomodoroDuration,
                            shortBreakDuration,
                            longBreakDuration,
                            timer),
                        child: Text(
                          'RESTART',
                          style: googleFont.copyWith(
                            color: const Color.fromARGB(255, 215, 224, 255),
                            fontSize: 14,
                            letterSpacing: 13.13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              progressColor: pageColor,
              backgroundColor: Colors.white24,
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ),
        ],
      ),
    );
  }
}
