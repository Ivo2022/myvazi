import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/forms/signin_form.dart';
import 'package:myvazi/src/providers/auth_state_provider.dart';
import 'package:myvazi/src/utility/signin.dart';
import 'package:myvazi/src/utils/auth_utils.dart';
import 'package:myvazi/src/utils/create_shop.dart';
import 'package:myvazi/src/utils/help_modal.dart';
import 'package:myvazi/src/utils/retrieve_token.dart';
import 'package:myvazi/src/utils/verification_code_screen.dart';
import 'package:myvazi/src/widgets/revenue.dart';
import 'package:myvazi/src/widgets/reviews.dart';
import 'package:myvazi/src/widgets/sign_in_page.dart';
import 'package:myvazi/src/widgets/store.dart';
import 'package:myvazi/src/services/rating.dart';
import 'package:provider/provider.dart';
import 'package:myvazi/src/utils/providers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String phoneNo;
  const Profile({super.key, required this.phoneNo});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String userContentAction = "userData";
  final String profileAuthorize = "login";
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final String userVerificationAction = "requestOTP";
  final String verificationAction = "validateJwtToken";

  Map<String, dynamic> userData = {};
  List _userList = [];
  // String defaultImage = 'assets/images/default_image.jpg';
  late dynamic _error;
  String userName = '';
  String userPhone = '';
  String phoneNo = '';
  String localImagePath = '';
  bool _showRegistrationForm = true;
  bool canLogout = true;
  String tokenID = "";
  bool isLoading = false;
  Map userProfile = {};

  int? activatedId;

  @override
  void initState() {
    super.initState();
    // Call fetchUserProfile
    fetchProfileInfo();
    //fetchUserProfile();
    final sellerProvider =
        Provider.of<SellerDataProvider>(context, listen: false);
    //sellerProvider.fetchSellersData();
    final sellerRatingProvider =
        Provider.of<SellerRatingsProvider>(context, listen: false);
    sellerRatingProvider.fetchSellerRatingsData();
    final authStateProvider = Provider.of<AuthState>(context, listen: false);
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

// Inside an async function
  void fetchProfileInfo() async {
    // Call fetchUserProfile
    Map<String, dynamic> userProfile = await UserProfileUtil.fetchUserProfile();
    setState(() {
      userName = userProfile['name'] ?? 'Unknown';
      userPhone = userProfile['phone_number'] ?? 'Unknown';
      activatedId = userProfile['activation'] ?? 0;
      localImagePath =
          userProfile['profile_image'] ?? ServerConfig.defaultProfileImage;
      String location = userProfile['location'] ?? 'Unknown';
      String town = userProfile['town'] ?? 'Unknown';
    });
  }

  // Future<void> _fetchUserContent() async {
  //   try {
  //     // Check if widget.phoneNo is null or empty, and assign a default phone number if necessary
  //     String phoneNo = widget.phoneNo ?? '';
  //     String url = Platform.isAndroid
  //         ? '$_postPhoneCatUrl/user_profile_data.php?action=$userContentAction&phoneNo=${widget.phoneNo}'
  //         : '$_postCatUrl/user_profile_data.php?action=$userContentAction&phoneNo=${widget.phoneNo}';
  //     print(url);

  //     final res = await http.get(Uri.parse(url));

  //     setState(() {
  //       // Keep the existing data and simply add more data to it.
  //       _userList = json.decode(res.body);
  //     });
  //   } catch (error) {
  //     _error = error; // Assign the caught error to _error
  //     print('Error fetching user data: $_error');
  //   }
  // }

// if (phoneController.text.isEmpty) {
//         // Display registration form
//         setState(() {
//           _userList = []; // Clear existing user data
//           _showRegistrationForm =
//               false; // Set flag to display registration form
//         });
//       }

  // Future<void> _fetchUserContent() async {
  //   // setState(() {
  //   //   AuthState().login();
  //   // });
  //   try {
  //     String url = Platform.isAndroid
  //         ? '$_postPhoneCatUrl/user_profile_data.php?action=$userContentAction&phoneNo=${phoneController.text}'
  //         : '$_postCatUrl/user_profile_data.php?action=$userContentAction&phoneNo=${phoneController.text}';
  //     final res = await http.get(Uri.parse(url));

  //     setState(() {
  //       // Keep the existing data and simply add more data to it.
  //       _userList = json.decode(res.body);
  //       Map userdata = _userList.first;
  //       userName = userdata.values.elementAt(2);
  //       userPhone = userdata.values.elementAt(1);
  //       String activation = userdata.values.elementAt(4);
  //       // Check if the activation variable for the current user is equal to one
  //       if (activation == "1") {
  //         sellerID.value = int.parse(userdata.values.elementAt(0));
  //       } else if (activation == "0") {
  //         userID.value = int.parse(userdata.values.elementAt(0));
  //       } else {
  //         print('User ${userdata['user_id']} is not activated');
  //       }
  //       //Provider.of<ValueNotifier<int>>(context).value = userdata.values.elementAt(0);
  //       String userImage = userdata.values.elementAt(3);
  //       localImagePath = '${ServerConfig.profileImages}$userImage';
  //       _showRegistrationForm = false; // Hide registration form

  //       //_handleRegistrationSuccess();
  //     });
  //   } catch (error) {
  //     _error = error; // Assign the caught error to _error
  //     print('Error fetching user data: $_error');
  //   }
  // }

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
  //         setState(() {
  //           tokenID = otpData['token'];
  //           userID.value = otpData['userID'];
  //         });

  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         await prefs.setString('token', tokenID);
  //         print(otpData['otp']);
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

  // void loginUser() async {
  //   try {
  //     String url = Platform.isAndroid
  //         ? '$_postPhoneCatUrl/login.php?action=$userLoginAction&phoneNo=${phoneController.text}'
  //         : '$_postCatUrl/login.php?action=$userLoginAction&phoneNo=${phoneController.text}';

  //     print(url);
  //     final res = await http.get(Uri.parse(url));

  //     if (res.statusCode == 200) {
  //       // Decode the response body
  //       Map<String, dynamic> data = json.decode(res.body);
  //       // Check if the response indicates success
  //       if (data['success'] == true) {
  //         print(data['otp']);
  //         // OTP sent successfully
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(data['message']),
  //             backgroundColor: Colors.green,
  //             // Adjust the duration as needed
  //             duration: const Duration(seconds: 3),
  //           ),
  //         );
  //         print(phoneController.text);
  //         // Navigate to the widget you want to display
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => VerifyCodeScreen(
  //                     phoneno: phoneController.text,
  //                   )),
  //         );
  //       } else {
  //         // OTP sending failed
  //         String errorMessage =
  //             data['message'] ?? 'Failed to send OTP. Please try again later.';
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
  //           content: Text('Error fetching login data: ${res.statusCode}'),
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

  // void _handleRegistrationSuccess() {
  //   // Close the verification screen dialog
  //   Navigator.pop(context);

  //   // Navigate to the front page
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('You have been logged in'),
  //       backgroundColor: Colors.green,
  //     ),
  //   );
  //   // Show the registration form again
  //   setState(() {
  //     _showRegistrationForm = false;
  //   });
  // }

  void _handleLogoutSuccess(BuildContext context) async {
    final authProvider = Provider.of<AuthState>(context, listen: false);
    await authProvider.logout();

    // Clear the navigation stack and redirect to the initial screen
    Navigator.pushReplacementNamed(context, '/initial');
  }

  // void _handleRegistrationFailure() {
  //   // Close the verification screen dialog
  //   Navigator.pop(context);

  //   // Navigate to the front page
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Invalid registration data'),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  //   // Show the registration form again
  //   setState(() {
  //     _showRegistrationForm = true;
  //   });
  // }

  // showForm() {
  //   return Form(
  //     //key: _formKey,
  //     child: Padding(
  //       padding: const EdgeInsets.all(30.0),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             // Text widget
  //             SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.5,
  //                 // ignore: unnecessary_null_comparison

  //                 child: localImagePath.isNotEmpty
  //                     ? CachedNetworkImage(
  //                         imageUrl: localImagePath.isNotEmpty
  //                             ? localImagePath
  //                             : ServerConfig.defaultImageSquare,
  //                         placeholder: (context, url) =>
  //                             const CircularProgressIndicator(),
  //                         errorWidget: (context, url, error) =>
  //                             const Icon(Icons.error),
  //                         fit: BoxFit.cover,
  //                       )
  //                     : Image.network(ServerConfig.defaultProfileImage)),
  //             TextField(
  //               controller: phoneController,
  //               decoration: const InputDecoration(
  //                 hintText: '256...',
  //                 labelText: 'Phone Number',
  //               ),
  //             ),
  //             SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.01,
  //             ),
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   if (usernameController.text.isNotEmpty ||
  //                       phoneController.text.isNotEmpty) {
  //                     // username and phone number have been provided, call a function to handle registration success

  //                     //loginUser();
  //                   } else {
  //                     // Code is invalid, show error message
  //                     _handleRegistrationFailure();
  //                   }
  //                 },
  //                 child: const Text('Login'),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Future<void> fetchUserID() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   String? token = await AuthToken.getToken();
  //   if (token == null) {
  //     // Handle the case where the token is not available
  //     return;
  //   }

  //   String url = Platform.isAndroid
  //       ? '$_postPhoneCatUrl/authorize_user.php?action=authorizeUser'
  //       : '$_postCatUrl/authorize_user.php?action=authorizeUser';

  //   final response = await http.post(
  //     Uri.parse(url),
  //     body: json.encode({
  //       'token': 'Bearer $token',
  //     }),
  //     headers: {'Content-Type': 'application/json'},
  //   );

  //   if (response.statusCode == 200) {
  //     // If the server returns a 200 OK response, parse the JSON
  //     Map<String, dynamic> userData = jsonDecode(response.body);

  //     setState(() {
  //       userID.value = userData.values.elementAt(1);
  //       isLoading = false;
  //     });
  //   } else {
  //     // If the server returns an error response, handle it accordingly
  //     setState(() {
  //       userID.value = 0;
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> fetchUserProfile() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   String? token = await AuthToken.getToken();
  //   if (token == null) {
  //     // Handle the case where the token is not available
  //     return;
  //   }

  //   String url = Platform.isAndroid
  //       ? '$_postPhoneCatUrl/get_profile_info.php?action=getAllUserInfo'
  //       : '$_postCatUrl/get_profile_info.php?action=getAllUserInfo';

  //   final response = await http.post(
  //     Uri.parse(url),
  //     body: json.encode({
  //       'token': 'Bearer $token',
  //     }),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     // If the server returns a 200 OK response, parse the JSON
  //     Map<String, dynamic> profileData = jsonDecode(response.body);

  //     // Check if the response indicates success
  //     if (profileData['success'] == true) {
  //       // Access the profile data
  //       Map<String, dynamic> profile = profileData['profile'];
  //       setState(() {
  //         // Access individual fields from the profile
  //         userName = profile['name'] ?? 'Unknown';
  //         userPhone = profile['phone_number'] ?? 'Unknown';
  //         activatedId = profile['activation'] ?? 0;
  //         localImagePath =
  //             profile['profile_image'] ?? ServerConfig.defaultProfileImage;
  //         isLoading = false;
  //       });

  //       String location = profile['location'] ?? 'Unknown';
  //       String town = profile['town'] ?? 'Unknown';

  //       // Now you can use the profile data as needed
  //       print('Location: $location');
  //       print('Town: $town');
  //     } else {
  //       // Handle the case where the API request was not successful
  //       print('API request failed.');
  //     }

  //     setState(() {
  //       isLoading = false;
  //     });
  //   } else {
  //     // If the server returns an error response, handle it accordingly
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Access the User Data Provider using Provider.of
    // final sellerProvider = Provider.of<SellerDataProvider>(context);
    final sellerRatingProvider = Provider.of<SellerRatingsProvider>(context);
    // var username = sellerProvider.sellers?.userName;
    // var phoneNo = sellerProvider.sellers?.userPhone;
    final authProvider = Provider.of<AuthState>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double sizeWidth =
        screenWidth < 600 ? screenWidth * 0.1 : screenWidth * 0.04;
    double spacingBetween =
        screenWidth < 600 ? screenWidth * 0.04 : screenWidth * 0.3;
    return !authProvider.isLoggedIn
        ? SignInForm(
            onVerificationSuccess: (int) {},
          )
        : DefaultTabController(
            length: 3, // Set the number of tabs
            child: Scaffold(
              appBar: AppBar(
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  // Adjust the height as needed
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: spacingBetween),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius:
                                  sizeWidth, // Default radius for larger screens
                              backgroundImage: localImagePath.isNotEmpty
                                  ? NetworkImage(localImagePath)
                                  : NetworkImage(
                                      ServerConfig.defaultProfileImage),
                            ),
                          ],
                        ),
                      ),
                      if (userName.isNotEmpty && userPhone.isNotEmpty)
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: spacingBetween),
                              child: Row(
                                children: [
                                  Text(
                                    userName,
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.02,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: spacingBetween),
                              child: Row(
                                children: [
                                  Text(userPhone),
                                ],
                              ),
                            ),
                            if (sellerRatingProvider.sellerRatings != null)
                              Padding(
                                padding: EdgeInsets.only(left: spacingBetween),
                                child: Row(
                                  children: [
                                    StarRating(
                                        rating: sellerRatingProvider
                                            .sellerRatings!.sellerStars),
                                    Text((double.parse(sellerRatingProvider
                                            .sellerRatings!.sellerStars
                                            .toStringAsFixed(1)))
                                        .toString())
                                  ],
                                ),
                              )
                            else
                              const Center(
                                child: Text("No Reviews"),
                              ),
                          ],
                        )
                      else
                        const Center(
                          child: Text("No Users"),
                        ),
                      const Spacer(),
                      // SizedBox(width: screenWidth * 0.02),
                      // TextButton.icon(
                      //   onPressed: () {
                      //     // Add your onPressed action here
                      //     // Navigator.pushNamed(
                      //     //   context,
                      //     //   '/account-edit',
                      //     //   arguments: {
                      //     //     'defaultImage': ServerConfig.defaultProfileImage,
                      //     //     'username': userName,
                      //     //     'phoneNo': userPhone,
                      //     //   },
                      //     // );
                      //   },
                      //   icon: const Icon(
                      //     Icons.edit,
                      //     color: Colors.black,
                      //   ),
                      //   label: const Text(
                      //     'Edit',
                      //     style: TextStyle(color: Colors.black),
                      //   ),
                      // ),
                      PopupMenuButton(
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            // const PopupMenuItem(
                            //   value: 'logout',
                            //   child: Text('Sign Out'),
                            // ),
                          ];
                        },
                        onSelected: (value) {
                          setState(() {
                            if (value == 'edit') {
                              Navigator.pushNamed(
                                context,
                                '/account-edit',
                                arguments: {
                                  'defaultImage':
                                      ServerConfig.defaultProfileImage,
                                  'username': userName,
                                  'phoneNo': userPhone,
                                },
                              );
                            } else if (value == 'logout') {
                              //authState.logout();
                              _handleLogoutSuccess(context);
                              // // Check if logout is allowed
                              // if (canLogout) {
                              //   // Call the logout function
                              //   _handleLogoutSuccess();
                              // } else {
                              //   // Handle the case where logout is not allowed
                              //   // You can show a message or perform alternative logic
                              //   print('Logout is not allowed at this time.');
                              // }
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              body: activatedId == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Need to sell your products?\n",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14, // Adjust the font size as needed
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Create a shop today',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CreateShopScreen()),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(text: 'REVIEWS'),
                            Tab(text: 'STORE'),
                            Tab(text: 'REVENUE'),
                          ],
                          isScrollable: true,
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black), // Adjust label style
                          indicatorSize:
                              TabBarIndicatorSize.label, // Set indicator size
                          // labelPadding: EdgeInsets.zero, // Remove label padding
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              SupplierReview(),
                              Store(),
                              Revenue(),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          );
  }
}
