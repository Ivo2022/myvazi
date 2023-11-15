import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myvazi/src/models/models.dart';
import 'dart:io';

String ipAddress = "192.168.43.65";
int sellerId = 152;

Future<UsersModel?> fetchUser() async {
  String url = Platform.isAndroid
      ? 'http://$ipAddress/twambale/api/get_user_data.php'
      : 'http://localhost/twambale/api/get_user_data.php';

  final Map<String, dynamic> requestData = {
    'action': 'GetUserInfo',
    'seller_id': sellerId,
    'activation': 1
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
    final Map<String, dynamic> data = json.decode(response.body);
    return UsersModel.fromJson(data);
  } else {
    throw Exception('Failed to load user');
  }
}

Future<SellerRatingsModel?> fetchSupplierRatings() async {
  String url = Platform.isAndroid
      ? 'http://$ipAddress/twambale/api/get_supplier_ratings.php'
      : 'http://localhost/twambale/api/get_supplier_ratings.php';

  final Map<String, dynamic> requestData = {
    'action': 'getSupplierRatings',
    'seller_id': sellerId,
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
    final Map<String, dynamic> data = json.decode(response.body);
    return SellerRatingsModel.fromJson(data);
  } else {
    throw Exception('Failed to load supplier ratings');
  }
}

// Future<List<SubcategoriesModel>> fetchSubcategories() async {
//   try {
//     // Make the HTTP request
//     String url = Platform.isAndroid
//         ? 'http://$ipAddress/twambale/api/get_sellers_subcategories.php'
//         : 'http://localhost/twambale/api/get_sellers_subcategories.php';

//     final Map<String, dynamic> requestData = {
//       'action': 'getSellerSubCats',
//       'seller_id': sellerId,
//     };

//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Accept': "*/*",
//         'connection': 'keep-alive',
//       },
//       body: jsonEncode(requestData),
//     );
//     print(response.body);

//     if (response.statusCode == 200) {
//       // Parse the JSON response
//       List<Map<String, dynamic>> data = json.decode(response.body);
//       //print('Raw Response: ${response.headers}\n${response.body}');

//       // Create a list of Subcategory objects
//       List<SubcategoriesModel> subcategories = [];

//       for (var entry in data) {
//         String subcategoryName = entry['subcategoryName'];
//         List<int> productIDs = entry['productID']
//             .split(',')
//             .map((id) => int.parse(id.trim()))
//             .toList();

//         print('API Response: $data');
//         print('Subcategory: $subcategoryName, Product IDs: $productIDs');

//         // Create a SubcategoriesModel instance and add it to the list
//         SubcategoriesModel subcategory = SubcategoriesModel(
//           subcategoryId: 0,
//           subcategoryName: subcategoryName,
//           productIDs: productIDs,
//         );

//         subcategories.add(subcategory);
//       }

//       return subcategories;
//     } else {
//       // Handle errors
//       print('Failed to load data: ${response.statusCode}');
//       return [];
//     }
//   } catch (error) {
//     // Handle exceptions
//     print('Error: $error');
//     return [];
//   }
// }

Future<List<Product>?> parseSubcategories() async {
  String url = Platform.isAndroid
      ? 'http://$ipAddress/twambale/api/get_sellers_subcategories.php'
      : 'http://localhost/twambale/api/get_sellers_subcategories.php';

  final Map<String, dynamic> requestData = {
    'action': 'getSellerSubCats',
    'seller_id': sellerId,
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

  //print('Raw Server Response: ${response.body}');

  if (response.body.isEmpty) {
    print('Server response is empty or null.');

    return null;
  }

  // Parse the JSON string into a Map<String, dynamic>
  Map<String, dynamic> jsonMap = json.decode(response.body);

  // Convert each entry into a SubcategoryModel
  List<SubcategoryModel> subcategories = jsonMap.entries.map((entry) {
    return SubcategoryModel.fromJson(entry.value);
  }).toList();

// Print the results
  subcategories.forEach((subcategory) {
    print('SubcategoryId: ${subcategory.subcategoryId}');
    print('SubcategoryName: ${subcategory.subcategoryName}');
    print('ProductIDs: ${subcategory.productIDs}');

    // Iterate through products and print details
    subcategory.products.forEach((product) {
      print('Product ID: ${product.productId}');
      print('Product Name: ${product.name}');
      print('Product Sizes: ${product.productSizes}');
      print('Product Images: ${product.productImages}');
      print('---');
    });

    print('---');
  });
  return null;
}

/*
Future<List<SubcategoriesModel>?> fetchSubcategories() async {
  try {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_sellers_subcategories.php'
        : 'http://localhost/twambale/api/get_sellers_subcategories.php';

    final Map<String, dynamic> requestData = {
      'action': 'getSellerSubCats',
      'seller_id': sellerId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'connection': 'keep-alive',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      List<dynamic> rawData = json.decode(response.body);
      List<SubcategoriesModel> subcategoriesList =
          rawData.map((subcat) => SubcategoriesModel.fromJson(subcat)).toList();
      return subcategoriesList;
    } else {
      throw Exception('Failed to load subcategories');
    }
  } catch (error) {
    print('Error: $error');
    throw error;
  }
  return null;
}

*/