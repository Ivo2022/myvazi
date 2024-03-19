import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/utils/retrieve_token.dart';
import 'package:myvazi/src/utils/verification_code_screen.dart'; // Import necessary packages
import 'package:http/http.dart' as http;

final String _postPhoneCatUrl = MainConstants.phoneUrl;
final String _postCatUrl = MainConstants.baseUrl;

class AuthUtil {
  static String userVerificationAction = 'requestOTP';

  static Future<void> loginUser(
      BuildContext context,
      TextEditingController phoneController,
      Function(String) onVerificationSuccess) async {
    try {
      // Your code to fetch OTP and login user
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/token_based.php?action=$userVerificationAction&phoneNo=${phoneController.text}'
          : '$_postCatUrl/token_based.php?action=$userVerificationAction&phoneNo=${phoneController.text}';
      print(url);

      final otpResponse = await http.get(Uri.parse(url));

      if (otpResponse.statusCode == 200) {
        final otpData = json.decode(otpResponse.body);
        if (otpData['success'] == true) {
          print(otpData['otp']);
          // Set token and user ID
          String tokenID = otpData['token'];
          //int userID = otpData['userID'];

          // Call onVerificationSuccess callback
          onVerificationSuccess(tokenID);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(otpData['message']),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );

          // Navigate to VerifyCodeScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyCodeScreen(
                phoneno: phoneController.text,
                token: tokenID,
                onVerificationSuccess: onVerificationSuccess,
              ),
            ),
          );
        } else {
          // Show error message if OTP sending failed
          String errorMessage = otpData['message'] ??
              'Failed to send OTP. Please try again later.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Handle HTTP error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error fetching login data: ${otpResponse.statusCode}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      // Handle any errors
      print('Error fetching login data: $error');
    }
  }
}

class UserProfileUtil {
  static String fetchuserProfileAction = 'getAllUserInfo';

  static Future<Map<String, dynamic>> fetchUserProfile() async {
    String? token = await AuthToken.getToken();
    if (token == null) {
      // Handle the case where the token is not available
      return {'error': 'Token is not available'};
    }

    String url = Platform.isAndroid
        ? '$_postPhoneCatUrl/get_profile_info.php?action=$fetchuserProfileAction'
        : '$_postCatUrl/get_profile_info.php?action=$fetchuserProfileAction';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'token': 'Bearer $token',
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      Map<String, dynamic> profileData = jsonDecode(response.body);

      // Check if the response indicates success
      if (profileData['success'] == true) {
        // Access the profile data
        Map<String, dynamic> profile = profileData['profile'];
        // String location = profile['location'] ?? 'Unknown';
        // String town = profile['town'] ?? 'Unknown';
        return profile;
        // Return the profile data
        // return {
        //   'userName': profile['name'] ?? 'Unknown',
        //   'userPhone': profile['phone_number'] ?? 'Unknown',
        //   'activatedId': profile['activation'] ?? 0,
        //   'localImagePath':
        //       profile['profile_image'] ?? ServerConfig.defaultProfileImage,
        //   'location': location,
        //   'town': town,
        //   'error': null, // No error
        // };
      } else {
        // Handle the case where the API request was not successful
        return {'error': 'API request failed.'};
      }
    } else {
      // If the server returns an error response, handle it accordingly
      return {'error': 'Server error'};
    }
  }
}
