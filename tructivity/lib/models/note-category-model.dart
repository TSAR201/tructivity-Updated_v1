class NoteCategoryModel {
  String category, description;
  final String? id;
  NoteCategoryModel(
      {required this.category, required this.description, this.id});
  factory NoteCategoryModel.fromMap(Map<String, dynamic> json, [String? docId]) {
    return NoteCategoryModel(
        category: json['category'],
        id: docId ?? json['id'],
        description: json['description']);
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
    };
  }
}
