import 'package:tructivity/constants.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/teacher-model.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:flutter/material.dart';

class TeacherDialog extends StatelessWidget {
  final TeacherModel teacherData;
  TeacherDialog({required this.teacherData});
  final String table = 'teacher';
  final DatabaseHelper _db = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Teacher'),
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                validate: true,
                initialText: teacherData.name,
                labelText: "Name",
                fieldIcon: Icons.person_outlined,
                capitalizaton: TextCapitalization.words,
                onChangedCallback: (val) {
                  teacherData.name = val;
                },
              ),
              CustomTextField(
                validate: false,
                initialText: teacherData.phone,
                type: TextInputType.phone,
                labelText: "Phone",
                fieldIcon: Icons.phone_outlined,
                capitalizaton: TextCapitalization.none,
                onChangedCallback: (val) {
                  teacherData.phone = val;
                },
              ),
              CustomTextField(
                validate: false,
                initialText: teacherData.email,
                type: TextInputType.emailAddress,
                labelText: "Email",
                fieldIcon: Icons.email_outlined,
                capitalizaton: TextCapitalization.none,
                onChangedCallback: (val) {
                  teacherData.email = val;
                },
              ),
              CustomTextField(
                validate: false,
                initialText: teacherData.address,
                labelText: "Address",
                fieldIcon: Icons.room_outlined,
                capitalizaton: TextCapitalization.words,
                onChangedCallback: (val) {
                  teacherData.address = val;
                },
              ),
              CustomTextField(
                validate: false,
                initialText: teacherData.officeHours,
                labelText: "Office Hours",
                fieldIcon: Icons.access_time_outlined,
                capitalizaton: TextCapitalization.sentences,
                onChangedCallback: (val) {
                  teacherData.officeHours = val;
                },
              ),
              CustomTextField(
                validate: false,
                initialText: teacherData.website,
                labelText: "Website",
                fieldIcon: Icons.desktop_windows_outlined,
                capitalizaton: TextCapitalization.none,
                onChangedCallback: (val) {
                  teacherData.website = val;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        DeleteButton(
          onTapDelete: () async {
            if (teacherData.id == null) {
              Navigator.pop(context);
            } else {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    ConfirmationDialog(text: confirmationText + ' contact?'),
              ).then((delete) async {
                if (delete != null) {
                  if (delete) {
                    await _db.remove(table: table, id: teacherData.id!);
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
              if (teacherData.id == null) {
                await _db.add(table: table, model: teacherData);
              } else {
                await _db.update(table: table, model: teacherData);
              }
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
