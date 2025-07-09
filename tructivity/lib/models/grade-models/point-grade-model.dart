import 'package:tructivity/functions.dart';

class PointGradeModel {
  String grade, subject, category, note, maxPoints;
  DateTime pickedDateTime;
  final int? id;
  PointGradeModel({
    required this.grade,
    required this.subject,
    required this.category,
    required this.note,
    required this.pickedDateTime,
    required this.maxPoints,
    this.id,
  });
  factory PointGradeModel.fromMap(Map<String, dynamic> json) {
    DateTime dateTime =
        dateTimeFromString(dateTimeString: json['pickedDateTime']);
    return PointGradeModel(
      grade: json['grade'],
      subject: json['subject'],
      id: json['id'],
      category: json['category'],
      maxPoints: json['maxPoints'],
      note: json['note'],
      pickedDateTime: dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'grade': grade,
      'subject': subject,
      'category': category,
      'pickedDateTime':
          "${pickedDateTime.year}-${pickedDateTime.month}-${pickedDateTime.day}-${pickedDateTime.hour}-${pickedDateTime.minute}",
      'note': note,
      'maxPoints': maxPoints,
    };
  }
}
