import 'package:tructivity/functions.dart';

class HSGradeModel {
  String grade, subject, category, note, credit, course;
  DateTime pickedDateTime;
  final int? id;
  HSGradeModel({
    required this.grade,
    required this.subject,
    required this.category,
    required this.note,
    required this.pickedDateTime,
    required this.credit,
    required this.course,
    this.id,
  });
  factory HSGradeModel.fromMap(Map<String, dynamic> json) {
    DateTime dateTime =
        dateTimeFromString(dateTimeString: json['pickedDateTime']);
    return HSGradeModel(
      grade: json['grade'],
      subject: json['subject'],
      id: json['id'],
      category: json['category'],
      credit: json['credit'],
      note: json['note'],
      course: json['course'],
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
      'credit': credit,
      'course': course,
    };
  }
}
