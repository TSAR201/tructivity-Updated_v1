class NoteCategoryModel {
  String category, description;
  final int? id;
  NoteCategoryModel(
      {required this.category, required this.description, this.id});
  factory NoteCategoryModel.fromMap(Map<String, dynamic> json) {
    return NoteCategoryModel(
        category: json['category'],
        id: json['id'],
        description: json['description']);
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
    };
  }
}
