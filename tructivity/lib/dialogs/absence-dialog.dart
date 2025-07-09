import 'package:tructivity/constants.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/absence-model.dart';
import 'package:tructivity/models/course-model.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/type-ahead-subject-field.dart';
import 'package:tructivity/widgets/type-ahead-teacher-field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class AbsenceDialog extends StatelessWidget {
  final AbsenceModel absenceData;
  final _formKey = GlobalKey<FormState>();
  final _teacherFieldKey = GlobalKey<TypeAheadTeacherFieldState>();
  final _roomFieldKey = GlobalKey<CustomTextFieldState>();
  final String category;

  final String table = 'absence';
  AbsenceDialog({required this.absenceData, required this.category});
  final DatabaseHelper _db = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Absence'),
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TypeAheadSubjectField(
              validate: true,
              initialText: absenceData.subject,
              labelText: "Subject",
              fieldIcon: Icons.book_outlined,
              capitalizaton: TextCapitalization.words,
              category: category,
              onChanged: (String val) {
                absenceData.subject = val;
              },
              onSuggestionSelected: (CourseModel course) {
                absenceData.subject = course.subject;
                absenceData.teacher = course.teacher;
                absenceData.room = course.room;
                _teacherFieldKey.currentState!.controller.text =
                    absenceData.teacher;
                _roomFieldKey.currentState!.controller.text = absenceData.room;
              },
            ),
            TypeAheadTeacherField(
              key: _teacherFieldKey,
              validate: false,
              initialText: absenceData.teacher,
              labelText: "Teacher",
              fieldIcon: Icons.person_outline_outlined,
              capitalizaton: TextCapitalization.words,
              onChanged: (String val) {
                absenceData.teacher = val;
              },
            ),
            CustomTextField(
              key: _roomFieldKey,
              validate: false,
              initialText: absenceData.room,
              labelText: "Room",
              fieldIcon: Icons.room_outlined,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                absenceData.room = val;
              },
            ),
            CustomTextField(
              validate: false,
              initialText: absenceData.note,
              labelText: "Note",
              fieldIcon: Icons.subject_outlined,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                absenceData.note = val;
              },
            ),
            CustomDateTimeField(
                selectedDate: absenceData.pickedDateTime,
                icon: Icon(Icons.date_range_outlined),
                mode: DateTimeFieldPickerMode.date,
                dateSelectedCallback: (val) {
                  absenceData.pickedDateTime = val;
                }),
          ],
        ),
      ),
      actions: [
        DeleteButton(
          onTapDelete: () async {
            if (absenceData.id == null) {
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    ConfirmationDialog(text: confirmationText + ' absence?'),
              ).then((delete) async {
                if (delete != null) {
                  if (delete) {
                    await _db.remove(table: table, id: absenceData.id!);
                  }
                }
                Navigator.pop(context);
              });
            }
          },
        ),
        SaveButton(onTapSave: () async {
          if (_formKey.currentState!.validate()) {
            if (absenceData.id == null) {
              await _db.add(table: table, model: absenceData);
            } else {
              await _db.update(table: table, model: absenceData);
            }
            Navigator.pop(context);
          }
        }),
      ],
    );
  }
}
