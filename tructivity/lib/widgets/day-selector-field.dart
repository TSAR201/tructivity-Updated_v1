import 'package:tructivity/dialogs/month-day-selector-dialog.dart';
import 'package:tructivity/dialogs/week-day-selector-dialog.dart';
import 'package:flutter/material.dart';

class DaySelectorField extends StatelessWidget {
  final String repetitionText, repeat;
  final List<int> selectedDays;
  final Function(List<int>) onChanged;
  DaySelectorField({
    required this.repetitionText,
    required this.onChanged,
    required this.repeat,
    required this.selectedDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: ListTile(
        title: Text('Selected Days'),
        subtitle: Text(repetitionText),
        leading: Icon(Icons.repeat),
        onTap: () async {
          await showDialog(
              context: context,
              builder: (context) {
                if (repeat == 'Weekly') {
                  return WeekDaySelectorDialog(selectedDays: selectedDays);
                } else {
                  return MonthDaySelectorDialog(selectedDays: selectedDays);
                }
              }).then(
            (days) {
              if (days != null) {
                onChanged(days);
              }
            },
          );
        },
      ),
    );
  }
}
