import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:myvazi/src/configs/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<String?> storeToken() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.setString('token');
// }

class AuthToken {
  static final String _postPhoneCatUrl = MainConstants.phoneUrl;
  static final String _postCatUrl = MainConstants.baseUrl;
  static String tokenValidationMethod = 'getAllUserInfo';

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> validateToken(String token) async {
    String url = Platform.isAndroid
        ? '$_postPhoneCatUrl/get_profile_info.php?action=$tokenValidationMethod'
        : '$_postCatUrl/get_profile_info.php?action=$tokenValidationMethod';

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'token': 'Bearer $token',
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      Map<String, dynamic> tokenResponse = jsonDecode(response.body);

      // Check if the response indicates success
      if (tokenResponse['success'] == true) {
        // Access the profile data
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}

// Future<String?> getToken() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }
