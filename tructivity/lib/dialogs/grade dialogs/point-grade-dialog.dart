import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/course-model.dart';
import 'package:tructivity/models/grade-models/point-grade-model.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/type-ahead-subject-field.dart';
import 'package:tructivity/constants.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PointGradeDialog extends StatelessWidget {
  final PointGradeModel gradeData;
  final _formKey = GlobalKey<FormState>();
  final String table = 'pointGrade';
  final String category;
  PointGradeDialog({required this.gradeData, required this.category});
  final DatabaseHelper _db = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Point Based Grade'),
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TypeAheadSubjectField(
              validate: true,
              initialText: gradeData.subject,
              labelText: "Subject",
              fieldIcon: Icons.book_outlined,
              category: category,
              capitalizaton: TextCapitalization.words,
              onSuggestionSelected: (CourseModel course) {
                gradeData.subject = course.subject;
              },
              onChanged: (String val) {
                gradeData.subject = val;
              },
            ),
            CustomTextField(
              validate: true,
              type: TextInputType.number,
              formatter: FilteringTextInputFormatter.allow(expression),
              initialText: gradeData.grade,
              labelText: "Grade",
              fieldIcon: Icons.grade_outlined,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                gradeData.grade = val;
              },
            ),
            CustomTextField(
              validate: true,
              initialText: gradeData.maxPoints,
              formatter: FilteringTextInputFormatter.allow(expression),
              labelText: "Max Points",
              type: TextInputType.number,
              fieldIcon: Icons.exposure,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                gradeData.maxPoints = val;
              },
            ),
            CustomTextField(
              validate: false,
              initialText: gradeData.note,
              labelText: "Note",
              fieldIcon: Icons.subject_outlined,
              capitalizaton: TextCapitalization.sentences,
              onChangedCallback: (val) {
                gradeData.note = val;
              },
            ),
            CustomDateTimeField(
              icon: Icon(Icons.date_range_outlined),
              mode: DateTimeFieldPickerMode.date,
              selectedDate: gradeData.pickedDateTime,
              dateSelectedCallback: (val) {
                gradeData.pickedDateTime = val;
              },
            ),
          ],
        ),
      ),
      actions: [
        DeleteButton(
          onTapDelete: () async {
            if (gradeData.id == null) {
              Navigator.pop(context);
            } else {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    ConfirmationDialog(text: confirmationText + ' grade?'),
              ).then((delete) async {
                if (delete != null) {
                  if (delete) {
                    await _db.remove(table: table, id: gradeData.id!);
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
              //print(gradeData.category);

              if (gradeData.id == null) {
                await _db.add(table: table, model: gradeData);
              } else {
                await _db.update(table: table, model: gradeData);
              }
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
