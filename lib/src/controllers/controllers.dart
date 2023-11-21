import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myvazi/src/configs/constants.dart';
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
  if (response.body.isEmpty) {
    print('Server response is empty or null.');
    return null;
  } else {
    // Parse the JSON string into a Map<String, dynamic>
    Map<String, dynamic> jsonMap = json.decode(response.body);
    storeMap.value = jsonMap;
  }
  return null;
}

Future<List?> fetchMaincategories() async {
  try {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_maincategories_with_products.php'
        : 'http://localhost/twambale/api/get_maincategories_with_products.php';

    final Map<String, dynamic> requestData = {
      'action': 'getAllMainCategoriesWithProducts',
    };
//print(response.body);
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

      homeList.value = rawData;
      // print(homeList.value);
    } else {
      throw Exception('Failed to load subcategories');
    }
  } catch (error) {
    print('Error: $error');
    throw error;
  }
  return null;
}
