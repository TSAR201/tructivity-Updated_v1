import 'package:tructivity/constants.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/course-model.dart';
import 'package:tructivity/models/schedule-model.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/color-pick-field.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/dropdown-list.dart';
import 'package:tructivity/widgets/error-dialog.dart';
import 'package:tructivity/widgets/type-ahead-subject-field.dart';
import 'package:tructivity/widgets/type-ahead-teacher-field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class ScheduleDialog extends StatelessWidget {
  final ScheduleModel scheduleData;
  final String semester;
  final _formKey = GlobalKey<FormState>();
  final _teacherFieldKey = GlobalKey<TypeAheadTeacherFieldState>();
  final _roomFieldKey = GlobalKey<CustomTextFieldState>();
  final String table = 'schedule';
  ScheduleDialog({required this.scheduleData, required this.semester});
  final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Schedule'),
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TypeAheadSubjectField(
              validate: true,
              labelText: "Subject",
              category: semester,
              initialText: scheduleData.subject,
              fieldIcon: Icons.book_outlined,
              capitalizaton: TextCapitalization.words,
              onSuggestionSelected: (CourseModel course) {
                scheduleData.subject = course.subject;
                scheduleData.teacher = course.teacher;
                scheduleData.room = course.room;
                _teacherFieldKey.currentState!.controller.text =
                    scheduleData.teacher;
                _roomFieldKey.currentState!.controller.text = scheduleData.room;
              },
              onChanged: (String val) {
                scheduleData.subject = val;
              },
            ),
            TypeAheadTeacherField(
              key: _teacherFieldKey,
              validate: false,
              initialText: scheduleData.teacher,
              labelText: "Teacher",
              fieldIcon: Icons.person_outline_outlined,
              capitalizaton: TextCapitalization.words,
              onChanged: (String val) {
                scheduleData.teacher = val;
              },
            ),
            CustomTextField(
              key: _roomFieldKey,
              validate: false,
              labelText: "Room",
              initialText: scheduleData.room,
              fieldIcon: Icons.room_outlined,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                scheduleData.room = val;
              },
            ),
            CustomTextField(
              validate: false,
              labelText: "Note",
              initialText: scheduleData.note,
              fieldIcon: Icons.subject_outlined,
              capitalizaton: TextCapitalization.sentences,
              onChangedCallback: (val) {
                scheduleData.note = val;
              },
            ),
            CustomDateTimeField(
              icon: Icon(Icons.access_time_outlined),
              mode: DateTimeFieldPickerMode.time,
              selectedDate: scheduleData.start,
              dateSelectedCallback: (val) {
                scheduleData.start = val;
              },
            ),
            CustomDateTimeField(
              icon: Icon(Icons.access_time_outlined),
              mode: DateTimeFieldPickerMode.time,
              selectedDate: scheduleData.end,
              dateSelectedCallback: (val) {
                scheduleData.end = val;
              },
            ),
            ColorPickField(
              initialColor: scheduleData.color,
              onColorChanged: (val) {
                scheduleData.color = val;
              },
            ),
            DropdownList(
              label: 'Type',
              onChanged: (String val) {
                scheduleData.type = val;
              },
              options: scheduleTypes,
              icon: Icons.api_rounded,
              initialSelection: scheduleData.type,
            ),
          ],
        ),
      ),
      actions: [
        DeleteButton(
          onTapDelete: () async {
            if (scheduleData.id == null) {
              Navigator.pop(context);
            } else {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    ConfirmationDialog(text: confirmationText + ' subject?'),
              ).then((delete) async {
                if (delete != null) {
                  if (delete) {
                    await _db.remove(table: table, id: scheduleData.id!);
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
              if (scheduleData.end.isAfter(scheduleData.start)) {
                if (scheduleData.id == null) {
                  await _db.add(table: table, model: scheduleData);
                } else {
                  await _db.update(table: table, model: scheduleData);
                }

                Navigator.pop(context);
              } else {
                await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => ErrorDialog(
                        error: 'End time must be after the start time'));
              }
            }
          },
        ),
      ],
    );
  }
}
