import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';

import '../functions.dart';

class HomeworkModel {
  String subject, teacher, note, category, type;
  DateTime? notificationDateTime;
  DateTime pickedDateTime;
  bool isDone;
  final int? id;
  HomeworkModel(
      {required this.subject,
      required this.teacher,
      required this.note,
      required this.pickedDateTime,
      required this.isDone,
      required this.category,
      required this.type,
      this.id,
      this.notificationDateTime});
  factory HomeworkModel.fromMap(Map<String, dynamic> json) {
    DateTime dateTime =
        dateTimeFromString(dateTimeString: json['pickedDateTime']);
    var notification;
    if (json['notificationDateTime'] != '') {
      notification =
          dateTimeFromString(dateTimeString: json['notificationDateTime']);
    } else {
      notification = null;
    }
    bool isDone = json['isDone'] == 'true' ? true : false;

    return HomeworkModel(
      isDone: isDone,
      type: json['type'],
      category: json['category'],
      subject: json['subject'],
      teacher: json['teacher'],
      note: json['note'],
      pickedDateTime: dateTime,
      notificationDateTime: notification,
      id: json['id'],
    );
  }

  factory HomeworkModel.fromNeatCleanCalendarEvent(
      NeatCleanCalendarEvent calendarEvent) {
    List<String> data = calendarEvent.description.split('\n');
    String teacher = data[0];
    String note = data[1];
    String category = data[2];
    String type = data[3];
    int id = int.parse(data[data.length - 2]);
    var notification;
    if (data[data.length - 1] == '') {
      notification = null;
    } else {
      notification = dateTimeFromString(dateTimeString: data[data.length - 1]);
    }
    return HomeworkModel(
      category: category,
      type: type,
      isDone: calendarEvent.isDone,
      subject: calendarEvent.summary,
      teacher: teacher,
      note: note,
      pickedDateTime: calendarEvent.endTime,
      id: id,
      notificationDateTime: notification,
    );
  }
  Map<String, dynamic> toMap() {
    String notification;
    if (notificationDateTime == null) {
      notification = '';
    } else {
      notification =
          '${notificationDateTime!.year}-${notificationDateTime!.month}-${notificationDateTime!.day}-${notificationDateTime!.hour}-${notificationDateTime!.minute}';
    }
    String done = isDone ? 'true' : 'false';

    return {
      'type': type,
      'category': category,
      'isDone': done,
      'subject': subject,
      'teacher': teacher,
      'note': note,
      'pickedDateTime':
          "${pickedDateTime.year}-${pickedDateTime.month}-${pickedDateTime.day}-${pickedDateTime.hour}-${pickedDateTime.minute}",
      'notificationDateTime': notification,
    };
  }
}
