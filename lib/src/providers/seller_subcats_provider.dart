import 'package:flutter/material.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/models/models.dart';

class SellerSubcatsProvider extends ChangeNotifier {
  List<SubcategoryModel> _subcategories = [];
  List<Product> _products = [];

  List<SubcategoryModel> get subcategories => _subcategories;
  List<Product> get products => _products;

  fetchSubcategoriesData() async {
    try {
      // Assuming parseSubcategories returns List<dynamic>
      List<SubcategoryModel> rawSubcategories =
          (await parseSubcategories())!.cast<SubcategoryModel>();

      notifyListeners();
    } catch (e) {
      // Handle any errors here
      //print('Error fetching subcategories data: $e');
    }
  }
}
