import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/set-notification-time-dialog.dart';
import 'package:tructivity/functions.dart';
import 'package:tructivity/models/course-model.dart';
import 'package:tructivity/models/homework-model.dart';
import 'package:tructivity/notifications/notification-helper.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/category-picker.dart';
import 'package:tructivity/widgets/day-selector-field.dart';
import 'package:tructivity/widgets/dropdown-list.dart';
import 'package:tructivity/widgets/type-ahead-subject-field.dart';
import 'package:tructivity/widgets/type-ahead-teacher-field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/constants.dart';
import 'package:intl/intl.dart';

final List<String> repetitionOptions = ['Once', 'Daily', 'Weekly', 'Monthly'];

class NewHomeworkDialog extends StatefulWidget {
  final HomeworkModel homeworkData;
  final String currentSemester;
  NewHomeworkDialog(
      {required this.homeworkData, required this.currentSemester});
  @override
  State<NewHomeworkDialog> createState() =>
      _NewHomeworkDialogState(homeworkData);
}

class _NewHomeworkDialogState extends State<NewHomeworkDialog> {
  final HomeworkModel homeworkData;
  _NewHomeworkDialogState(this.homeworkData);
  final _formKey = GlobalKey<FormState>();
  final _teacherFieldKey = GlobalKey<TypeAheadTeacherFieldState>();
  final String table = 'homework';
  final DatabaseHelper _db = DatabaseHelper.instance;
  String repetitionText = weekDays[1]!;
  String repeat = repetitionOptions[0];
  List<int> selectedDays = [1];
  DateTime start = DateTime.now();
  DateTime time = DateTime.now();
  DateTime end = DateTime.now().add(Duration(days: 1));
  DateTime notificationTime = DateTime.now();
  bool notificationTimeSet = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Homework'),
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TypeAheadSubjectField(
                validate: true,
                initialText: homeworkData.subject,
                labelText: "Subject",
                category: widget.currentSemester,
                fieldIcon: Icons.book_outlined,
                capitalizaton: TextCapitalization.words,
                onSuggestionSelected: (CourseModel course) {
                  homeworkData.subject = course.subject;
                  homeworkData.teacher = course.teacher;
                  _teacherFieldKey.currentState!.controller.text =
                      homeworkData.teacher;
                },
                onChanged: (String val) {
                  homeworkData.subject = val;
                },
              ),
              TypeAheadTeacherField(
                key: _teacherFieldKey,
                validate: false,
                initialText: homeworkData.teacher,
                labelText: "Teacher",
                fieldIcon: Icons.person_outline_outlined,
                capitalizaton: TextCapitalization.words,
                onChanged: (String val) {
                  homeworkData.teacher = val;
                },
              ),
              CustomTextField(
                validate: false,
                initialText: homeworkData.note,
                labelText: "Note",
                fieldIcon: Icons.subject_outlined,
                capitalizaton: TextCapitalization.sentences,
                onChangedCallback: (String val) {
                  homeworkData.note = val;
                },
              ),
              CategoryPicker(
                table: 'homeworkCategory',
                initialCategory: homeworkData.category,
                onCategoryChanged: (String category) {
                  if (category == 'All') {
                    category = '';
                  }
                  homeworkData.category = category;
                },
              ),
              DropdownList(
                label: 'Type',
                onChanged: (String val) {
                  homeworkData.type = val;
                },
                options: homeworkTypes,
                icon: Icons.api_rounded,
                initialSelection: homeworkData.type,
              ),
              repeat == 'Once'
                  ? CustomDateTimeField(
                      icon: Icon(Icons.date_range_outlined),
                      dateFormat: DateFormat.yMMMd().add_jm(),
                      mode: DateTimeFieldPickerMode.dateAndTime,
                      selectedDate: homeworkData.pickedDateTime,
                      dateSelectedCallback: (val) {
                        homeworkData.pickedDateTime = val;
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
          onTapSave: saveData,
        ),
      ],
    );
  }

  Future<void> saveData() async {
    if (_formKey.currentState!.validate()) {
      if (repeat == 'Once') {
        if (notificationTimeSet) {
          DateTime notificationDT = DateTime(
              homeworkData.pickedDateTime.year,
              homeworkData.pickedDateTime.month,
              homeworkData.pickedDateTime.day,
              notificationTime.hour,
              notificationTime.minute);
          if (notificationDT.isAfter(DateTime.now())) {
            homeworkData.notificationDateTime = notificationDT;
          } else {
            homeworkData.notificationDateTime = null;
          }
        }
        int id = await _db.add(table: table, model: homeworkData);
        if (homeworkData.notificationDateTime != null) {
          createNotification(
            id: generateId(dataType: HomeworkModel, id: id),
            title: getTitle(dataModel: homeworkData),
            body: getBody(dataModel: homeworkData),
            datetime: homeworkData.notificationDateTime!,
          );
        }
        Navigator.pop(context);
      } else if (end.isAfter(start)) {
        start = DateTime(start.year, start.month, start.day, time.hour,
            time.minute); //adding notification time to the start and end datetime objects

        end = DateTime(end.year, end.month, end.day, time.hour, time.minute);
        List<DateTime> days =
            getDaysInBetween(repeat, selectedDays, start, end);

        for (var day in days) {
          homeworkData.pickedDateTime = day;
          if (notificationTimeSet) {
            DateTime notificationDT = DateTime(day.year, day.month, day.day,
                notificationTime.hour, notificationTime.minute);
            if (notificationDT.isAfter(DateTime.now())) {
              homeworkData.notificationDateTime = notificationDT;
            } else {
              homeworkData.notificationDateTime = null;
            }
          }
          int id = await _db.add(table: table, model: homeworkData);
          if (homeworkData.notificationDateTime != null) {
            createNotification(
              id: generateId(dataType: HomeworkModel, id: id),
              title: getTitle(dataModel: homeworkData),
              body: getBody(dataModel: homeworkData),
              datetime: homeworkData.notificationDateTime!,
            );
          }
        }
        Navigator.pop(context);
      }
    }
  }
}
