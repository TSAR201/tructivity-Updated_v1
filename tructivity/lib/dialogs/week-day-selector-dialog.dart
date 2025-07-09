import 'package:tructivity/widgets/week-day-checkbox.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/buttons.dart';

class WeekDaySelectorDialog extends StatelessWidget {
  final List<int> selectedDays;
  WeekDaySelectorDialog({required this.selectedDays});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: weekDays.keys
            .map(
              (key) => WeekDayCheckBox(
                title: weekDays[key]!,
                initialValue: selectedDays.contains(key),
                onChanged: (bool checked) {
                  if (checked) {
                    selectedDays.add(key);
                  } else {
                    selectedDays.remove(key);
                  }
                },
              ),
            )
            .toList(),
      ),
      actions: [
        SaveButton(onTapSave: () {
          Navigator.pop(context, selectedDays);
        })
      ],
    );
  }
}
