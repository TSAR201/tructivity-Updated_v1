import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/course-model.dart';
import 'package:tructivity/models/event-model.dart';
import 'package:tructivity/notifications/notification-helper.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/category-picker.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/type-ahead-subject-field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../functions.dart';

class EventDialog extends StatelessWidget {
  final EventModel eventData;
  final String semester;
  final _formKey = GlobalKey<FormState>();
  final String table = 'event';
  EventDialog({required this.eventData, required this.semester});

  final DatabaseHelper _db = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Event'),
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              validate: false,
              initialText: eventData.event,
              labelText: "Event",
              fieldIcon: Icons.event_outlined,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                eventData.event = val;
              },
            ),
            TypeAheadSubjectField(
              validate: false,
              category: semester,
              initialText: eventData.subject,
              labelText: "Subject",
              fieldIcon: Icons.book_outlined,
              capitalizaton: TextCapitalization.words,
              onChanged: (String val) {
                eventData.subject = val;
              },
              onSuggestionSelected: (CourseModel course) {
                eventData.subject = course.subject;
              },
            ),
            CustomTextField(
              validate: false,
              initialText: eventData.location,
              labelText: "Location",
              fieldIcon: Icons.room_outlined,
              capitalizaton: TextCapitalization.words,
              onChangedCallback: (val) {
                eventData.location = val;
              },
            ),
            CustomTextField(
              validate: false,
              initialText: eventData.note,
              labelText: "Note",
              fieldIcon: Icons.subject_outlined,
              capitalizaton: TextCapitalization.sentences,
              onChangedCallback: (val) {
                eventData.note = val;
              },
            ),
            CategoryPicker(
              table: 'eventCategory',
              initialCategory: eventData.category,
              onCategoryChanged: (String category) {
                if (category == 'All') {
                  category = '';
                }
                eventData.category = category;
              },
            ),
            CustomDateTimeField(
              dateFormat: DateFormat.yMMMd().add_jm(),
              selectedDate: eventData.pickedDateTime,
              icon: Icon(Icons.date_range_outlined),
              mode: DateTimeFieldPickerMode.dateAndTime,
              dateSelectedCallback: (val) {
                eventData.pickedDateTime = val;
              },
            ),
          ],
        ),
      ),
      actions: [
        DeleteButton(
          onTapDelete: () async {
            if (eventData.id == null) {
              Navigator.pop(context);
            } else {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    ConfirmationDialog(text: confirmationText + ' event?'),
              ).then((delete) async {
                if (delete != null) {
                  if (delete) {
                    await _db.remove(table: table, id: eventData.id!);
                    if (eventData.notificationDateTime != null) {
                      cancelNotification(
                          id: generateId(
                              dataType: EventModel, id: eventData.id!));
                    }
                  }
                }
                Navigator.pop(context);
              });
            }
          },
        ),
        SaveButton(onTapSave: () async {
          if (_formKey.currentState!.validate()) {
            if (eventData.id == null) {
              await _db.add(table: table, model: eventData);
            } else {
              await _db.update(table: table, model: eventData);
              if (eventData.notificationDateTime != null) {
                await createNotification(
                  id: generateId(dataType: EventModel, id: eventData.id!),
                  title: getTitle(dataModel: eventData),
                  body: getBody(dataModel: eventData),
                  datetime: eventData.notificationDateTime!,
                );
              }
            }
            Navigator.pop(context);
          }
        }),
      ],
    );
  }
}
