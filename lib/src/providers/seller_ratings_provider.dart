import 'package:flutter/material.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/models/models.dart';

class SellerRatingsProvider extends ChangeNotifier {
  SellerRatingsModel? sellerRatings;

  Future<void> fetchSellerRatingsData() async {
    try {
      sellerRatings =
          await fetchSupplierRatings(); // Fetch a single SellersModel
      if (sellerRatings != null) {
        notifyListeners();
      } else {
        print('No sellerRatings data available.');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching sellerRatings data: $e');
    }
  }
}
