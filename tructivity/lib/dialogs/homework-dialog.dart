import 'package:tructivity/constants.dart';
import 'package:tructivity/models/course-model.dart';
import 'package:tructivity/models/homework-model.dart';
import 'package:tructivity/notifications/notification-helper.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/category-picker.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/dropdown-list.dart';
import 'package:tructivity/widgets/type-ahead-subject-field.dart';
import 'package:tructivity/widgets/type-ahead-teacher-field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:intl/intl.dart';

import '../functions.dart';

class HomeworkDialog extends StatelessWidget {
  final HomeworkModel homeworkData;
  final _formKey = GlobalKey<FormState>();
  final _teacherFieldKey = GlobalKey<TypeAheadTeacherFieldState>();
  final String table = 'homework';
  final String semester;
  HomeworkDialog({required this.homeworkData, required this.semester});
  final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Homework'),
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TypeAheadSubjectField(
              validate: true,
              initialText: homeworkData.subject,
              labelText: "Subject",
              category: semester,
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
            CustomDateTimeField(
              dateFormat: DateFormat.yMMMd().add_jm(),
              icon: Icon(Icons.date_range_outlined),
              mode: DateTimeFieldPickerMode.dateAndTime,
              selectedDate: homeworkData.pickedDateTime,
              dateSelectedCallback: (val) {
                homeworkData.pickedDateTime = val;
              },
            ),
          ],
        ),
      ),
      actions: [
        DeleteButton(
          onTapDelete: () async {
            if (homeworkData.id == null) {
              Navigator.pop(context);
            } else {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    ConfirmationDialog(text: confirmationText + ' homework?'),
              ).then((delete) async {
                if (delete != null) {
                  if (delete) {
                    await _db.remove(table: table, id: homeworkData.id!);
                    if (homeworkData.notificationDateTime != null) {
                      cancelNotification(
                          id: generateId(
                              dataType: HomeworkModel, id: homeworkData.id!));
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
              if (homeworkData.id == null) {
                await _db.add(table: table, model: homeworkData);
              } else {
                await _db.update(table: table, model: homeworkData);
                if (homeworkData.notificationDateTime != null) {
                  await createNotification(
                    id: generateId(
                        dataType: HomeworkModel, id: homeworkData.id!),
                    title: getTitle(dataModel: homeworkData),
                    body: getBody(dataModel: homeworkData),
                    datetime: homeworkData.notificationDateTime!,
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
