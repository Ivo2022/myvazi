import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/forms/signin_form.dart';
import 'package:myvazi/src/forms/signup_form.dart';
import 'package:myvazi/src/providers/app_state_manager.dart';
import 'package:myvazi/src/providers/auth_state_provider.dart';
import 'package:myvazi/src/screens/profile.dart';
import 'package:myvazi/src/utility/signin.dart';
import 'package:myvazi/src/utils/auth_utils.dart';
import 'package:myvazi/src/utils/providers.dart';
import 'package:myvazi/src/widgets/drawer_categories.dart';
import 'package:myvazi/src/widgets/drawer_details.dart';
import 'package:myvazi/src/widgets/drawer_furnishings.dart';
import 'package:myvazi/src/widgets/drawer_men.dart';
import 'package:myvazi/src/widgets/drawer_purchases.dart';
import 'package:myvazi/src/widgets/drawer_sales.dart';
import 'package:myvazi/src/widgets/drawer_women.dart';
import 'package:provider/provider.dart';

class DrawerActions extends StatefulWidget {
  const DrawerActions({super.key});

  @override
  State<DrawerActions> createState() => _DrawerActionsState();
}

class _DrawerActionsState extends State<DrawerActions> {
  List<dynamic>? ourMainCatList;
  Map? drawer;
  int positionedTab = 0;
  int? hoverPosition;
  String tabName = '';
  int currentPage = 1;
  final bool isLoggedIn =
      false; // Flag to indicate whether the user is logged in
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String localImagePath = '';
  // String userName = '';
  // String userPhone = '';
  // String phoneNo = '';
  // int? activatedId;
  final bool _isFirstLoadRunning = false;
  bool canLogout = true;
  String tokenID = "";
  bool isLoading = false;
  Map userProfile = {};

  void drawerData(int categoryInt) {
    Map? drawer = ourMainCatList!
        .elementAt(categoryInt); // Obtain your drawer details here
    String drawerName = drawer!.values.elementAt(0);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(drawer: drawer, tabs: drawerName),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    homeList.addListener(() {
      if (homeList.value.isNotEmpty) {
        setState(() {
          ourMainCatList = homeList.value;
          print(ourMainCatList);
          //drawerData(0); // Initialize with the first category
        });
      }
    });
    fetchProfileInfo();
  }

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

  Future<Map<String, dynamic>> fetchProfileInfo() async {
    // Call fetchUserProfile
    Map<String, dynamic> userProfile = await UserProfileUtil.fetchUserProfile();

    return userProfile;
    // setState(() {
    //   userName = userProfile['name'] ?? 'Unknown';
    //   userPhone = userProfile['phone_number'] ?? 'Unknown';
    //   activatedId = userProfile['activation'] ?? 0;
    //   localImagePath =
    //       userProfile['profile_image'] ?? ServerConfig.defaultProfileImage;
    //   String location = userProfile['location'] ?? 'Unknown';
    //   String town = userProfile['town'] ?? 'Unknown';
    // });
  }

  Widget buildLoginButton() {
    // This widget is shown when the user is not logged in
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
                      // ignore: unnecessary_null_comparison

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
                          : Image.network(ServerConfig.defaultProfileImage)),
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
                          //loginUser();
                          login(
                              context, phoneController, onVerificationSuccess);
                        } else {
                          // Code is invalid, show error message
                          //_handleRegistrationFailure();
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Signup',
                          style: const TextStyle(
                            color: Colors
                                .blue, // Change text color to blue for clickable effect
                            decoration: TextDecoration
                                .underline, // Add underline for clickable effect
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to the signup page when "Signup" is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpForm()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ]))));

    // Center(
    //   child: ElevatedButton(
    //     onPressed: () {
    //       // Handle login button tap
    //     },
    //     child: const Text('Login'),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthState>(context, listen: false);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double sizeWidth =
        screenWidth < 480 ? screenWidth * 0.1 : screenWidth * 0.04;
    final sellerProvider = Provider.of<SellerDataProvider>(context);
    int sellerId = sellerID.value;
    return Drawer(
      elevation: 0,
      child: !authProvider.isLoggedIn
          ? SignInForm(
              onVerificationSuccess: (int) {},
            )
          : FutureBuilder<void>(
              future:
                  fetchProfileInfo(), // Call your function to load data asynchronously
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loading indicator while data is loading
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Handle error state
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  print(userProfile);
                  String userName = userProfile['name'] ?? 'Unknown';
                  String userPhone = userProfile['phone_number'] ?? 'Unknown';
                  int activatedId = userProfile['activation'] ?? 0;
                  localImagePath = userProfile['profile_image'] ??
                      ServerConfig.defaultProfileImage;
                  // Once data is loaded, display both ListViews
                  return Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          SizedBox(
                            height: 120, // Adjust as needed
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: sizeWidth,
                                      backgroundImage: NetworkImage(
                                        ServerConfig.defaultProfileImage,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(userName),
                                        Text(userPhone),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (activatedId != 0)
                            Column(
                              children: [
                                const Divider(),
                                const Center(
                                  child: Text(
                                    'Your Transactions',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.shopping_bag),
                                  title: const Text('Purchases'),
                                  onTap: () {
                                    Navigator.pop(context); // Close the drawer
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.monetization_on),
                                  title: const Text('Sales'),
                                  onTap: () {
                                    Navigator.pop(context); // Close the drawer
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DrawerSales(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (_isFirstLoadRunning) // Display loading indicator if data is loading
                        Container(
                          color: Colors.black.withOpacity(
                              0.1), // Semi-transparent black background
                          child: const Center(
                            child:
                                CupertinoActivityIndicator(), // Loading indicator widget
                          ),
                        ),
                    ],
                  );
                }
              },
            ),
    );

    // Drawer(
    //   elevation: 0,
    //   child: !authProvider.isLoggedIn
    //       ? SignInForm(
    //           onVerificationSuccess: (int) {},
    //         )
    //       //buildLoginButton()
    //       : activatedId == 0
    //           ? ListView(
    //               children: [
    //                 SizedBox(
    //                   height: 120, // Adjust as needed
    //                   child: Align(
    //                     alignment: Alignment.centerLeft,
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(left: 16.0),
    //                       child: Row(
    //                         children: [
    //                           CircleAvatar(
    //                             radius:
    //                                 sizeWidth, // Default radius for larger screens
    //                             backgroundImage: NetworkImage(
    //                                 ServerConfig.defaultProfileImage),
    //                           ),
    //                           const SizedBox(width: 10.0),
    //                           Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: [
    //                               Text(userName),
    //                               Text(userPhone),
    //                             ],
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             )
    //           : ListView(
    //               padding: EdgeInsets.zero,
    //               children: [
    //                 Visibility(
    //                   visible: sellerId != null,
    //                   child: SizedBox(
    //                     height: 120, // Adjust as needed
    //                     child: Align(
    //                       alignment: Alignment.centerLeft,
    //                       child: Padding(
    //                         padding: const EdgeInsets.only(left: 16.0),
    //                         child: Row(
    //                           children: [
    //                             CircleAvatar(
    //                               radius:
    //                                   sizeWidth, // Default radius for larger screens
    //                               backgroundImage: NetworkImage(
    //                                   ServerConfig.defaultProfileImage),
    //                             ),
    //                             const SizedBox(width: 10.0),
    //                             Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               mainAxisAlignment: MainAxisAlignment.center,
    //                               children: [
    //                                 Text(userName),
    //                                 Text(userPhone),
    //                               ],
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const Divider(),
    //                 const Center(
    //                   child: Text(
    //                     'Your Transactions',
    //                     style: TextStyle(fontWeight: FontWeight.bold),
    //                   ),
    //                 ),
    //                 const Divider(),
    //                 ListTile(
    //                   leading: const Icon(Icons.shopping_bag),
    //                   title: const Text('Purchases'),
    //                   onTap: () {
    //                     Navigator.pop(context); // Close the drawer
    //                   },
    //                 ),
    //                 ListTile(
    //                   leading: const Icon(Icons.monetization_on),
    //                   title: const Text('Sales'),
    //                   onTap: () {
    //                     Navigator.pop(context); // Close the drawer
    //                     Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                           builder: (context) => const DrawerSales()),
    //                     );
    //                   },
    //                 ),
    //               ],
    //             ),
    // );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
