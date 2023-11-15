// import 'package:flutter/material.dart';
// import 'package:myvazi/src/models/users_model.dart';
// import 'package:myvazi/src/models/seller_ratings_model.dart';
// import 'package:myvazi/src/controllers/users_controller.dart';
// import 'package:myvazi/src/controllers/seller_ratings_controller.dart';

// class UserDataProvider extends ChangeNotifier {
//   UsersModel? users;

//   Future<void> fetchUsersData() async {
//     try {
//       users = await fetchUser(); // Fetch a single UsersModel
//       if (users != null) {
//         notifyListeners();
//       } else {
//         print('No user data available.');
//       }
//     } catch (e) {
//       // Handle any errors here
//       print('Error fetching user data: $e');
//     }
//   }
// }

// class SellerRatingsProvider extends ChangeNotifier {
//   SellerRatingsModel? sellerRatings;

//   Future<void> fetchSellerRatingsData() async {
//     try {
//       sellerRatings =
//           await fetchSupplierRatings(); // Fetch a single SellersModel
//       if (sellerRatings != null) {
//         notifyListeners();
//       } else {
//         print('No sellerRatings data available.');
//       }
//     } catch (e) {
//       // Handle any errors here
//       print('Error fetching sellerRatings data: $e');
//     }
//   }
// }
