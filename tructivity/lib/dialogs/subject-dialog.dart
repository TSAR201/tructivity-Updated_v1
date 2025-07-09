import 'package:tructivity/constants.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/subject-model.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/type-ahead-teacher-field.dart';
import 'package:flutter/material.dart';

class SubjectDialog extends StatelessWidget {
  final SubjectModel subjectData;
  final _formKey = GlobalKey<FormState>();
  final String table = 'subject';
  SubjectDialog({required this.subjectData});
  final DatabaseHelper _db = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Subject'),
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              validate: true,
              initialText: subjectData.subject,
              labelText: "Subject",
              fieldIcon: Icons.book_outlined,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                subjectData.subject = val;
              },
            ),
            TypeAheadTeacherField(
              validate: false,
              initialText: subjectData.teacher,
              labelText: "Teacher",
              fieldIcon: Icons.person_outline_outlined,
              capitalizaton: TextCapitalization.words,
              onChanged: (String val) {
                subjectData.teacher = val;
              },
            ),
            CustomTextField(
              validate: false,
              initialText: subjectData.room,
              labelText: "Room",
              fieldIcon: Icons.room_outlined,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                subjectData.room = val;
              },
            ),
            CustomTextField(
              validate: false,
              initialText: subjectData.note,
              labelText: "Note",
              fieldIcon: Icons.subject_outlined,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                subjectData.note = val;
              },
            ),
          ],
        ),
      ),
      actions: [
        DeleteButton(
          onTapDelete: () async {
            if (subjectData.id == null) {
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
                    await _db.remove(table: table, id: subjectData.id!);
                  }
                }
                Navigator.pop(context);
              });
            }
          },
        ),
        SaveButton(onTapSave: () async {
          if (_formKey.currentState!.validate()) {
            if (subjectData.id == null) {
              await _db.add(table: table, model: subjectData);
            } else {
              await _db.update(table: table, model: subjectData);
            }
            Navigator.pop(context);
          }
        }),
      ],
    );
  }
}
