import 'package:tructivity/functions.dart';

class CollegeGradeModel {
  String grade, subject, category, note, credit;
  DateTime pickedDateTime;
  final String? id;
  CollegeGradeModel({
    required this.grade,
    required this.subject,
    required this.category,
    required this.note,
    required this.pickedDateTime,
    required this.credit,
    this.id,
  });
  factory CollegeGradeModel.fromMap(Map<String, dynamic> json, [String? docId]) {
    DateTime dateTime =
        dateTimeFromString(dateTimeString: json['pickedDateTime']);
    return CollegeGradeModel(
      grade: json['grade'],
      subject: json['subject'],
      id: docId ?? json['id'],
      category: json['category'],
      credit: json['credit'],
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
      'credit': credit,
    };
  }
}
