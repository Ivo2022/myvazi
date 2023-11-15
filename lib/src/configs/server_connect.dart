import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchData() async {
  String url = Platform.isAndroid ? 'http://192.168.43.65/twambale/api.php' : 'http://localhost/twambale/api.php';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data);
  } else {
    throw Exception('Failed to load data. HTTP Error ${response.statusCode}');
  }
}
Future<Map<String, dynamic>> postData(String name, String visibility) async {
  String url = Platform.isAndroid ? 'http://192.168.43.65/twambale/api.php' : 'http://localhost/twambale/api.php';
  final Map<String, String> headers = {"Content-Type": "application/json"};

  final Map<String, dynamic> data = {"name": name, "visibility": visibility};

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('Failed to load data. HTTP Error ${response.statusCode}');
  }
}
Future<void> updateData(int id, String name, String visibility) async {
  String url = Platform.isAndroid ? 'http://192.168.43.65/twambale/api.php' : 'http://localhost/twambale/api.php';

  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': "*/*",
    'connection': 'keep-alive',
  };
  final Map<String, dynamic> data = {
    "name": name,
    "visibility": visibility,
  };

  final http.Response response = await http.put(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    print("Record updated successfully");
  } else {
    print("Failed to update record. HTTP Error ${response.statusCode}");
  }
}
Future<List<Map<String, dynamic>>> fetchToUpdateData(int id) async {
  String url = Platform.isAndroid ? 'http://192.168.43.65/twambale/api.php' : 'http://localhost/twambale/api.php';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data);
  } else {
    throw Exception('Failed to load data. HTTP Error ${response.statusCode}');
  }
}



