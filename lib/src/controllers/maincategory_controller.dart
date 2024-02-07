import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/models/maincategory_model.dart';

String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
int sellerId = MainConstants.sellerId;

class MainCatController {
  Future<List<MainCategory>> fetchAllMainCategories() async {
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
        'Accept': "*/*",
        'connection': 'keep-alive',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      List mainCategoriesList = json.decode(response.body);
      List<MainCategory> mainCategories = [];
      for (int i = 0; i < mainCategoriesList.length; i++) {
        Map mainCatDetails = mainCategoriesList.elementAt(i);

        // Check if 'id' is not null before attempting to cast
        int? maincatID = mainCatDetails['main_category_id'] as int?;
        String maincatName = mainCatDetails['name'] as String;

        // Ensure that 'id' is not null before adding to the list
        if (maincatID != null) {
          MainCategory mainCategory =
              MainCategory(id: maincatID, name: maincatName);
          //print(mainCategory);

          mainCategories.add(mainCategory);
        }
      }

      return mainCategories;
    } else {
      throw Exception('Failed to load main categories');
    }
  }
}
