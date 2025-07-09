class SubjectModel {
  String subject, teacher, room, note, category;
  final int? id;
  SubjectModel({
    required this.subject,
    this.id,
    required this.note,
    required this.room,
    required this.teacher,
    required this.category,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> json) {
    return SubjectModel(
      subject: json['subject'],
      note: json['note'],
      room: json['room'],
      teacher: json['teacher'],
      category: json['category'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'teacher': teacher,
      'room': room,
      'note': note,
      'category': category,
    };
  }
}
