import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class AuthState with ChangeNotifier {
//   bool _isLoggedIn = false;

//   bool get isLoggedIn => _isLoggedIn;

//   void login() {
//     _isLoggedIn = true;
//     notifyListeners();
//   }

//   void logout() {
//     _isLoggedIn = false;
//     notifyListeners();
//   }
// }

class AuthState extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkAutoLogin() async {
    // Check if the user is already logged in
    // For example, by checking if a token exists in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    _isLoggedIn = token != null;
    notifyListeners();
  }

  Future<void> login(String token) async {
    // Perform login logic here
    // For example, validate credentials with the server and store the token in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    // Perform logout logic here
    // For example, remove the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }
}
