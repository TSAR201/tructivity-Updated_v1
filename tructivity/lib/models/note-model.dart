import 'package:flutter/material.dart';

class NoteModel {
  String title, description, category;
  int? id;
  Color color;
  DateTime pickedDateTime;
  NoteModel({
    required this.title,
    required this.description,
    this.id,
    required this.pickedDateTime,
    required this.color,
    required this.category,
  });
  factory NoteModel.fromMap(Map<String, dynamic> json) {
    List data = json['pickedDateTime'].split('-');
    int year = int.parse(data[0]);
    int month = int.parse(data[1]);
    int day = int.parse(data[2]);
    int hour = int.parse(data[3]);
    int minute = int.parse(data[4]);
    DateTime dateTime = DateTime(year, month, day, hour, minute);

    return NoteModel(
      color: Color(int.parse(json['color'])),
      title: json['title'],
      description: json['description'],
      pickedDateTime: dateTime,
      id: json['id'],
      category: json['category'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'color': color.value.toString(),
      'title': title,
      'description': description,
      'pickedDateTime':
          "${pickedDateTime.year}-${pickedDateTime.month}-${pickedDateTime.day}-${pickedDateTime.hour}-${pickedDateTime.minute}",
      'category': category,
    };
  }
}
