import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/providers/providers.dart';
import 'package:pomodoro/utils/update_progress.dart';

class SettingsModal extends ConsumerWidget {
  const SettingsModal({super.key, required this.onApply});

  final Function(int, int, int, TextStyle, Color) onApply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // sets initial values
    final selectedColorIndex = ref.watch(selectedColorIndexProvider);
    final selectedFontIndex = ref.watch(selectedFontIndexProvider);
    final selectedPomodoroTime = ref.watch(selectedPomodoroTimeProvider);
    final selectedShortTime = ref.watch(selectedShortTimeProvider);
    final selectedLongTime = ref.watch(selectedLongTimeProvider);
    final colors = ref.watch(colorsProvider);
    final pomodoroDuration = ref.watch(pomodoroDurationProvider);
    final fonts = ref.watch(fontsProvider);
    final remainingTime = ref.watch(remainingTimeProvider);
    final shortBreakDuration = ref.watch(shortBreakDurationProvider);
    final longBreakDuration = ref.watch(longBreakDurationProvider);

    void onColorOptionSelected(int index) {
      ref.read(selectedColorIndexProvider.notifier).state = index;
    }

    // updates that font index state to the index of the selected font option
    void onFontOptionSelected(int index) {
      ref.read(selectedFontIndexProvider.notifier).state = index;
    }

    // builds the font option buttons
    Widget buildFontOption(String label, int index) {
      return TextButton(
        onPressed: () => onFontOptionSelected(index),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 239, 241, 250),
            // if the font option is selected change it's background color
            border: selectedFontIndex == index
                ? Border.all(color: Colors.black, width: 2)
                : null,
            shape: BoxShape.circle,
          ),
          child: Text(label,
              // sets each button to different fonts based off index
              style: fonts[index]),
        ),
      );
    }

    // builds the color option buttons
    Widget buildColorOption(Color color, int index) {
      return TextButton(
        onPressed: () => onColorOptionSelected(index),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            // if the color option is selected set its border
            border: selectedColorIndex == index
                ? Border.all(color: Colors.black, width: 2)
                : null,
          ),
        ),
      );
    }

    // builds the time setting dropdowns
    Widget buildTimeSetting(
        String label, int initialValue, StateProvider<int> provider) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.kumbhSans(
              textStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            width: 200, // Adjust the width as needed
            child: DropdownButtonFormField<int>(
              value: initialValue,
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 239, 241, 250),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // creates a dropdown list of 1-60
              items: List.generate(60, (index) => index + 1)
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    '$value',
                    style: GoogleFonts.kumbhSans(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
              // when the dropdown is changed checks if the value is not equal
              // to null, if so run the onDropdownChange fuction for newValue
              onChanged: (int? newValue) {
                if (newValue != null) {
                  ref.read(provider.notifier).state = newValue;
                }
              },
            ),
          ),
        ],
      );
    }

    // builds the title for sections
    Widget buildSectionTitle(String title) {
      return Center(
        child: Text(
          title,
          style: GoogleFonts.kumbhSans(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 4.23,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Settings',
                  style: GoogleFonts.kumbhSans(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 30, 33, 63),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                // closes the modal
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const Divider(
            height: 50,
          ),
          buildSectionTitle('TIME (MINUTES)'),
          const SizedBox(height: 20),
          // creates the timer widgets and sets the newly selected time to
          // the time for the certain timer
          buildTimeSetting(
              'pomodoro', selectedPomodoroTime, selectedPomodoroTimeProvider),
          const SizedBox(height: 10),
          buildTimeSetting(
              'short break', selectedShortTime, selectedShortTimeProvider),
          const SizedBox(height: 10),
          buildTimeSetting(
              'long break', selectedLongTime, selectedLongTimeProvider),
          const Divider(
            height: 50,
          ),
          buildSectionTitle('FONT'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                // builds font options with the text and index
                List.generate(fonts.length, (index) {
              return buildFontOption('Aa', index);
            }),
          ),
          const Divider(
            height: 50,
          ),
          buildSectionTitle('COLOR'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                // builds color options with the color and index
                List.generate(colors.length, (index) {
              return buildColorOption(colors[index], index);
            }),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            // when the apply button is clicked, the settings are set and then
            // modal is closed
            onPressed: () {
              onApply(
                ref.read(selectedPomodoroTimeProvider),
                ref.read(selectedShortTimeProvider),
                ref.read(selectedLongTimeProvider),
                fonts[ref.read(selectedFontIndexProvider)],
                colors[ref.read(selectedColorIndexProvider)],
              );

              final isSelected = ref.read(isSelectedProvider);
              if (isSelected[0]) {
                ref.read(remainingTimeProvider.notifier).state =
                    ref.read(selectedPomodoroTimeProvider) * 60;
              } else if (isSelected[1]) {
                ref.read(remainingTimeProvider.notifier).state =
                    ref.read(selectedShortTimeProvider) * 60;
              } else if (isSelected[2]) {
                ref.read(remainingTimeProvider.notifier).state =
                    ref.read(selectedLongTimeProvider) * 60;
              }

              // Update the progress
              WidgetsBinding.instance.addPostFrameCallback((_) {
                updateProgress(ref, isSelected, remainingTime, pomodoroDuration,
                    shortBreakDuration, longBreakDuration);
              });

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors[0],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: Text(
                'Apply',
                style: GoogleFonts.kumbhSans(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
