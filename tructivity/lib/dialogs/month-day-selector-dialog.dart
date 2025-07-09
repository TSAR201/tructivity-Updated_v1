import 'package:tructivity/widgets/month-day-checkbox.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/buttons.dart';

class MonthDaySelectorDialog extends StatelessWidget {
  final List<int> selectedDays;
  MonthDaySelectorDialog({required this.selectedDays});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 600,
        child: GridView.count(
          crossAxisCount: 5,
          shrinkWrap: true,
          children: monthDays
              .map(
                (day) => MonthDayCheckBox(
                  title: '$day',
                  initialValue: selectedDays.contains(day),
                  onChanged: (bool checked) {
                    if (checked) {
                      selectedDays.add(day);
                    } else {
                      selectedDays.remove(day);
                    }
                  },
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        SaveButton(onTapSave: () {
          Navigator.pop(context, selectedDays);
        })
      ],
    );
  }
}
