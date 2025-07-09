class CategoryModel {
  String category;
  final int? id;
  CategoryModel({required this.category, this.id});
  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['category'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
    };
  }
}
