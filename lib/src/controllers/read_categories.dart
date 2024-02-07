import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:myvazi/src/models/orders_model.dart';

Future<List<Map<String, dynamic>>> fetchData() async {
  String url = Platform.isAndroid
      ? 'http://192.168.88.184/twambale/api/menu.class.php'
      : 'http://localhost/twambale/api/menu.class.php';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
    },
  );

  if (response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
      // return List<Map<String, dynamic>>.from(data);
    } else {
      // Handle empty response
      // You can return an empty list or handle it as needed
      return [];
    }
  } else {
    // Handle the error
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

Future<List<Map<String, dynamic>>> fetchDataFromPHP() async {
  String url = Platform.isAndroid
      ? 'http://192.168.88.184/twambale/api/user.class.php'
      : 'http://localhost/twambale/api/user.class.php';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
    },
  );
  if (response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      // return data.cast<Map<String, dynamic>>();
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      // Handle empty response
      // You can return an empty list or handle it as needed
      return [];
    }
  } else {
    // Handle the error
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

Future<OrdersModel?> fetchOrdersFromPHP() async {
  String url = Platform.isAndroid
      ? 'http://192.168.88.230/twambale/api/order.class.php'
      : 'http://localhost/twambale/api/order.class.php';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
    },
  );
  if (response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      // return data.cast<Map<String, dynamic>>();

      // final List<dynamic> orders = json.decode(response.body);
      // return List<Map<String, dynamic>>.from(orders);
      final items = json.decode(response.body);
      OrdersModel ordersModels = OrdersModel.fromJson(items);
      //print(ordersModels);

      return ordersModels;
    }
  } else {
    // Handle the error
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

// Future<List<Map<int, int>>> fetchYearTotals() async {
//   String url = Platform.isAndroid
//       ? 'http://192.168.88.230/twambale/api/yearly_orders.php'
//       : 'http://localhost/twambale/api/yearly_orders.php';
//
//   final response = await http.get(Uri.parse(url));
//   if (response.statusCode == 200) {
//
//     List<Map<int, int>> data = List<Map<int, int>>.from(json.decode(response.body));
//     print('Not returning a JSON file $data');
//
//     return data;
//   } else {
//     throw Exception('Failed to load data: ${response.statusCode}');
//   }
// }

Future<Map<String, dynamic>> fetchYearTotals() async {
  String url = Platform.isAndroid
      ? 'http://192.168.88.184/twambale/api/yearly_orders.php'
      : 'http://localhost/twambale/api/yearly_orders.php';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> fetchMonthTotals() async {
  String url = Platform.isAndroid
      ? 'http://192.168.88.184/twambale/api/yearly_orders.php'
      : 'http://localhost/twambale/api/yearly_orders.php';

  final response = await http.get(Uri.parse(url));
  print(response.body);
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

/* If the API Returns an Integer:  */
Future<int> fetchAmount() async {
  String url = Platform.isAndroid
      ? 'http://192.168.88.230/twambale/api/order.class.php'
      : 'http://localhost/twambale/api/order.class.php';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    throw Exception('Failed to load amount');
  }
}

/* If the API Returns an Integer Within a List:  */
Future<List<int>> fetchTotal() async {
  String url = Platform.isAndroid
      ? 'http://192.168.88.184/twambale/api/order.class.php'
      : 'http://localhost/twambale/api/order.class.php';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final amountList = [int.parse(response.body)];
    return amountList;
  } else {
    throw Exception('Failed to load amount');
  }
}

Future<int> getData() async {
  String url = Platform.isAndroid
      ? 'http://192.168.88.230/api/users/users.php'
      : 'http://localhost/api/products';
  final response = await http.get(
    Uri.parse(url),
    // body: {
    //   'action': 'some_action', // Define the action
    //   'data': 'your_data', // Include data to send
    // },
  );

  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    print('Request failed with status: ${response.statusCode}');
    return response.statusCode;
  }
}
