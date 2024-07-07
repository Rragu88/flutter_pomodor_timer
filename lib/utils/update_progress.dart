import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro/providers/providers.dart';

// dynamically updates the progress
void updateProgress(WidgetRef ref, List<bool> isSelected, int remainingTime,
    int pomodoroDuration, int shortBreakDuration, int longBreakDuration) {
  double newProgress;
  if (isSelected[0]) {
    newProgress = remainingTime / pomodoroDuration;
  } else if (isSelected[1]) {
    newProgress = remainingTime / shortBreakDuration;
  } else {
    newProgress = remainingTime / longBreakDuration;
  }

  // Clamp the progress value between 0.0 and 1.0
  newProgress = newProgress.clamp(0.0, 1.0);
  if (newProgress != ref.read(progressProvider)) {
    ref.read(progressProvider.notifier).state = newProgress;
  }
}
