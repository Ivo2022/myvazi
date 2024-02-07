class MainCategory {
  final int id;
  final String name;

  MainCategory({required this.id, required this.name});

  factory MainCategory.fromJson(Map<String, dynamic> json) {
    return MainCategory(id: json['main_category_id'], name: json['name']);
  }

  // Convert MainCategory to a Map
  Map<String, dynamic> toJson() {
    return {
      'main_category_id': id,
      'name': name,
    };
  }
}
