import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myvazi/routes.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/screens/frontpage.dart';
import 'package:myvazi/src/screens/profile.dart';
import 'package:myvazi/src/utility/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String phoneno;
  final String token;
  final Function onVerificationSuccess;

  const VerifyCodeScreen({
    super.key,
    required this.phoneno,
    required this.token,
    required this.onVerificationSuccess,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String userVerificationAction = "validateOTP";
  final String verificationAction = "validateJwtToken";
  String userID = '';
  String userPhone = '';
  int? code;
  late dynamic _error;
  String sessionID = "";

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Background image
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/icons/myvazi_app_logo.png'), // Replace 'assets/background_image.jpg' with your image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _codeController,
                decoration:
                    const InputDecoration(labelText: 'Verification Code'),
                keyboardType: TextInputType
                    .number, // Set keyboard type to accept only numbers
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  LengthLimitingTextInputFormatter(
                      6), // Limit input to 6 characters
                ],
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Code is valid, call a function to handle verification success
                  verifyOTPAndToken(_codeController.text, widget.token);
                },
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  // void _handleVerificationSuccess() {
  //   // Close the verification screen dialog
  //   Navigator.pop(context);

  //   // Navigate to the front page
  //   Navigator.pushReplacementNamed(
  //     context,
  //     '/profile',
  //     arguments: {'phoneNo': widget.phoneno},
  //   );
  // }

  Future<void> verifyOTPAndToken(String otp, String token) async {
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/token_based.php?action=$verificationAction'
          : '$_postCatUrl/token_based.php?action=$verificationAction';
      print(url);
      print(token);
      print(otp);
      // Send a POST request to the backend to verify OTP and token
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'entered_otp': otp,
          'token_from_client': token,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          // OTP validated successfully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              backgroundColor: Colors.green,
              // Adjust the duration as needed
              duration: const Duration(seconds: 3),
            ),
          );
          NavigationService.handleSuccessfulLogin(context);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const MainScreen(
          //         initialIndex: 0), // Initialize with the desired initial index
          //   ),
          // );

          setState(() {
            widget.onVerificationSuccess(4);
          });
        } else {
          // OTP validation failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              backgroundColor: Colors.red,
              // Adjust the duration as needed
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Handle HTTP error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching login data: ${response.statusCode}'),
            backgroundColor: Colors.red,
            // Adjust the duration as needed
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      _error = error; // Assign the caught error to _error
      print('Error fetching login data: $_error');
    }
  }

  // verifyUser(code) async {
  //   String url = Platform.isAndroid
  //       ? '$_postPhoneCatUrl/login.php'
  //       : '$_postCatUrl/login.php';

  //   final Map<String, dynamic> requestData = {
  //     'action': userVerificationAction,
  //     'oneTimePin': code,
  //   };

  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': "*/*",
  //       'connection': 'keep-alive',
  //     },
  //     body: jsonEncode(requestData),
  //   );

  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     String sessionID = json.decode(response.body);
  //     // Handle successful response
  //     //print(sessionID);

  //     // Store session_id locally using SharedPreferences
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('session_id', sessionID);

  //     // Navigate to homescreen or perform other actions
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const FrontPage()),
  //     );
  //   } else {
  //     throw Exception('Error fetching login data');
  //   }
  // }

  // void verifyUsers(code) async {
  //   try {
  //     String url = Platform.isAndroid
  //         ? '$_postPhoneCatUrl/login.php?action=$userVerificationAction&oneTimePin=$code'
  //         : '$_postCatUrl/login.php?action=$userVerificationAction&oneTimePin=$code';
  //     print(url);
  //     final res = await http.get(Uri.parse(url));
  //     // String sessionID = json.decode(res.body);
  //     print(res.body);

  //     try {
  //       String sessionID = json.decode(res.body);
  //       // Handle successful response
  //       print(sessionID);

  //       // Store session_id locally using SharedPreferences
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('session_id', sessionID);

  //       // Navigate to homescreen or perform other actions
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const FrontPage()),
  //       );
  //     } catch (error) {
  //       // Handle JSON decoding error
  //       print('Error decoding JSON: $error');
  //     }

  //     // Update the widget state
  //     setState(() {
  //       // No state update is needed here
  //     });
  //   } catch (error) {
  //     _error = error; // Assign the caught error to _error
  //     print('Error fetching login data: $_error');
  //   }
  // }
}
