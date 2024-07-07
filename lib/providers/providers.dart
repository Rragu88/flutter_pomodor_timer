import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

// Define providers for the state variables
final pomodoroDurationProvider = StateProvider<int>((ref) => 25 * 60);
final shortBreakDurationProvider = StateProvider<int>((ref) => 5 * 60);
final longBreakDurationProvider = StateProvider<int>((ref) => 15 * 60);
final remainingTimeProvider = StateProvider<int>((ref) => 25 * 60);
final progressProvider = StateProvider<double>((ref) => 0.0);
final isRunningProvider = StateProvider<bool>((ref) => false);
final isSelectedProvider =
    StateProvider<List<bool>>((ref) => [true, false, false]);
final googleFontProvider =
    StateProvider<TextStyle>((ref) => GoogleFonts.kumbhSans());
final pageColorProvider =
    StateProvider<Color>((ref) => const Color.fromARGB(255, 248, 112, 112));
final timerProvider = StateProvider<Timer?>((ref) => null);
final selectedColorIndexProvider = StateProvider<int>((ref) => 0);
final selectedFontIndexProvider = StateProvider<int>((ref) => 0);
final selectedPomodoroTimeProvider = StateProvider<int>((ref) => 25);
final selectedShortTimeProvider = StateProvider<int>((ref) => 5);
final selectedLongTimeProvider = StateProvider<int>((ref) => 15);

final colorsProvider = Provider<List<Color>>((ref) => [
      const Color.fromARGB(255, 248, 112, 112),
      const Color.fromARGB(255, 112, 243, 248),
      const Color.fromARGB(255, 216, 129, 248),
    ]);

final fontsProvider = Provider<List<TextStyle>>((ref) => [
      GoogleFonts.kumbhSans(),
      GoogleFonts.robotoSlab(),
      GoogleFonts.spaceMono(),
    ]);
