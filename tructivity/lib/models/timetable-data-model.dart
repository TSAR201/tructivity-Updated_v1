import 'package:flutter/material.dart';

class TimetableDataModel {
  final int? id;
  Color color;
  String subject, teacher, room, note;
  DateTime start, end;
  TimetableDataModel({
    required this.color,
    required this.subject,
    required this.teacher,
    required this.room,
    required this.note,
    required this.start,
    required this.end,
    this.id,
  });
  factory TimetableDataModel.fromMap(Map<String, dynamic> json) {
    List data1 = json['start'].split('-');
    List data2 = json['end'].split('-');
    var year = int.parse(data1[0]);
    var month = int.parse(data1[1]);
    var day = int.parse(data1[2]);
    var startHour = int.parse(data1[3]);
    var startMinute = int.parse(data1[4]);
    var endHour = int.parse(data2[3]);
    var endMinute = int.parse(data2[4]);
    DateTime startTime = DateTime(year, month, day, startHour, startMinute);
    DateTime endTime = DateTime(year, month, day, endHour, endMinute);
    return TimetableDataModel(
        subject: json['subject'],
        teacher: json['teacher'],
        note: json['note'],
        id: json['id'],
        color: Color(int.parse(json['color'])),
        room: json['room'],
        start: startTime,
        end: endTime);
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'teacher': teacher,
      'note': note,
      'room': room,
      'color': color.value.toString(),
      'start':
          "${start.year}-${start.month}-${start.day}-${start.hour}-${start.minute}",
      'end': "${end.year}-${end.month}-${end.day}-${end.hour}-${end.minute}",
    };
  }
}
