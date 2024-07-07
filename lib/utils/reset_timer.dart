import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro/providers/providers.dart';
import 'package:pomodoro/utils/update_progress.dart';
import 'dart:async';

// this function cancels the timer, sets the isRunning state to false, updates
// the state for the selected timer, and then updates the progress
void resetTimer(WidgetRef ref, List<bool> isSelected, int pomodoroDuration,
    int shortBreakDuration, int longBreakDuration, Timer? timer) {
  timer?.cancel();
  ref.read(isRunningProvider.notifier).state = false;

  if (isSelected[0]) {
    ref.read(remainingTimeProvider.notifier).state = pomodoroDuration;
  } else if (isSelected[1]) {
    ref.read(remainingTimeProvider.notifier).state = shortBreakDuration;
  } else if (isSelected[2]) {
    ref.read(remainingTimeProvider.notifier).state = longBreakDuration;
  }
  updateProgress(ref, isSelected, ref.read(remainingTimeProvider),
      pomodoroDuration, shortBreakDuration, longBreakDuration);
}
