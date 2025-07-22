import 'package:tructivity/functions.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';

class EventModel {
  String subject, note, event, location, category;
  DateTime pickedDateTime;
  DateTime? notificationDateTime;
  bool isDone;

  final String? id;
  EventModel({
    required this.subject,
    required this.event,
    required this.location,
    required this.note,
    required this.pickedDateTime,
    required this.isDone,
    required this.category,
    this.id,
    this.notificationDateTime,
  });
  factory EventModel.fromMap(Map<String, dynamic> json, [String? docId]) {
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

    return EventModel(
      category: json['category'],
      isDone: isDone,
      subject: json['subject'],
      event: json['event'],
      location: json['location'],
      note: json['note'],
      pickedDateTime: dateTime,
      id: docId ?? json['id'],
      notificationDateTime: notification,
    );
  }
  factory EventModel.fromNeatCleanCalendarEvent(
      NeatCleanCalendarEvent calendarEvent) {
    List<String> data = calendarEvent.description.split('\n');
    String event = data[0];
    String note = data[1];
    String category = data[2];
    String id = data[3]; // Changed from int.parse to String
    var notification;
    if (data[data.length - 1] == '') {
      notification = null;
    } else {
      notification = dateTimeFromString(dateTimeString: data[data.length - 1]);
    }
    return EventModel(
      category: category,
      isDone: calendarEvent.isDone,
      subject: calendarEvent.summary,
      event: event,
      location: calendarEvent.location,
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
      'subject': subject,
      'event': event,
      'location': location,
      'note': note,
      'pickedDateTime':
          "${pickedDateTime.year}-${pickedDateTime.month}-${pickedDateTime.day}-${pickedDateTime.hour}-${pickedDateTime.minute}",
      'notificationDateTime': notification,
    };
  }
}
