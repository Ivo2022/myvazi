class ProductDetails {
  final List<dynamic> products;
  final Map<String, dynamic> subcategories;

  ProductDetails({required this.products, required this.subcategories});
}

class SubcategoryModel {
  final int subcategoryId;
  final String name;

  SubcategoryModel({required this.subcategoryId, required this.name});

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      subcategoryId: json['subcategory_id'],
      name: json['name'],
    );
  }
}
