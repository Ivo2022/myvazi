import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:http/http.dart' as http;

// class ProductViewProvider extends ChangeNotifier {
//   List<dynamic> _displayedProducts = [];
//   bool _isFirstLoadRunning = false;
//   final String _postCatUrl = MainConstants.baseUrl;
//   final String _postPhoneCatUrl = MainConstants.phoneUrl;
//   final String contentAction = "getProductsForSubCategory";
//   String emptyStateMessage = "No products found";
//   String emptyStateAction = "Explore other subcategories";
//   int _page = 1;
//   bool _isLoadMoreRunning = false;
//   bool noData = false;
//   List<dynamic> get displayedProducts => _displayedProducts;
//   bool get isFirstLoadRunning => _isFirstLoadRunning;

//   void setIsFirstLoadRunning(bool value) {
//     print('isFirstLoadRunning set to: $value');
//     _isFirstLoadRunning = value;
//     notifyListeners();
//   }

//   Future<void> fetchContentData(int subCatID) async {
//     print('fetchContentData called with subCatID: $subCatID');
//     if (_isFirstLoadRunning) {
//       print('fetchContentData: Already running, skipping...');
//       return;
//     }

//     setIsFirstLoadRunning(true);
//     print('fetchContentData: Fetching data...');

//     try {
//       String url = Platform.isAndroid
//           ? '$_postPhoneCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page'
//           : '$_postCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page';
//       print(url);
//       final res = await http.get(Uri.parse(url));
//       if (res.statusCode == 200) {
//         final List<dynamic> newData = json.decode(res.body);

//         if (newData.isNotEmpty) {
//           _displayedProducts = newData;
//           _page++;
//         } else {
//           displayEmptyState();
//         }
//       } else {
//         displayEmptyState();
//       }
//       notifyListeners();
//       print('fetchContentData: Data fetched successfully.');
//     } catch (error) {
//       rethrow;
//     } finally {
//       // Reset flag only when data fetching is successful
//       setIsFirstLoadRunning(false);
//       notifyListeners();
//       print('fetchContentData: Completed execution.');
//     }
//   }

//   Future<List> fetchMoreData(int subCatID, int page) async {
//     if (_isLoadMoreRunning) return [];

//     _isLoadMoreRunning = true;

//     try {
//       String url = Platform.isAndroid
//           ? '$_postPhoneCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page'
//           : '$_postCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page';
//       final res = await http.get(Uri.parse(url));
//       final List fetchedData = json.decode(res.body);

//       if (fetchedData.isNotEmpty && res.statusCode == 200) {
//         // Keep the existing data and simply add more data to it.
//         _displayedProducts.addAll(fetchedData);
//         _isLoadMoreRunning = false;
//         _page++;
//         notifyListeners();
//       } else {
//         noData = true;
//       }
//     } catch (error) {
//       _isLoadMoreRunning = false;
//       notifyListeners();
//       rethrow;
//     }
//     return _displayedProducts;
//   }

//   void displayEmptyState() {
//     // Handle the empty state logic here
//     // displayedProducts = []; // Example: Assign an empty list
//     emptyStateMessage = "No products found";
//     emptyStateAction = "Explore other subcategories";
//   }
// }

class ProductViewProvider extends ChangeNotifier {
  List<dynamic> _displayedProducts = [];
  bool _isFirstLoadRunning = false;
  final String _postCatUrl = MainConstants.baseUrl;
  final String _postPhoneCatUrl = MainConstants.phoneUrl;
  final String contentAction = "getProductsForSubCategory";
  String emptyStateMessage = "No products found";
  String emptyStateAction = "Explore other subcategories";
  int _page = 1;
  bool _isLoadMoreRunning = false;
  bool noData = false;

  List<dynamic> get displayedProducts => _displayedProducts;
  bool get isFirstLoadRunning => _isFirstLoadRunning;

  void setIsFirstLoadRunning(bool value) {
    print('isFirstLoadRunning set to: $value');
    _isFirstLoadRunning = value;
    notifyListeners();
  }

  Future<void> fetchContentData(int subCatID) async {
    print('fetchContentData called with subCatID: $subCatID');
    if (_isFirstLoadRunning) {
      print('fetchContentData: Already running, skipping...');
      return;
    }

    setIsFirstLoadRunning(true);
    print('fetchContentData: Fetching data...');

    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page'
          : '$_postCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page';
      print(url);
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final List<dynamic> newData = json.decode(res.body);

        if (newData.isNotEmpty) {
          _displayedProducts = newData;
          _page++;
        } else {
          displayEmptyState();
        }
      } else {
        displayEmptyState();
      }
      print('fetchContentData: Data fetched successfully.');
    } catch (error) {
      // Handle error...
      rethrow;
    } finally {
      // Reset flag only when data fetching is successful
      setIsFirstLoadRunning(false);
      notifyListeners();
      print('fetchContentData: Completed execution.');
    }
  }

  void displayEmptyState() {
    // Handle the empty state logic here
    // displayedProducts = []; // Example: Assign an empty list
    emptyStateMessage = "No products found";
    emptyStateAction = "Explore other subcategories";
  }
}
