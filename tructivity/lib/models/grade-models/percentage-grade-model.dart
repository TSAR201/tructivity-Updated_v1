import 'package:tructivity/functions.dart';

class PercentageGradeModel {
  String grade, subject, category, note, weight;
  DateTime pickedDateTime;
  final String? id;
  PercentageGradeModel({
    required this.grade,
    required this.subject,
    required this.category,
    required this.note,
    required this.pickedDateTime,
    required this.weight,
    this.id,
  });
  factory PercentageGradeModel.fromMap(Map<String, dynamic> json, [String? docId]) {
    DateTime dateTime =
        dateTimeFromString(dateTimeString: json['pickedDateTime']);
    return PercentageGradeModel(
      grade: json['grade'],
      subject: json['subject'],
      id: docId ?? json['id'],
      category: json['category'],
      weight: json['weight'],
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
      'weight': weight,
    };
  }
}
