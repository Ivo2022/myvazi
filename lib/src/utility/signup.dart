import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
// Import necessary packages
import 'package:http/http.dart' as http;

final String _postPhoneCatUrl = MainConstants.phoneUrl;
final String _postCatUrl = MainConstants.baseUrl;

class SellerSignUpUtil {
  static String registerUserAction = 'addSellerDetails';

  static Future<Map<String, dynamic>> postUserDetails(
    BuildContext context,
    TextEditingController phoneController,
    TextEditingController fullNameController,
    TextEditingController bizNameController,
    TextEditingController addressController,
  ) async {
    String url = Platform.isAndroid
        ? '$_postPhoneCatUrl/post_user_details.php?action=$registerUserAction'
        : '$_postCatUrl/post_user_details.php?action=$registerUserAction';

    Map<String, dynamic> data = {
      'phoneno': phoneController.text,
      'fullname': fullNameController.text,
      'bizname': bizNameController.text,
      'address': addressController.text
    };

    final response = await http.post(Uri.parse(url), body: json.encode(data));
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      Map<String, dynamic> status = jsonDecode(response.body);
      print(response.body);
      // Check if the response indicates success
      if (status['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(status['message']),
            backgroundColor: Colors.green,
            // Adjust the duration as needed
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(status['message']),
            backgroundColor: Colors.red,
            // Adjust the duration as needed
            duration: const Duration(seconds: 3),
          ),
        );
      }
      print(status);
      return status;
    } else {
      // If the server returns an error response, handle it accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Server error'),
          backgroundColor: Colors.red,
          // Adjust the duration as needed
          duration: Duration(seconds: 3),
        ),
      );
      // Return null in case of an error
      return {};
    }
  }
}
