// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:myvazi/src/models/users_model.dart';
// import 'dart:io';

// Future<UsersModel?> fetchUser() async {
//   String url = Platform.isAndroid
//       ? 'http://192.168.43.65/twambale/api/user_data.php'
//       : 'http://localhost/twambale/api/user_data.php';

//   final Map<String, dynamic> requestData = {
//     'action': 'GetUserInfo',
//     'seller_id': 152,
//     'activation': 1
//   };

//   final response = await http.post(
//     Uri.parse(url),
//     headers: {
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Accept': "*/*",
//       'connection': 'keep-alive',
//     },
//     body: jsonEncode(requestData),
//   );

//   if (response.statusCode == 200) {
//     final Map<String, dynamic> data = json.decode(response.body);
//     return UsersModel.fromJson(data);
//   } else {
//     throw Exception('Failed to load user');
//   }
// }
