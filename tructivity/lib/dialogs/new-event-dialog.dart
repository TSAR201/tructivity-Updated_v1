import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/set-notification-time-dialog.dart';
import 'package:tructivity/functions.dart';
import 'package:tructivity/models/course-model.dart';
import 'package:tructivity/models/event-model.dart';
import 'package:tructivity/notifications/notification-helper.dart';
import 'package:tructivity/widgets/buttons.dart';
import 'package:tructivity/widgets/custom-datetime-field.dart';
import 'package:tructivity/widgets/custom-textfield.dart';
import 'package:tructivity/widgets/category-picker.dart';
import 'package:tructivity/widgets/day-selector-field.dart';
import 'package:tructivity/widgets/dropdown-list.dart';
import 'package:tructivity/widgets/type-ahead-subject-field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/constants.dart';
import 'package:intl/intl.dart';

final List<String> repetitionOptions = ['Once', 'Daily', 'Weekly', 'Monthly'];

class NewEventDialog extends StatefulWidget {
  final EventModel eventData;
  final String semester;
  NewEventDialog({required this.eventData, required this.semester});
  @override
  State<NewEventDialog> createState() => _NewEventDialogState(eventData);
}

class _NewEventDialogState extends State<NewEventDialog> {
  final EventModel eventData;
  _NewEventDialogState(this.eventData);
  final _formKey = GlobalKey<FormState>();
  final String table = 'event';
  List<int> selectedDays = [1];
  String repetitionText = weekDays[1]!;
  final DatabaseHelper _db = DatabaseHelper.instance;
  String repeat = repetitionOptions[0];
  DateTime start = DateTime.now();
  DateTime time = DateTime.now();
  DateTime end = DateTime.now().add(Duration(days: 1));
  DateTime notificationTime = DateTime.now();
  bool notificationTimeSet = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Event'),
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                category: widget.semester,
                validate: false,
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
              repeat == 'Once'
                  ? CustomDateTimeField(
                      dateFormat: DateFormat.yMMMd().add_jm(),
                      icon: Icon(Icons.date_range_outlined),
                      mode: DateTimeFieldPickerMode.dateAndTime,
                      selectedDate: eventData.pickedDateTime,
                      dateSelectedCallback: (val) {
                        eventData.pickedDateTime = val;
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
              eventData.pickedDateTime.year,
              eventData.pickedDateTime.month,
              eventData.pickedDateTime.day,
              notificationTime.hour,
              notificationTime.minute);
          if (notificationDT.isAfter(DateTime.now())) {
            eventData.notificationDateTime = notificationDT;
          } else {
            eventData.notificationDateTime = null;
          }
        }
        int id = await _db.add(table: table, model: eventData);
        if (eventData.notificationDateTime != null) {
          createNotification(
            id: generateId(dataType: EventModel, id: id),
            title: getTitle(dataModel: eventData),
            body: getBody(dataModel: eventData),
            datetime: eventData.notificationDateTime!,
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
          eventData.pickedDateTime = day;
          if (notificationTimeSet) {
            DateTime notificationDT = DateTime(day.year, day.month, day.day,
                notificationTime.hour, notificationTime.minute);
            if (notificationDT.isAfter(DateTime.now())) {
              eventData.notificationDateTime = notificationDT;
            } else {
              eventData.notificationDateTime = null;
            }
          }
          int id = await _db.add(table: 'event', model: eventData);
          if (eventData.notificationDateTime != null) {
            createNotification(
              id: generateId(dataType: EventModel, id: id),
              title: getTitle(dataModel: eventData),
              body: getBody(dataModel: eventData),
              datetime: eventData.notificationDateTime!,
            );
          }
        }
        Navigator.pop(context);
      }
    }
  }
}
