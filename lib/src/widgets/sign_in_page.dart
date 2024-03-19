import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/providers/auth_state_provider.dart';
import 'package:myvazi/src/screens/frontpage.dart';
import 'package:myvazi/src/screens/profile.dart';
import 'package:myvazi/src/utility/signin.dart';
import 'package:myvazi/src/utils/verification_code_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  final Function(int) onVerificationSuccess;
  const SignInPage({
    super.key,
    required this.onVerificationSuccess,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String userVerificationAction = "requestOTP";
  final String verificationAction = "validateJwtToken";
  String localImagePath = '';
  int? code;
  String tokenID = "";
  late dynamic _error;

  // Future<void> signIn() async {
  //   try {
  //     String url = Platform.isAndroid
  //         ? '$_postPhoneCatUrl/token_based.php?action=$userVerificationAction&phoneNo=${_phoneController.text}'
  //         : '$_postCatUrl/token_based.php?action=$userVerificationAction&phoneNo=${_phoneController.text}';
  //     // Send a GET request to the backend to request OTP
  //     final otpResponse = await http.get(Uri.parse(url));

  //     if (otpResponse.statusCode == 200) {
  //       final otpData = json.decode(otpResponse.body);
  //       if (otpData['success'] == true) {
  //         setState(() {
  //           tokenID = otpData['token'];
  //         });

  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         await prefs.setString('token', tokenID);
  //       } else {
  //         // OTP request failed, show error message
  //         // Note: You may need to handle UI state changes accordingly
  //       }
  //     } else {
  //       // HTTP request failed, show error message
  //       // Note: You may need to handle UI state changes accordingly
  //     }
  //   } catch (error) {
  //     // Error occurred, show error message
  //     // Note: You may need to handle UI state changes accordingly
  //   }
  // }

  // Future<void> verifyOTPAndToken(String otp, String token) async {
  //   try {
  //     String url = Platform.isAndroid
  //         ? '$_postPhoneCatUrl/token_based.php?action=$verificationAction'
  //         : '$_postCatUrl/token_based.php?action=$verificationAction';
  //     print(url);
  //     // Send a POST request to the backend to verify OTP and token
  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: json.encode({
  //         'entered_otp': otp,
  //         'token_from_client': token,
  //       }),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       if (responseData['success'] == true) {
  //         // OTP validated successfully
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(responseData['message']),
  //             backgroundColor: Colors.green,
  //             // Adjust the duration as needed
  //             duration: const Duration(seconds: 3),
  //           ),
  //         );
  //       } else {
  //         // OTP validation failed
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(responseData['message']),
  //             backgroundColor: Colors.red,
  //             // Adjust the duration as needed
  //             duration: const Duration(seconds: 3),
  //           ),
  //         );
  //       }
  //     } else {
  //       // Handle HTTP request failure
  //     }
  //   } catch (error) {
  //     // Handle other errors (e.g., network error, server unreachable)
  //   }
  // }

  void login(BuildContext context, TextEditingController phoneController,
      Function(String) onVerificationSuccess) async {
    try {
      await AuthUtil.loginUser(context, phoneController, onVerificationSuccess);
    } catch (error) {
      // Handle error
    }
  }

  void onVerificationSuccess(String value) async {
    final authProvider = Provider.of<AuthState>(context, listen: false);
    await authProvider.login(value);
  }

  // Future<void> loginUser() async {
  //   try {
  //     String url = Platform.isAndroid
  //         ? '$_postPhoneCatUrl/token_based.php?action=$userVerificationAction&phoneNo=${phoneController.text}'
  //         : '$_postCatUrl/token_based.php?action=$userVerificationAction&phoneNo=${phoneController.text}';
  //     // Send a GET request to the backend to request OTP
  //     final otpResponse = await http.get(Uri.parse(url));

  //     if (otpResponse.statusCode == 200) {
  //       final otpData = json.decode(otpResponse.body);
  //       if (otpData['success'] == true) {
  //         print(otpData['otp']);
  //         setState(() {
  //           tokenID = otpData['token'];
  //           userID.value = otpData['userID'];
  //         });

  //         final authProvider = Provider.of<AuthState>(context, listen: false);
  //         await authProvider.login(tokenID);

  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(otpData['message']),
  //             backgroundColor: Colors.green,
  //             // Adjust the duration as needed
  //             duration: const Duration(seconds: 3),
  //           ),
  //         );

  //         // Navigate to the widget you want to display
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => VerifyCodeScreen(
  //                     phoneno: phoneController.text,
  //                     token: tokenID,
  //                     onVerificationSuccess: widget.onVerificationSuccess,
  //                   )),
  //         );
  //       } else {
  //         // OTP sending failed
  //         String errorMessage = otpData['message'] ??
  //             'Failed to send OTP. Please try again later.';
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(errorMessage),
  //             backgroundColor: Colors.red,
  //             // Adjust the duration as needed
  //             duration: const Duration(seconds: 3),
  //           ),
  //         );
  //       }
  //     } else {
  //       // Handle HTTP error
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content:
  //               Text('Error fetching login data: ${otpResponse.statusCode}'),
  //           backgroundColor: Colors.red,
  //           // Adjust the duration as needed
  //           duration: const Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   } catch (error) {
  //     _error = error; // Assign the caught error to _error
  //     print('Error fetching login data: $_error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          title: authProvider.isLoggedIn
              ? const Text('Profile')
              : const Text('Sign In')),
      body: authProvider.isLoggedIn
          ? const Profile(phoneNo: '')
          : _buildSignInForm(context),
    );
  }

  Widget _buildSignInForm(BuildContext context) {
    return Form(
      //key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text widget
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: localImagePath.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: localImagePath.isNotEmpty
                            ? localImagePath
                            : ServerConfig.defaultImageSquare,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      )
                    : Image.network(ServerConfig.defaultProfileImage),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: '256...',
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (usernameController.text.isNotEmpty ||
                        phoneController.text.isNotEmpty) {
                      // username and phone number have been provided, call a function to handle registration success
                      //loginUser();
                      // Then call the login function where you need to log in, passing the required parameters
                      login(context, phoneController, onVerificationSuccess);
                    } else {
                      // Code is invalid, show error message
                      _handleRegistrationFailure(context);
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegistrationFailure(BuildContext context) {
    // Close the verification screen dialog
    Navigator.pop(context);

    // Navigate to the front page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid registration data'),
        backgroundColor: Colors.red,
      ),
    );
  }
}



//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthState>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign In'),
//       ),
//       body: authProvider.isLoggedIn
//           ? const Profile(
//               phoneNo: '',
//             )
//           : Form(
//               //key: _formKey,
//               child: Padding(
//                 padding: const EdgeInsets.all(30.0),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       // Text widget
//                       SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.5,
//                           // ignore: unnecessary_null_comparison

//                           child: localImagePath.isNotEmpty
//                               ? CachedNetworkImage(
//                                   imageUrl: localImagePath.isNotEmpty
//                                       ? localImagePath
//                                       : ServerConfig.defaultImageSquare,
//                                   placeholder: (context, url) =>
//                                       const CircularProgressIndicator(),
//                                   errorWidget: (context, url, error) =>
//                                       const Icon(Icons.error),
//                                   fit: BoxFit.cover,
//                                 )
//                               : Image.network(
//                                   ServerConfig.defaultProfileImage)),
//                       TextField(
//                         controller: phoneController,
//                         decoration: const InputDecoration(
//                           hintText: '256...',
//                           labelText: 'Phone Number',
//                         ),
//                       ),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.01,
//                       ),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             if (usernameController.text.isNotEmpty ||
//                                 phoneController.text.isNotEmpty) {
//                               // username and phone number have been provided, call a function to handle registration success

//                               loginUser();
//                             } else {
//                               // Code is invalid, show error message
//                               _handleRegistrationFailure();
//                             }
//                           },
//                           child: const Text('Login'),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   void _handleRegistrationFailure() {
//     // Close the verification screen dialog
//     Navigator.pop(context);

//     // Navigate to the front page
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Invalid registration data'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }
