// import 'package:http/http.dart' as http;

// class Data {
//   String category; //location name for the UI
//   String subcategory; //the time in that location
//   String name; // url to an assets flag icon
//   int amount;  //location url for api endpoint
//
//   Data({required this.category, required this.subcategory, required this.name, required this.amount});
//
//   Future<void> getDataFromApi() async {
//     //make the request
//     final response = await http.get(Uri.parse('http://127.0.0.1:8000/myvazi/itemlist/'));
//     try {
//       Map data = jsonDecode(response.body);
//     }
//     catch (e) {
//       print('Request failed with status: $e');
//     }
//   }
//   Future<void> sendDataToApi(Map<String, dynamic> data) async {
//
//     final response = await http.post(
//       Uri.parse('http://127.0.0.1:8000/myvazi/create/'),
//       body: jsonEncode(data),
//       headers: {"Content-Type": "application/json"},
//     );
//     if (response.statusCode == 200) {
//       print('Data sent successfully: ${response.body}');
//     } else {
//       print('Failed to send data. Status code: ${response.statusCode}');
//     }
//   }
//
//
//   void sendUserData() {
//     final userData = {
//       'name': 'John Doe',
//       'email': 'john.doe@example.com',
//     };
//
//     sendDataToApi(userData);
//   }
// }

class Item {
  String title;
  String desc;
  String image;
  int amount;
  String seller;
  double rating;
  String tag;

  Item(
      {required this.title,
      required this.desc,
      required this.image,
      required this.amount,
      required this.seller,
      required this.rating,
      required this.tag});
}

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}
