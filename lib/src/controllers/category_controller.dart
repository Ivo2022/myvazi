import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/models/category_model.dart';
import 'package:myvazi/src/models/maincategory_model.dart';

String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
//int sellerId = MainConstants.sellerId;
int sellerId = sellerID.value;

class CatController {
// Future<void> fetchCategories(dynamic mainCategory) async {
//   String url = Platform.isAndroid
//       ? 'http://$ipAddress/twambale/api/get_categories.php'
//       : 'http://localhost/twambale/api/get_categories.php';

//   final Map<String, String> headers = {
//     'Content-Type': 'application/json; charset=UTF-8',
//     'Accept': 'application/json',
//     // Add any additional headers if needed
//   };
//   final Map<String, dynamic> requestData = {
//     'action': 'getAllCategories',
//     'maincat': mainCategory
//   };

//   final response = await http.post(
//     Uri.parse(url),
//     headers: headers,
//     body: jsonEncode(requestData),
//   );

//   try {
//     if (response.statusCode == 200) {
//       dynamic decodedResponse = json.decode(response.body);
//       if (decodedResponse is List) {
//         // If it's a list, iterate through it
//         List categoriesList = decodedResponse;
//         for (int i = 0; i < categoriesList.length; i++) {
//           Map catDetails = categoriesList.elementAt(i);
//           String cat = catDetails.values.elementAt(0);
//           setState(() {
//             categories.add(cat);
//           });
//         }
//       } else if (decodedResponse is String) {
//         // If it's a single value, add it directly to the categories list
//         setState(() {
//           categories.add(decodedResponse);
//         });
//       } else {
//         // Handle other types if necessary
//         print('Unexpected response type: ${decodedResponse.runtimeType}');
//       }
//     } else {
//       print(
//           'Failed to load main categories. HTTP Status Code: ${response.statusCode}');
//       print('Error Response: ${response.body}');
//       // You might want to handle this error more gracefully, depending on your use case.
//       // For now, we throw an exception.
//       throw Exception('Failed to load main categories');
//     }
//   } catch (e) {
//     print('Exception: $e');
//     // Handle other exceptions if needed.
//   }
// }

  Future<List<Category>> fetchCategories(dynamic mainCategory) async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_categories.php'
        : 'http://localhost/twambale/api/get_categories.php';

    final Map<String, dynamic> requestData = {
      'action': 'getAllCategories',
      'maincat': mainCategory
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      List categoriesList = json.decode(response.body);
      List<Category> categories = [];
      for (int i = 0; i < categoriesList.length; i++) {
        Map catDetails = categoriesList.elementAt(i);

        // Check if 'id' is not null before attempting to cast
        int? catID = catDetails['main_category_id'] as int?;
        String catName = catDetails['name'] as String;

        // Ensure that 'id' is not null before adding to the list
        if (catID != null) {
          Category category = Category(id: catID, name: catName);
          print(category);

          categories.add(category);
        }
      }

      return categories;
    } else {
      throw Exception('Failed to load main categories');
    }
  }
}
