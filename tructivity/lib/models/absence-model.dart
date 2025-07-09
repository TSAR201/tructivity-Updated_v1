class AbsenceModel {
  String subject, teacher, room, category, note;
  DateTime pickedDateTime;
  final int? id;
  AbsenceModel({
    required this.subject,
    required this.teacher,
    required this.pickedDateTime,
    required this.room,
    required this.category,
    required this.note,
    this.id,
  });
  factory AbsenceModel.fromMap(Map<String, dynamic> json) {
    List data = json['pickedDateTime'].split('-');
    var year = int.parse(data[0]);
    var month = int.parse(data[1]);
    var day = int.parse(data[2]);
    var hour = int.parse(data[3]);
    var minute = int.parse(data[4]);
    DateTime dateTime = DateTime(year, month, day, hour, minute);

    return AbsenceModel(
        note: json['note'],
        category: json['category'],
        subject: json['subject'],
        teacher: json['teacher'],
        room: json['room'],
        pickedDateTime: dateTime,
        id: json['id']);
  }
  Map<String, dynamic> toMap() {
    return {
      'note': note,
      'category': category,
      'subject': subject,
      'teacher': teacher,
      'room': room,
      'pickedDateTime':
          "${pickedDateTime.year}-${pickedDateTime.month}-${pickedDateTime.day}-${pickedDateTime.hour}-${pickedDateTime.minute}",
    };
  }
}
