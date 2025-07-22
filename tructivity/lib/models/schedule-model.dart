import 'package:tructivity/functions.dart';
import 'package:flutter/material.dart';

class ScheduleModel {
  final String? id;
  Color color;
  String subject, teacher, room, note, type;
  DateTime start, end;
  ScheduleModel({
    required this.color,
    required this.subject,
    required this.teacher,
    required this.room,
    required this.note,
    required this.start,
    required this.end,
    required this.type,
    this.id,
  });
  factory ScheduleModel.fromMap(Map<String, dynamic> json, [String? docId]) {
    String start = json['start'];
    String end = json['end'];
    DateTime startTime = dateTimeFromString(dateTimeString: start);
    DateTime endTime = dateTimeFromString(dateTimeString: end);
    return ScheduleModel(
      type: json['type'],
      subject: json['subject'],
      teacher: json['teacher'],
      note: json['note'],
      id: docId ?? json['id'],
      color: Color(int.parse(json['color'])),
      room: json['room'],
      start: startTime,
      end: endTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'teacher': teacher,
      'note': note,
      'type': type,
      'room': room,
      'color': color.value.toString(),
      'start':
          "${start.year}-${start.month}-${start.day}-${start.hour}-${start.minute}",
      'end': "${end.year}-${end.month}-${end.day}-${end.hour}-${end.minute}",
    };
  }
}
