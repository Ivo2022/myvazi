// // auth_utils.dart

// import 'package:flutter/material.dart';
// import 'package:myvazi/src/utils/retrieve_token.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> checkAutoLogin(BuildContext context) async {
//   String? token = await getToken();
//   if (token == null) {
//     // Token is not available, handle the case accordingly
//     // For example, navigate to the login screen
//     Navigator.pushReplacementNamed(context, '/home');
//     return;
//   }

//   // Token is available, send it to server for validation
//   //bool isValid = await validateToken(token);

//   if (isValid) {
//     // Token is valid, navigate to the home screen
//     Navigator.pushReplacementNamed(context, '/profile');
//   } else {
//     // For example, navigate to the login screen and remove the token from storage
//     Navigator.pushReplacementNamed(context, '/login');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//   }
// }
