import 'package:tructivity/functions.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';

class TaskModel {
  String task, note, category;
  bool isDone;
  DateTime pickedDateTime;
  DateTime? notificationDateTime;
  final String? id;

  TaskModel({
    required this.task,
    required this.note,
    required this.pickedDateTime,
    required this.isDone,
    required this.category,
    this.id,
    this.notificationDateTime,
  });
  factory TaskModel.fromMap(Map<String, dynamic> json, [String? docId]) {
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

    return TaskModel(
      category: json['category'],
      isDone: isDone,
      task: json['task'],
      note: json['note'],
      pickedDateTime: dateTime,
      notificationDateTime: notification,
      id: docId ?? json['id'],
    );
  }
  factory TaskModel.fromNeatCleanCalendarEvent(
      NeatCleanCalendarEvent calendarEvent) {
    List<String> data = calendarEvent.description.split('\n');
    String note = data[0];
    String category = data[1];
    String id = data[2]; // Changed from int.parse to String
    var notification;
    if (data[data.length - 1] == '') {
      notification = null;
    } else {
      notification = dateTimeFromString(dateTimeString: data[data.length - 1]);
    }
    return TaskModel(
      category: category,
      isDone: calendarEvent.isDone,
      task: calendarEvent.summary,
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
      'category': category,
      'isDone': done,
      'task': task,
      'note': note,
      'pickedDateTime':
          '${pickedDateTime.year}-${pickedDateTime.month}-${pickedDateTime.day}-${pickedDateTime.hour}-${pickedDateTime.minute}',
      'notificationDateTime': notification,
    };
  }
}
