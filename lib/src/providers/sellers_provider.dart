import 'package:flutter/material.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/models/models.dart';

// import 'package:myvazi/src/controllers/users_controller.dart';
// import 'package:myvazi/src/models/users_model.dart';

class SellerDataProvider extends ChangeNotifier {
  SellersModel? sellers;

  Future<void> fetchSellersData() async {
    try {
      sellers = await fetchSellers(); // Fetch a single UsersModel
      if (sellers != null) {
        notifyListeners();
      } else {
        print('No user data available.');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching user data: $e');
    }
  }
}
