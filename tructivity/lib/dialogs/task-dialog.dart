import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/task-model.dart';
import 'package:tructivity/notifications/notification-helper.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/category-picker.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../functions.dart';

class TaskDialog extends StatelessWidget {
  final TaskModel taskData;
  final String table = 'task';
  final _formKey = GlobalKey<FormState>();
  TaskDialog({required this.taskData});
  final DatabaseHelper _db = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Task'),
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              validate: true,
              initialText: taskData.task,
              labelText: "Task",
              fieldIcon: Icons.task_outlined,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                taskData.task = val;
              },
            ),
            CustomTextField(
              validate: false,
              initialText: taskData.note,
              labelText: "Note",
              fieldIcon: Icons.subject_outlined,
              capitalizaton: TextCapitalization.sentences,
              onChangedCallback: (val) {
                taskData.note = val;
              },
            ),
            CategoryPicker(
              table: 'taskCategory',
              initialCategory: taskData.category,
              onCategoryChanged: (String category) {
                if (category == 'All') {
                  category = '';
                }
                taskData.category = category;
              },
            ),
            CustomDateTimeField(
              icon: Icon(Icons.date_range_outlined),
              mode: DateTimeFieldPickerMode.dateAndTime,
              selectedDate: taskData.pickedDateTime,
              dateFormat: DateFormat.yMMMd().add_jm(),
              dateSelectedCallback: (val) {
                taskData.pickedDateTime = val;
              },
            ),
          ],
        ),
      ),
      actions: [
        DeleteButton(
          onTapDelete: () async {
            if (taskData.id == null) {
              Navigator.pop(context);
            } else {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    ConfirmationDialog(text: confirmationText + ' task?'),
              ).then((delete) async {
                if (delete != null) {
                  if (delete) {
                    await _db.remove(table: table, id: taskData.id!);
                    if (taskData.notificationDateTime != null) {
                      cancelNotification(
                          id: generateId(
                              dataType: TaskModel, id: taskData.id!));
                    }
                  }
                }
                Navigator.pop(context);
              });
            }
          },
        ),
        SaveButton(
          onTapSave: () async {
            if (_formKey.currentState!.validate()) {
              if (taskData.id == null) {
                await _db.add(table: table, model: taskData);
              } else {
                await _db.update(table: table, model: taskData);
                if (taskData.notificationDateTime != null) {
                  await createNotification(
                    id: generateId(dataType: TaskModel, id: taskData.id!),
                    title: getTitle(dataModel: taskData),
                    body: getBody(dataModel: taskData),
                    datetime: taskData.notificationDateTime!,
                  );
                }
              }
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
