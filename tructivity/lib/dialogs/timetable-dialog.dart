import 'package:tructivity/constants.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/course-model.dart';
import 'package:tructivity/models/timetable-data-model.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/color-pick-field.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/type-ahead-subject-field.dart';
import 'package:tructivity/widgets/type-ahead-teacher-field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class TimetableDialog extends StatelessWidget {
  final TimetableDataModel timetableData;
  final String table = 'timetable';
  final String semester;
  TimetableDialog({required this.timetableData, required this.semester});
  final DatabaseHelper _db = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  final _teacherFieldKey = GlobalKey<TypeAheadTeacherFieldState>();
  final _roomFieldKey = GlobalKey<CustomTextFieldState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Timetable'),
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
              initialText: timetableData.subject,
              fieldIcon: Icons.book_outlined,
              capitalizaton: TextCapitalization.words,
              onSuggestionSelected: (CourseModel course) {
                timetableData.subject = course.subject;
                timetableData.teacher = course.teacher;
                timetableData.room = course.room;
                _teacherFieldKey.currentState!.controller.text =
                    timetableData.teacher;
                _roomFieldKey.currentState!.controller.text =
                    timetableData.room;
              },
              onChanged: (String val) {
                timetableData.subject = val;
              },
            ),
            TypeAheadTeacherField(
              key: _teacherFieldKey,
              validate: false,
              initialText: timetableData.teacher,
              labelText: "Teacher",
              fieldIcon: Icons.person_outline_outlined,
              capitalizaton: TextCapitalization.words,
              onChanged: (String val) {
                timetableData.teacher = val;
              },
            ),
            CustomTextField(
              key: _roomFieldKey,
              validate: false,
              labelText: "Room",
              initialText: timetableData.room,
              fieldIcon: Icons.room_outlined,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                timetableData.room = val;
              },
            ),
            CustomTextField(
              validate: false,
              labelText: "Note",
              initialText: timetableData.note,
              fieldIcon: Icons.subject_outlined,
              capitalizaton: TextCapitalization.sentences,
              onChangedCallback: (val) {
                timetableData.note = val;
              },
            ),
            CustomDateTimeField(
              icon: Icon(Icons.access_time_outlined),
              mode: DateTimeFieldPickerMode.time,
              selectedDate: timetableData.start,
              dateSelectedCallback: (val) {
                timetableData.start = val;
              },
            ),
            CustomDateTimeField(
              icon: Icon(Icons.access_time_outlined),
              mode: DateTimeFieldPickerMode.time,
              selectedDate: timetableData.end,
              dateSelectedCallback: (val) {
                timetableData.end = val;
              },
            ),
            ColorPickField(
              initialColor: timetableData.color,
              onColorChanged: (val) {
                timetableData.color = val;
              },
            )
          ],
        ),
      ),
      actions: [
        DeleteButton(
          onTapDelete: () async {
            if (timetableData.id == null) {
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
                    await _db.remove(table: table, id: timetableData.id!);
                  }
                }
                Navigator.pop(context);
              });
            }
          },
        ),
        SaveButton(
          onTapSave: () async {
            if (_formKey.currentState!.validate() &&
                timetableData.end.isAfter(timetableData.start)) {
              if (timetableData.id == null) {
                await _db.add(table: table, model: timetableData);
              } else {
                await _db.update(table: table, model: timetableData);
              }
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
