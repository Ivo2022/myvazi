import 'package:flutter/material.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/models/models.dart';

// import 'package:myvazi/src/controllers/users_controller.dart';
// import 'package:myvazi/src/models/users_model.dart';

class UserDataProvider extends ChangeNotifier {
  UsersModel? users;

  Future<void> fetchUsersData() async {
    try {
      users = await fetchUser(); // Fetch a single UsersModel
      if (users != null) {
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
