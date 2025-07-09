import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class SetNotificationTimeDialog extends StatelessWidget {
  final DateTime initalTime;
  SetNotificationTimeDialog({required this.initalTime});

  @override
  Widget build(BuildContext context) {
    DateTime notificationTime = initalTime;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Text('Reminder'),
      content: CustomDateTimeField(
        dateSelectedCallback: (DateTime selectedDate) {
          notificationTime = selectedDate;
        },
        selectedDate: initalTime,
        mode: DateTimeFieldPickerMode.time,
        icon: Icon(Icons.date_range_outlined),
      ),
      actions: [
        DeleteButton(onTapDelete: () {
          Navigator.pop(context, null);
        }),
        SaveButton(onTapSave: () async {
          Navigator.pop(context, notificationTime);
        }),
      ],
    );
  }
}
