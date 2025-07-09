import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/notifications/notification-helper.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:tructivity/widgets/error-dialog.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

import '../functions.dart';

class NotificationDialog extends StatelessWidget {
  final dataModel;
  final String table;
  final DatabaseHelper _db = DatabaseHelper.instance;
  NotificationDialog({required this.dataModel, required this.table});

  @override
  Widget build(BuildContext context) {
    if (dataModel.notificationDateTime == null) {
      dataModel.notificationDateTime = dataModel.pickedDateTime;
    }
    DateTime date = dataModel.notificationDateTime;
    DateTime time = dataModel.notificationDateTime;

    return AlertDialog(
      scrollable: true,
      title: Text('Reminder'),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDateTimeField(
            icon: Icon(Icons.date_range_outlined),
            mode: DateTimeFieldPickerMode.date,
            selectedDate: dataModel.notificationDateTime!,
            dateSelectedCallback: (val) {
              date = val;
            },
          ),
          CustomDateTimeField(
            icon: Icon(Icons.schedule_outlined),
            mode: DateTimeFieldPickerMode.time,
            selectedDate: dataModel.notificationDateTime!,
            dateSelectedCallback: (val) {
              time = val;
            },
          ),
        ],
      ),
      actions: [
        DeleteButton(
          onTapDelete: () async {
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => ConfirmationDialog(
                      text: 'Delete this reminder?',
                    )).then(
              (delete) async {
                if (delete) {
                  if (dataModel.notificationDateTime != null) {
                    dataModel.notificationDateTime = null;
                    await _db.update(
                        table: getTable(dataModel: dataModel),
                        model: dataModel);
                    await cancelNotification(
                        id: generateId(
                            dataType: dataModel.runtimeType, id: dataModel.id));
                    Navigator.pop(context);
                  }
                }
              },
            );
          },
        ),
        SaveButton(
          onTapSave: () async {
            DateTime notification = DateTime(
                date.year, date.month, date.day, time.hour, time.minute);
            dataModel.notificationDateTime = notification;
            if (dataModel.notificationDateTime.isAfter(DateTime.now())) {
              await _db.update(
                  table: getTable(dataModel: dataModel), model: dataModel);
              await createNotification(
                title: getTitle(dataModel: dataModel),
                body: getBody(dataModel: dataModel),
                id: generateId(
                    dataType: dataModel.runtimeType, id: dataModel.id),
                datetime: dataModel.notificationDateTime,
              );
              Navigator.pop(context);
            } else {
              await showDialog(
                context: context,
                builder: (context) {
                  return ErrorDialog(
                    error: 'Notification time should be after current time',
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
