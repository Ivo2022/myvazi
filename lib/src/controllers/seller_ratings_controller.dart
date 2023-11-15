// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:myvazi/src/models/seller_ratings_model.dart';
// import 'dart:io';

// Future<SellerRatingsModel?> fetchSupplierRatings() async {
//   String url = Platform.isAndroid
//       ? 'http://192.168.43.65/twambale/api/supplier_ratings.php'
//       : 'http://localhost/twambale/api/supplier_ratings.php';

//   final Map<String, dynamic> requestData = {
//     'action': 'getSupplierRatings',
//     'supplier_id': 86,
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
//     return SellerRatingsModel.fromJson(data);
//   } else {
//     throw Exception('Failed to load user');
//   }
// }
