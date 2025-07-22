class CategoryModel {
  String category;
  final String? id;
  CategoryModel({required this.category, this.id});
  factory CategoryModel.fromMap(Map<String, dynamic> json, [String? docId]) {
    return CategoryModel(
      category: json['category'],
      id: docId ?? json['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
    };
  }
}
