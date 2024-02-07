import 'package:flutter/material.dart';

ValueNotifier<Map> storeMap = ValueNotifier({});
ValueNotifier<List> homeList = ValueNotifier([]);
ValueNotifier<List> drawerMenList = ValueNotifier([]);
ValueNotifier<List> uploadList = ValueNotifier([]);
ValueNotifier<List> drawerCatList = ValueNotifier([]);
ValueNotifier<List> mainCategoryList = ValueNotifier([]);
ValueNotifier<List> sizesList = ValueNotifier([]);
ValueNotifier<List> displayedProducts = ValueNotifier([]);

class ServerConfig {
  static const String ipAddress = "192.168.43.65";
  static const String baseUrl = 'http://$ipAddress';
  static const String phoneUrl = 'http://twambale';
  static const String uploads = '/twambale/assets/images/uploads/';
  static const String defaultImage = 'assets/images/default_image.png';
  static const String defaultImageSquare =
      'assets/images/default_image_square.png';
}

class MainConstants {
  static const int userId = 152;
  static const int sellerId = 152;
  static const int activation = 1;
  static const String ipAddress = "192.168.43.65";
  static const String sellerName = "Victory Online Shop";
  static const String baseUrl = 'http://localhost/twambale/api';
  static const String phoneUrl = 'http://$ipAddress/twambale/api';
}
