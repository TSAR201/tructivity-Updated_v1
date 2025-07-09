import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/set-notification-time-dialog.dart';
import 'package:tructivity/functions.dart';
import 'package:tructivity/models/task-model.dart';
import 'package:tructivity/notifications/notification-helper.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/category-picker.dart';
import 'package:tructivity/widgets/day-selector-field.dart';
import 'package:tructivity/widgets/dropdown-list.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/constants.dart';
import 'package:intl/intl.dart';

final List<String> repetitionOptions = ['Once', 'Daily', 'Weekly', 'Monthly'];

class NewTaskDialog extends StatefulWidget {
  final TaskModel taskData;
  NewTaskDialog({required this.taskData});
  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState(taskData);
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  TaskModel taskData;
  _NewTaskDialogState(this.taskData);
  final _formKey = GlobalKey<FormState>();
  final String table = 'task';
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<int> selectedDays = [1];
  String repetitionText = weekDays[1]!;
  String repeat = repetitionOptions[0];
  DateTime start = DateTime.now();
  DateTime time = DateTime.now();
  DateTime end = DateTime.now().add(Duration(days: 1));
  DateTime notificationTime = DateTime.now();
  bool notificationTimeSet = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Task'),
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                    taskData.category = '';
                  }
                  taskData.category = category;
                },
              ),
              repeat == 'Once'
                  ? CustomDateTimeField(
                      icon: Icon(Icons.date_range_outlined),
                      mode: DateTimeFieldPickerMode.dateAndTime,
                      selectedDate: taskData.pickedDateTime,
                      dateFormat: DateFormat.yMMMd().add_jm(),
                      dateSelectedCallback: (val) {
                        taskData.pickedDateTime = val;
                      },
                    )
                  : CustomDateTimeField(
                      label: 'Time',
                      icon: Icon(Icons.schedule_outlined),
                      mode: DateTimeFieldPickerMode.time,
                      selectedDate: time,
                      dateSelectedCallback: (val) {
                        time = val;
                      },
                    ),
              repeat == 'Once'
                  ? SizedBox()
                  : CustomDateTimeField(
                      label: 'Start',
                      icon: Icon(Icons.date_range_outlined),
                      mode: DateTimeFieldPickerMode.date,
                      selectedDate: start,
                      dateSelectedCallback: (val) {
                        start = val;
                      },
                    ),
              repeat == 'Once'
                  ? SizedBox()
                  : CustomDateTimeField(
                      label: 'End',
                      icon: Icon(Icons.date_range_outlined),
                      mode: DateTimeFieldPickerMode.date,
                      selectedDate: end,
                      dateSelectedCallback: (val) {
                        end = val;
                      },
                    ),
              DropdownList(
                label: 'Repeat',
                onChanged: (String val) {
                  setState(() {
                    if (val == 'Weekly') {
                      selectedDays = [1];
                      repetitionText = weekDays[1]!;
                    } else if (val == 'Monthly') {
                      selectedDays = [1];
                      repetitionText = '1';
                    }
                    repeat = val;
                  });
                },
                options: repetitionOptions,
                icon: Icons.repeat_outlined,
                initialSelection: repeat,
              ),
              repeat == 'Daily' || repeat == 'Once'
                  ? SizedBox()
                  : DaySelectorField(
                      repetitionText: repetitionText,
                      repeat: repeat,
                      selectedDays: selectedDays,
                      onChanged: (List<int> days) {
                        var data = onSelectedDaysChanged(repeat, days);
                        selectedDays = data['days'];
                        repetitionText = data['text'];
                        setState(() {});
                      },
                    ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notification_add_outlined,
              color: notificationTimeSet ? Colors.teal : null),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    SetNotificationTimeDialog(initalTime: notificationTime),
              ).then((selectedTime) {
                if (selectedTime == null) {
                  notificationTimeSet = false;
                } else {
                  notificationTime = selectedTime;
                  notificationTimeSet = true;
                }
                setState(() {});
              });
            }
          },
        ),
        DeleteButton(
          onTapDelete: () {
            Navigator.pop(context);
          },
        ),
        SaveButton(
          onTapSave: saveTasks,
        ),
      ],
    );
  }

  Future<void> saveTasks() async {
    if (_formKey.currentState!.validate()) {
      if (repeat == 'Once') {
        if (notificationTimeSet) {
          DateTime notificationDT = DateTime(
              taskData.pickedDateTime.year,
              taskData.pickedDateTime.month,
              taskData.pickedDateTime.day,
              notificationTime.hour,
              notificationTime.minute);
          if (notificationDT.isAfter(DateTime.now())) {
            taskData.notificationDateTime = notificationDT;
          } else {
            taskData.notificationDateTime = null;
          }
        }
        int id = await _db.add(table: table, model: taskData);
        if (taskData.notificationDateTime != null) {
          createNotification(
            id: generateId(dataType: TaskModel, id: id),
            title: getTitle(dataModel: taskData),
            body: getBody(dataModel: taskData),
            datetime: taskData.notificationDateTime!,
          );
        }
        Navigator.pop(context);
      } else if (end.isAfter(start)) {
        start = DateTime(start.year, start.month, start.day, time.hour,
            time.minute); //adding time to the start and end datetime objects

        end = DateTime(end.year, end.month, end.day, time.hour, time.minute);
        List<DateTime> days =
            getDaysInBetween(repeat, selectedDays, start, end);

        for (var day in days) {
          taskData.pickedDateTime = day;
          if (notificationTimeSet) {
            DateTime notificationDT = DateTime(day.year, day.month, day.day,
                notificationTime.hour, notificationTime.minute);
            if (notificationDT.isAfter(DateTime.now())) {
              taskData.notificationDateTime = notificationDT;
            } else {
              taskData.notificationDateTime = null;
            }
          }
          int id = await _db.add(table: table, model: taskData);
          if (taskData.notificationDateTime != null) {
            createNotification(
              id: generateId(dataType: TaskModel, id: id),
              title: getTitle(dataModel: taskData),
              body: getBody(dataModel: taskData),
              datetime: taskData.notificationDateTime!,
            );
          }
        }
        Navigator.pop(context);
      }
    }
  }
}
