import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:myvazi/main.dart';
import 'package:myvazi/routes.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/models/models.dart';
import 'package:myvazi/src/models/products_model.dart';
import 'package:myvazi/src/screens/frontpage.dart';
import 'package:myvazi/src/utils/order_response.dart';
import 'dart:io';
import 'package:myvazi/src/utils/response_message.dart';

String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
int sellerId = MainConstants.sellerId;
int userid = MainConstants.userId;
int activation = MainConstants.activation;
List<Map<String, dynamic>> sizesData = [];
String _action = "getAllMainCategoriesWithProducts";

class SizesService {
  static Future<List<Map<String, dynamic>>> fetchAllSizes() async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_all_sizes.php'
        : 'http://localhost/twambale/api/get_all_sizes.php';

    final Map<String, dynamic> requestData = {
      'action': 'getAllSizes',
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
      List<Map<String, dynamic>> sizes = [];

      List sizesList = json.decode(response.body);
      for (int i = 0; i < sizesList.length; i++) {
        Map sizedetails = sizesList.elementAt(i);
        String size = sizedetails.values.last;
        int sizeID = sizedetails.values.first;
        sizes.add({'name': size, 'size_id': sizeID});
      }

      setSizesData(sizes); // Save sizes data to sizes_data.dart

      return sizes;
    } else {
      throw Exception('Failed to load sizes');
    }
  }
}

Future<SellersModel?> fetchSellers() async {
  String url = Platform.isAndroid
      ? 'http://$ipAddress/twambale/api/get_user_data.php'
      : 'http://localhost/twambale/api/get_user_data.php';

  final Map<String, dynamic> requestData = {
    'action': 'getUserInfo',
    'seller_id': sellerId,
    'activation': activation
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
    return SellersModel.fromJson(data);
  } else {
    throw Exception('Failed to load user');
  }
}

Future<UsersModel?> fetchAllUsers() async {
  String url = Platform.isAndroid
      ? 'http://$ipAddress/twambale/api/get_user_data.php'
      : 'http://localhost/twambale/api/get_user_data.php';

  final Map<String, dynamic> requestData = {
    'action': 'getAllUserInfo',
    'userid': userid,
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
  //print(response.body);
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
        ? 'http://$ipAddress/twambale/api/get_maincategories_with_products.php?action=$_action'
        : 'http://localhost/twambale/api/get_maincategories_with_products.php?action=$_action';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> rawData = json.decode(response.body);

      // Assuming homeList is a ValueNotifier or similar, update its value
      homeList.value = rawData;
    } else {
      throw Exception('Failed to load subcategories');
    }
  } catch (error) {
    print('Error: $error');
    rethrow;
  }
  return null;
}

Future<List<dynamic>> fetchAllSizes() async {
  String url = Platform.isAndroid
      ? 'http://$ipAddress/twambale/api/get_all_sizes.php'
      : 'http://localhost/twambale/api/get_all_sizes.php';

  final Map<String, dynamic> requestData = {
    'action': 'getAllSizes',
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
    List<dynamic> sizes = [];

    List sizesList = json.decode(response.body);
    for (int i = 0; i < sizesList.length; i++) {
      Map sizedetails = sizesList.elementAt(i);
      String size = sizedetails.values.last;
      int sizeID = sizedetails.values.first;
      // setState(() {
      sizes.add({'name': size, 'size_id': sizeID});
      // });
    }

    return sizes;
  } else {
    throw Exception('Failed to load sizes');
  }
}

Future<List?> fetchCategories() async {
  try {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_maincategories_with_categories_products.php'
        : 'http://localhost/twambale/api/get_maincategories_with_categories_products.php';

    final Map<String, dynamic> requestData = {
      'action': 'getCategoriesWithProductsByID',
      'cat_prod_id': 1,
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

      // Assuming homeList is a ValueNotifier or similar, update its value
      drawerMenList.value = rawData;
    } else {
      throw Exception('Failed to load subcategories');
    }
  } catch (error) {
    print('Error: $error');
    throw error;
  }
  return null;
}

Future<List?> fetchAllMaincategories() async {
  try {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_maincategories_with_products.php'
        : 'http://localhost/twambale/api/get_maincategories_with_products.php';

    final Map<String, dynamic> requestData = {
      'action': 'getAllMainCategories',
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

      // Assuming homeList is a ValueNotifier or similar, update its value
      mainCategoryList.value = rawData;
    } else {
      throw Exception('Failed to load subcategories');
    }
  } catch (error) {
    print('Error: $error');
    throw error;
  }
  return null;
}

Future<List?> fetchMainSubcategories() async {
  try {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/post_product_details.php'
        : 'http://localhost/twambale/api/post_product_details.php';

    final Map<String, dynamic> requestData = {
      'action': 'getMainSubCategories',
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'connection': 'keep-alive',
      },
      body: jsonEncode(requestData),
    );
    //print(response.body);

    if (response.statusCode == 200) {
      List<dynamic> rawData = json.decode(response.body);

      uploadList.value = rawData;
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

Future<void> uploadImage(context, File imageFile) async {
  String url = Platform.isAndroid
      ? 'http://$ipAddress/twambale/api/upload.php'
      : 'http://localhost/twambale/api/upload.php';
  var request = http.MultipartRequest(
    'POST', Uri.parse(url), // Change to your PHP script URL
  );

  request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      await DialogUtils.showResponseMessage(context);
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
}

Future<void> pushDataToAPI(context, Products product,
    {bool sendFiles = true}) async {
  String url = Platform.isAndroid
      ? 'http://$ipAddress/twambale/api/uploads.php'
      : 'http://localhost/twambale/api/uploads.php';
  var apiUrl = Uri.parse(url);

  if (sendFiles) {
    // Handle sending files
    await uploadFiles(apiUrl, product.selectedImages);
  }

  // Handle sending other data
  await sendOtherData(
    context,
    apiUrl,
    product.productDescription,
    product.pickedMainCats,
    product.pickedCats,
    product.pickedSubCats,
    product.amount,
    product.quantity,
    product.purpose,
    product.pickedSizes,
    product.selectedImages,
    product.sellerName,
    product.activation,
  );
  // print('Submitting data to API: $product');
}

// void submitDataToAPI(
//     context,
//     String name,
//     List<dynamic>? selectedMainCategoryIds,
//     List<dynamic>? selectedCategoryIds,
//     List<dynamic>? selectedSubCategoryIds,
//     double amount,
//     int quantity,
//     String? purpose,
//     List<dynamic>? selectedSizeIds,
//     List<ImageFile>? selectedImages,
//     String sellerName,
//     int activation,
//     {bool sendFiles = true}) async {
//   String url = Platform.isAndroid
//       ? 'http://$ipAddress/twambale/api/uploads.php'
//       : 'http://localhost/twambale/api/uploads.php';
//   var apiUrl = Uri.parse(url);

//   if (sendFiles) {
//     // Handle sending files
//     await uploadFiles(apiUrl, selectedImages);
//   }

//   // Handle sending other data
//   await sendOtherData(
//       context,
//       apiUrl,
//       name,
//       selectedMainCategoryIds,
//       selectedCategoryIds,
//       selectedSubCategoryIds,
//       amount,
//       quantity,
//       purpose,
//       selectedSizeIds,
//       selectedImages,
//       sellerName,
//       activation);
// }

Future<void> uploadFiles(Uri apiUrl, List<ImageFile>? selectedImages) async {
  var request = http.MultipartRequest('POST', apiUrl);

  for (var image in selectedImages!) {
    // Add a timestamp to the file name before sending it
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.year}_${_padZero(now.month)}_${_padZero(now.day)}_${_padZero(now.hour)}_${_padZero(now.minute)}';

    // Append formatted date to the file name
    String fileNameWithTimestamp = '${formattedDate}_${image.name}';

    request.files.add(await http.MultipartFile.fromPath(
      'selected_images[]',
      File(image.path!).path,
      filename: fileNameWithTimestamp,
    ));
  }

  try {
    var response = await request.send();
    // var responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      // Files successfully submitted
      print('Files successfully uploaded');
    } else {
      // Handle error response
      print('Failed to upload files. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error sending request: $error');
  }
}

Future<void> sendOtherData(
    context,
    Uri apiUrl,
    String productDescription,
    List<dynamic>? pickedMainCats,
    List<dynamic>? pickedCats,
    List<dynamic>? pickedSubCats,
    double amount,
    int quantity,
    String purpose,
    List<dynamic>? pickedSizes,
    List<ImageFile>? selectedImages,
    String sellerName,
    int activation) async {
  List<dynamic> filenames = selectedImages!.map((image) {
    // Add a timestamp to the file name before sending it
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.year}_${_padZero(now.month)}_${_padZero(now.day)}_${_padZero(now.hour)}_${_padZero(now.minute)}';
    return '${formattedDate}_${image.name}';
  }).toList();

  String selectedImagesString = filenames.join(',');

  Map<String, dynamic> data = {
    'action': 'addProduct',
    'seller_name': sellerName,
    'activation': activation,
    'name': productDescription,
    'maincategory_ids': pickedMainCats ?? [],
    'category_ids': pickedCats ?? [],
    'subcategory_ids': pickedSubCats ?? [],
    'amount': amount,
    'quantity': quantity,
    'purpose': purpose,
    'size_ids': pickedSizes ?? [],
    'selected_images': selectedImagesString,
  };
  try {
    // Send a POST request to the API
    var response = await http.post(apiUrl, body: json.encode(data));
    // Check the status code of the response
    if (response.statusCode == 200) {
      // Show a SnackBar indicating success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product created successfully')),
      );
      Navigator.popUntil(context, ModalRoute.withName('/'));

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) =>
      //           const Routes()), // Replace with your next screen
      // );
    } else {
      // Show a SnackBar indicating failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to create product: ${response.statusCode}')),
      );
    }
  } catch (error) {
    print('Error: $error');
  }
}

String _padZero(int value) {
  return value.toString().padLeft(2, '0');
}

Future<void> submitBillInfoToAPI(
    context,
    String phoneNo,
    String location,
    String town,
    int price,
    int userId,
    String sizeName,
    int productId,
    int quantity,
    int totalAmount) async {
  String url = Platform.isAndroid
      ? 'http://$ipAddress/twambale/api/post_order_details.php'
      : 'http://localhost/twambale/api/post_order_details.php';

  // Replace 'YOUR_API_ENDPOINT' with the actual URL of your API endpoint
  var apiUrl = Uri.parse(url);

  // Prepare the data to be sent in the request body
  Map<String, dynamic> data = {
    'action': 'addOrderDetails',
    'phonenumber': phoneNo,
    'location': location,
    'town': town,
    'price': price.toString(),
    'user_id': userId.toString(),
    'size_id': sizeName,
    'product_id': productId.toString(),
    'quantity': quantity.toString(),
    'total_amount': totalAmount
    // Add more fields as needed
  };
  // Send a POST request to the API
  var response = await http.post(apiUrl, body: json.encode(data));
  // Check the status code of the response
  if (response.statusCode == 200) {
    // Data successfully submitted
    await OrderResponse.showResponseMessage(context);
  } else {
    // Something went wrong
    print('Failed to submit data. Status code: ${response.statusCode}');
  }
}
