import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/models/category_model.dart';
import 'package:myvazi/src/models/maincategory_model.dart';
import 'package:myvazi/src/models/subcategory_model.dart';

String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
//int sellerId = MainConstants.sellerId;
int sellerId = sellerID.value;

class SubCatController {
  Future<List<SubCategory>> fetchSubCategories(dynamic category) async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_subcategories_with_products.php'
        : 'http://localhost/twambale/api/get_subcategories_with_products.php';

    final Map<String, dynamic> requestData = {
      'action': 'getAllSubCategories',
      'category': category
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
      List subcategoriesList = json.decode(response.body);
      List<SubCategory> subcategories = [];
      for (int i = 0; i < subcategoriesList.length; i++) {
        Map subcatDetails = subcategoriesList.elementAt(i);

        // Check if 'id' is not null before attempting to cast
        int? subcatID = subcatDetails['main_category_id'] as int?;
        String subcatName = subcatDetails['name'] as String;

        // Ensure that 'id' is not null before adding to the list
        if (subcatID != null) {
          SubCategory subcategory = SubCategory(id: subcatID, name: subcatName);
          //print(subcategory);

          subcategories.add(subcategory);
        }
      }

      return subcategories;
    } else {
      throw Exception('Failed to load main categories');
    }
  }
}
