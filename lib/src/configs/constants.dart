import 'package:flutter/material.dart';

ValueNotifier<Map> storeMap = ValueNotifier({});
ValueNotifier<List> homeList = ValueNotifier([]);
ValueNotifier<List> drawerMenList = ValueNotifier([]);
ValueNotifier<List> uploadList = ValueNotifier([]);
ValueNotifier<List> drawerCatList = ValueNotifier([]);
ValueNotifier<List> mainCategoryList = ValueNotifier([]);
ValueNotifier<List> sizesList = ValueNotifier([]);
ValueNotifier<List> displayedProducts = ValueNotifier([]);
ValueNotifier<int> userID = ValueNotifier<int>(0);
ValueNotifier<int> sellerID = ValueNotifier<int>(0);
ValueNotifier<int> activate = ValueNotifier<int>(0);

class ServerConfig {
  static const String ipAddress = "192.168.43.65";
  static const bool isLocal = false; // Set this to true for local environment

  static String get baseUrl {
    return isLocal
        ? 'http://$ipAddress'
        : 'https://2ambale.com/android/version_2401/api';
  }

  static String get phoneUrl {
    return isLocal
        ? 'http://twambale'
        : 'https://2ambale.com/android/version_2401/api';
  }

  static String get uploads {
    return isLocal
        ? '/twambale/assets/images/uploads/'
        : 'https://2ambale.com/product_images/';
  }

  static String get profileImages {
    return isLocal
        ? '/twambale/assets/images/uploads/'
        : 'https://2ambale.com/android/user_profile_pics/';
  }

  static String get defaultImage {
    return isLocal
        ? 'assets/images/default_image.png'
        : 'https://2ambale.com/product_images/default_image.png';
  }

  static String get defaultImageSquare {
    return isLocal
        ? 'assets/images/default_image_square.png'
        : 'https://2ambale.com/product_images/default_image.png';
  }

  static String get defaultProductImage {
    return isLocal
        ? 'assets/images/default_image.png'
        : 'https://2ambale.com/product_images/default_image.png';
  }

  static String get defaultProfileImage {
    return isLocal
        ? 'assets/images/default_image.png'
        : 'https://2ambale.com/android/user_profile_pics/no_image.png';
  }
}

class MainConstants {
  static const int userId = 152;
  static const int sellerId = 152;
  static const int activation = 1;
  static const String ipAddress = "192.168.43.65";
  static const bool isLocal = false; // Set this to true for local environment

  // static int userId = 152;
  // static int sellerId = 152;
  // static int activation = 1;
  // static String ipAddress = "192.168.43.65";
  // static bool isLocal = false; // Set this to true for local environment
  // static String sellerName = "Victory Online Shop";

  static String get baseUrl {
    return isLocal
        ? 'http://localhost/twambale/api'
        : 'https://2ambale.com/android/version_2401/api';
  }

  static String get phoneUrl {
    return isLocal
        ? 'http://$ipAddress/twambale/api'
        : 'https://2ambale.com/android/version_2401/api';
  }

  static const String sellerName = "Victory Online Shop";
}
