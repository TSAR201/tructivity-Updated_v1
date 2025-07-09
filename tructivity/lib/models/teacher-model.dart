class TeacherModel {
  String name, phone, email, website, officeHours, address;
  final int? id;
  TeacherModel(
      {required this.name,
      required this.phone,
      required this.email,
      required this.address,
      this.id,
      required this.officeHours,
      required this.website});
  factory TeacherModel.fromMap(Map<String, dynamic> json) {
    return TeacherModel(
      address: json['address'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      id: json['id'],
      officeHours: json['officeHours'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'name': name,
      'phone': phone,
      'email': email,
      'website': website,
      'officeHours': officeHours,
    };
  }
}
