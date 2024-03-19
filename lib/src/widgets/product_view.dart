import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myvazi/src/forms/signin_form.dart';
import 'package:myvazi/src/providers/auth_state_provider.dart';
import 'package:myvazi/src/services/rating.dart';
import 'package:myvazi/src/utility/navigation_service.dart';
import 'package:myvazi/src/utility/signin.dart';
import 'package:myvazi/src/utils/providers.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/utils/retrieve_token.dart';
import 'package:provider/provider.dart';

// class ProductViewWidget extends StatefulWidget {
//   const ProductViewWidget({super.key});

//   @override
//   State<ProductViewWidget> createState() => _ProductViewWidgetState();
// }

// class _ProductViewWidgetState extends State<ProductViewWidget> {
//   final _postCatUrl = MainConstants.baseUrl;
//   final _postPhoneCatUrl = MainConstants.phoneUrl;
//   final String contentAction = "getProductsForSubCategory";
//   final String sizeIdAction = "getProductSizes";

//   String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
//   String emptyStateMessage = "";
//   String emptyStateAction = "";
//   String subcatName = '';
//   late int subCatID;

//   List? ourHomeList;
//   List sellerDetails = [];
//   List subCatsShown = [];
//   List productsShown = [];
//   List? subcatList = [];

//   Map? home;
//   Map? subcats;

//   bool noData = false;
//   bool _isFirstLoadRunning = false;
//   bool _isLoadMoreRunning = false;
//   //bool isButtonDisabled = true;

//   int _page = 1;

//   // Maintain the current category

//   late List subcategoryProductsList = [];
//   late List filteredSubCatProducts = [];
//   // late ScrollController _controller;
//   final ScrollController _controller = ScrollController();

//   late List filteredSubCatProductsList;
//   late List displayedProducts;
//   List<dynamic> sizes = [];
//   List<String> sizeNames = []; // List to store size names

//   @override
//   void initState() {
//     super.initState();
//     // Attach listener for scroll events
//     // _controller.addListener(_scrollListener);
//     final sellerRatingsProvider =
//         Provider.of<SellerRatingsProvider>(context, listen: false);
//     sellerRatingsProvider.fetchSellerRatingsData();
//     final sellerProvider =
//         Provider.of<SellerDataProvider>(context, listen: false);
//     sellerProvider.fetchSellersData();
//     final usersProvider = Provider.of<UserDataProvider>(context, listen: false);
//     usersProvider.fetchUsersData();
//     _controller.addListener(_scrollListener);
//   }

//   Future<List> _fetchContentData(subcatId) async {
//     if (_isFirstLoadRunning) return [];

//     setState(() {
//       _isFirstLoadRunning = true;
//     });
//     try {
//       String url = Platform.isAndroid
//           ? '$_postPhoneCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subcatId&page=$_page'
//           : '$_postCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subcatId&page=$_page';
//       final res = await http.get(Uri.parse(url));
//       if (res.statusCode == 200) {
//         final List<dynamic> newData = json.decode(res.body);
//         if (mounted) {
//           setState(() {
//             displayedProducts = newData;
//             _isFirstLoadRunning = false;
//             _page++;
//           });
//         }
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       setState(() {
//         _isFirstLoadRunning = false;
//       });
//       rethrow;
//     }
//     return displayedProducts;
//   }

//   Future<List> fetchMoreData(int subCatID, int page) async {
//     if (_isLoadMoreRunning) return [];
//     setState(() {
//       _isLoadMoreRunning = true;
//     });

//     try {
//       String url = Platform.isAndroid
//           ? '$_postPhoneCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page'
//           : '$_postCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page';
//       print(url);
//       final res = await http.get(Uri.parse(url));
//       final List fetchedData = json.decode(res.body);

//       if (fetchedData.isNotEmpty && res.statusCode == 200) {
//         // Keep the existing data and simply add more data to it.
//         displayedProducts.addAll(fetchedData);
//         _isLoadMoreRunning = false;
//         _page++;
//       } else {
//         setState(() {
//           noData = true;
//         });
//       }
//     } catch (error) {
//       setState(() {
//         _isLoadMoreRunning = false;
//       });
//       rethrow;
//     }
//     return displayedProducts;
//   }

//   Future<List<dynamic>> fetchSizes(productId) async {
//     // Check if already loading
//     if (_isFirstLoadRunning) return sizeNames;

//     setState(() {
//       _isFirstLoadRunning = true;
//     });

//     try {
//       String url = Platform.isAndroid
//           ? '$_postPhoneCatUrl/get_product_sizes.php?action=$sizeIdAction&productId=$productId'
//           : '$_postCatUrl/get_product_sizes.php?action=$sizeIdAction&productId=$productId';
//       print(url);
//       final res = await http.get(Uri.parse(url));
//       if (res.statusCode == 200) {
//         List<dynamic> sizesList = json.decode(res.body);
//         // for (int i = 0; i < sizesList.length; i++) {
//         //   Map sizedetails = sizesList.elementAt(i);
//         //   int sizeID = sizedetails['size_id'];
//         //   String sizeName = sizedetails['name'];
//         //   sizes.add({'size_id': sizeID, 'name': sizeName});
//         // }

//         // List sizes = [];
//         for (int i = 0; i < sizesList.length; i++) {
//           Map sizedetails = sizesList.elementAt(i);
//           int sizeID = int.parse(sizedetails['size_id']);
//           String sizeName = sizedetails['name'];
//           sizes.add({'size_id': sizeID, 'name': sizeName});
//         }
//         // for (int i = 0; i < sizesList.length; i++) {
//         //   Map<String, dynamic> sizeDetails = sizesList[i];
//         //   // Extract size name from the map and add it to the list
//         //   String sizeName = sizeDetails['name'];
//         //   sizeNames.add(sizeName);
//         // }
//       } else {
//         throw Exception('Failed to load sizes');
//       }
//     } catch (error) {
//       rethrow;
//     }

//     // Set isFirstLoadRunning to false after fetching sizes
//     setState(() {
//       _isFirstLoadRunning = false;
//     });

//     return sizes;
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     // // Retrieve data from the previous screen
//     // Map<String, dynamic>? arguments =
//     //     (ModalRoute.of(context)!.settings.arguments ?? {})
//     //         as Map<String, dynamic>?;

//     // Retrieve the passed arguments
//     final Map<String, dynamic> args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     subCatID = args['subCatID'];

//     subcatName = args['subCatName'] ?? "";
//     _fetchContentData(subCatID);
//     // if (arguments.isNotEmpty) {
//     //   if (arguments['subCatProducts'] is List<dynamic>) {
//     //     final List subCatProducts = arguments['subCatProducts'] ?? [];
//     //     print(subCatProducts);
//     //     // Filter products based on the selected subcategory
//     //     filteredSubCatProducts = subCatProducts
//     //         .where((product) => product['subcat_name'] == subcatName)
//     //         .toList();
//     //     // print(filteredSubCatProducts);
//     //     if (filteredSubCatProducts.isNotEmpty) {
//     //       Map filteredSubCatProductsMap = filteredSubCatProducts.first;
//     //       filteredSubCatProductsList =
//     //           filteredSubCatProductsMap.values.elementAt(2);

//     //       // Ensure filteredSubCatProductsList is not null
//     //     } else {
//     //       // Handle the case where filteredSubCatProductsList is null
//     //       displayEmptyState();
//     //       // Initialize displayedProducts with an empty list or handle it as needed
//     //       displayedProducts = [];
//     //     }

//     //     // Initialize displayedProducts with an initial set of items
//     //     setState(() {
//     //       _isFirstLoadRunning = true;

//     //       // Ensure that filteredSubCatProductsList is not null
//     //       if (filteredSubCatProductsList != null) {
//     //         displayedProducts = List.from(filteredSubCatProductsList.take(10));
//     //         displayedProducts.sort((a, b) {
//     //           String? timeA = a['date_of_upload'];
//     //           String? timeB = b['date_of_upload'];

//     //           //print('timeA: $timeA, timeB: $timeB');

//     //           if (timeA != null && timeB != null) {
//     //             return timeB.compareTo(timeA);
//     //           }

//     //           return 0;
//     //         });
//     //       } else {
//     //         // Handle the case where filteredSubCatProductsList is null
//     //         displayEmptyState();
//     //       }
//     //       _isFirstLoadRunning = false;
//     //     });
//     //   } else if (arguments['subCatProducts'] is String) {
//     //     // Handle the case where 'subCatProducts' is a string
//     //     print("It is a String!");
//     //   }
//     // }
//   }

//   void displayEmptyState() {
//     // For example, set a message and actions
//     filteredSubCatProductsList = []; // Example: Assign an empty list
//     emptyStateMessage = "No products found";
//     emptyStateAction = "Explore other subcategories";
//   }

//   // void _scrollListener() {
//   //   if (_controller.position.pixels == _controller.position.maxScrollExtent) {
//   //     fetchMoreData(subCatID, _page);
//   //   }
//   // }

//   void _scrollListener() {
//     if (_controller.position.pixels == _controller.position.maxScrollExtent) {
//       // If user scrolled to the bottom
//       if (!_isLoadMoreRunning) {
//         // If not currently loading, load more data
//         fetchMoreData(subCatID, _page);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     final sellerRatingsProvider = Provider.of<SellerRatingsProvider>(context);
//     final sellerProvider = Provider.of<SellerDataProvider>(context);
//     final usersProvider = Provider.of<UserDataProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(subcatName),
//       ),
//       body: _isFirstLoadRunning
//           ? Center(
//               child: buildLoadingIndicator(),
//             )
//           : SingleChildScrollView(
//               child: Column(
//               children: [
//                 saleProductDetails(screenHeight, sellerRatingsProvider,
//                     sellerProvider, usersProvider, screenWidth),
//               ],
//             )),
//     );
//   }

//   Center saleProductDetails(
//       double screenHeight,
//       SellerRatingsProvider sellerRatingsProvider,
//       SellerDataProvider sellerProvider,
//       UserDataProvider usersProvider,
//       double screenWidth) {
//     var userName = usersProvider.users?.name;
//     var phone = usersProvider.users?.phone;
//     var location = usersProvider.users?.location;
//     var town = usersProvider.users?.town;

//     return Center(
//       child: Column(
//         children: [
//           if (displayedProducts.isNotEmpty)
//             SizedBox(
//               height: screenHeight,
//               child: ListView.builder(
//                 controller: _controller,
//                 itemCount: displayedProducts.isNotEmpty
//                     ? displayedProducts.length + 1
//                     : 1, // Add 1 for potential error message
//                 itemBuilder: (BuildContext context, int indexing) {
//                   try {
//                     if (displayedProducts.isEmpty) {
//                       return Center(
//                         child: Text('All "$subcatName" are sold out!'),
//                       );
//                     } else if (indexing < displayedProducts.length) {
//                       double element =
//                           sellerRatingsProvider.sellerRatings!.sellerStars;

//                       Map subcategoryProductsMap =
//                           displayedProducts.elementAt(indexing);

//                       int price =
//                           int.parse(subcategoryProductsMap.values.elementAt(3));
//                       String sellerName =
//                           subcategoryProductsMap.values.elementAt(1);
//                       String productName =
//                           subcategoryProductsMap.values.elementAt(2);
//                       int productId =
//                           int.parse(subcategoryProductsMap.values.elementAt(0));
//                       int productIndex = indexing;

//                       List<String> prodImages = [];
//                       for (var i = 4; i < 7; i++) {
//                         var image = subcategoryProductsMap.values.elementAt(i);
//                         if (image != null && image.toString().isNotEmpty) {
//                           prodImages.add('$image');
//                         }
//                       }
//                       return Column(
//                         children: [
//                           cardData(
//                               screenWidth,
//                               screenHeight,
//                               prodImages,
//                               context,
//                               productName,
//                               productId,
//                               price,
//                               sellerName,
//                               element,
//                               userName,
//                               phone,
//                               location,
//                               productIndex,
//                               town),
//                           displayedProducts.length == indexing &&
//                                   _isLoadMoreRunning == true
//                               ? Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 5, bottom: 5),
//                                       child: Center(
//                                         child: buildLoadingIndicator(),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : const SizedBox(),
//                           displayedProducts.length == indexing && noData == true
//                               ? const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Padding(
//                                         padding:
//                                             EdgeInsets.only(top: 5, bottom: 5),
//                                         child: Text(
//                                             'You have loaded all the data.')),
//                                   ],
//                                 )
//                               : const SizedBox(),
//                         ],
//                       );
//                     } else {
//                       // Loading indicator
//                       return Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 5, bottom: 5),
//                             child: Center(
//                               child: buildLoadingIndicator(),
//                             ),
//                           ),
//                         ],
//                       );
//                     }
//                   } catch (e) {
//                     // Handle the case where the index is out of range
//                     return null; // or any other widget you want to display
//                   }
//                 },
//               ),
//             )
//           else
//             SizedBox(
//               height: screenHeight,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     emptyStateMessage,
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                   const SizedBox(height: 10),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text(
//                       emptyStateAction,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.blue, // Add your desired color
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Padding cardData(
//       double screenWidth,
//       double screenHeight,
//       List<String> prodImages,
//       BuildContext context,
//       String productName,
//       int productId,
//       int price,
//       String sellerName,
//       double element,
//       String? userName,
//       String? phone,
//       String? location,
//       int? productIndex,
//       String? town) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(screenWidth * 0.01, screenHeight * 0.01,
//           screenWidth * 0.01, screenHeight * 0.0),
//       child: Container(
//         color: Colors.white,
//         child: Card(
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           child: Column(
//             children: [
//               if ((prodImages).where((image) => image.isNotEmpty).length > 1)
//                 CarouselSlider(
//                   options: CarouselOptions(height: screenHeight * 0.45),
//                   items:
//                       (prodImages).where((image) => image.isNotEmpty).map((i) {
//                     return Builder(
//                       builder: (BuildContext context) {
//                         // Check if the image is a network image or a local image
//                         String localImagePath = '${ServerConfig.uploads}$i';
//                         // Local image
//                         return CachedNetworkImage(
//                           height: screenHeight * 1.0, // Adjust as needed
//                           width: screenWidth *
//                               0.9, // Take the full width available
//                           fit: BoxFit.contain,
//                           imageUrl: localImagePath,
//                           placeholder: (context, url) => Image.network(
//                             ServerConfig.defaultProductImage,
//                             fit: BoxFit.contain,
//                           ),
//                           errorWidget: (context, url, error) => Image.network(
//                             ServerConfig.defaultProductImage,
//                             fit: BoxFit.contain,
//                           ),
//                         );
//                       },
//                     );
//                   }).toList(),
//                 ),
//               // Render single image if there's only one image
//               if ((prodImages).where((image) => image.isNotEmpty).length == 1)
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//                   child: CachedNetworkImage(
//                     height: screenHeight * 0.4, // Adjust as needed
//                     width: double.infinity, // Take the full width available
//                     fit: BoxFit.contain,
//                     imageUrl: '${ServerConfig.uploads}${prodImages.first}',
//                     placeholder: (context, url) => Image.network(
//                       ServerConfig.defaultProductImage,
//                       fit: BoxFit.contain,
//                     ),
//                     errorWidget: (context, url, error) => Image.network(
//                       ServerConfig.defaultProductImage,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               // Render no image or placeholder if there are no images
//               if ((prodImages).where((image) => image.isNotEmpty).isEmpty)
//                 Image.network(
//                   ServerConfig.defaultProductImage,
//                   fit: BoxFit.fill,
//                 ),
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(
//                           left: screenWidth * 0.04,
//                           right: screenWidth * 0.04,
//                         ),
//                         child: Text(
//                           productName.length > 21
//                               ? '${productName.substring(0, 17)}...'
//                               : productName,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: screenHeight * 0.017,
//                               color: Colors.grey),
//                         ),
//                         // child: Text(
//                         //   productName,
//                         //   style:
//                         //       const TextStyle(fontSize: 12.0, color: Colors.grey),
//                         // ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: screenHeight * 0.01),
//               Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(
//                       left: screenWidth * 0.04,
//                       right: screenWidth * 0.04,
//                     ),
//                     child: Text(
//                       sellerName.length > 21
//                           ? 'By ${sellerName.substring(0, 21)}...'
//                           : 'By $sellerName',
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           fontSize: screenHeight * 0.017, color: Colors.grey),
//                     ),
//                     // child: Text(
//                     //   'By $sellerName',
//                     //   style: const TextStyle(fontSize: 12.0),
//                     // ),
//                   ),
//                   StarRating(rating: element)
//                 ],
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(
//                       left: screenWidth * 0.04,
//                       right: screenWidth * 0.04,
//                     ),
//                     child: Text(
//                       '\UGX ${NumberFormat('#,###').format(price)}',
//                       style: const TextStyle(
//                           fontSize: 18.0, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.favorite_border_outlined),
//                     onPressed: () {},
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.shopping_basket_outlined),
//                     onPressed: () {
//                       (context);
//                     },
//                   ),
//                   ElevatedButton(
//                     // onPressed: isButtonDisabled
//                     //     ? null
//                     //     : () {
//                     //         setState(() {
//                     //           isButtonDisabled = true; // Disable the button
//                     //         });
//                     //         _showSizeSelectionModal(userName, phone, location,
//                     //             town, price, productId, productName);
//                     //       },
//                     onPressed: () {
//                       _showSizeSelectionModal(userName, phone, location, town,
//                           price, productId, productName);
//                     },
//                     style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.yellow[700]!),
//                       // You can customize other button properties here, like text color, padding, etc.
//                     ),
//                     child: const Text(
//                       'Buy Now',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12, // Font size of the text
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildLoadingIndicator() {
//     return const Center(
//       child: CupertinoActivityIndicator(),
//     );
//   }

//   void _showSizeSelectionModal(
//       String? userName,
//       String? phone,
//       String? location,
//       String? town,
//       int price,
//       int productId,
//       String? productName) async {
//     // Extract the arguments
//     Map<String, dynamic> arguments = {
//       'username': userName,
//       'phoneNo': phone,
//       'location': location,
//       'town': town,
//       'price': price,
//       'productId': productId,
//       'productName': productName
//     };

//     // Get the list of sizes from the arguments
//     List<dynamic> sizes = await fetchSizes(productId);
//     // Call a separate function to handle the modal sheet creation
//     _createSizeSelectionModal(arguments, sizes);
//   }

//   void _createSizeSelectionModal(
//       Map<String, dynamic> arguments, List<dynamic> sizes) {
//     // Now you have access to the arguments and sizes here
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Select the size",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18.0,
//                 ),
//               ),
//               // Use the sizes list to build the modal content
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: sizes.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   // print(sizes);
//                   // String formattedList =
//                   //     sizes.map((e) => e.toString()).join('\n');
//                   try {
//                     return ListTile(
//                       leading: Text(
//                         sizes[index]['name'],
//                         style: const TextStyle(fontSize: 14.0),
//                       ),
//                       onTap: () {
//                         Map<String, dynamic> argumentsWithSize = {
//                           ...arguments, // Include existing arguments
//                           'selectedSize': sizes[index], // Include selected size
//                         };
//                         // Pass the selected size to the billing information screen
//                         _navigateToBillingInformation(
//                             context, argumentsWithSize);
//                       },
//                     );
//                   } catch (e) {
//                     // Handle the case where the index is out of range
//                     return null; // or any other widget you want to display
//                   }
//                   //Map<String, dynamic> size = sizes[index];
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _navigateToBillingInformation(
//       BuildContext context, Map<String, dynamic> arguments) {
//     Navigator.pushNamed(
//       context,
//       '/billing-information',
//       arguments: arguments,
//     );
//   }
// }

// class BillingInformationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Extract the arguments passed to this screen
//     final Map<String, dynamic> arguments =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

//     // Access the selected size from the arguments map
//     final selectedSize = arguments['selectedSize'];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Billing Information'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Selected Size: ${selectedSize['name']}'),
//             // Other billing information widgets can be added here
//           ],
//         ),
//       ),
//     );
//   }
// }

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String subcatName = '';
  final bool _isFirstLoadRunning = false;
  late int subCatID; // Declare subCatID as late

  final String sizeIdAction = "getProductSizes";

  String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
  String emptyStateMessage = "";
  String emptyStateAction = "";
  List? ourHomeList;
  List sellerDetails = [];
  List subCatsShown = [];
  List productsShown = [];
  List? subcatList = [];

// Maintain the current category

  // late ScrollController _controller;

  late List filteredSubCatProductsList;
  List<dynamic> sizes = [];
  List<String> sizeNames = []; // List to store size names
  Map? home;
  Map? subcats;
  late List<Product> products; // List to store products
  bool noData = false;
  // late int supplierID;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _fetchSubcategoryData(); // Fetch subcategory data when the dependencies change
  // }

  // void _fetchSubcategoryData() {
  //   final Map<String, dynamic> args =
  //       ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  //   subCatID = args['subCatID'] ??
  //       0; // Initialize subCatID with a default value or handle null case
  //   subcatName = args['subCatName'] ?? "";
  //   _fetchContentData(subCatID); // Fetch product data based on subcategory ID
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _controller.addListener(_scrollListener);
  //   final sellerRatingsProvider =
  //       Provider.of<SellerRatingsProvider>(context, listen: false);
  //   sellerRatingsProvider.fetchSellerRatingsData();
  //   final sellerProvider =
  //       Provider.of<SellerDataProvider>(context, listen: false);
  //   sellerProvider.fetchSellersData();
  //   final usersProvider = Provider.of<UserDataProvider>(context, listen: false);
  //   usersProvider.fetchUsersData();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _controller.addListener(_scrollListener);
  //   _fetchSubcategoryData();
  // }

  // void _fetchSubcategoryData() async {
  //   final Map<String, dynamic> args =
  //       ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  //   subCatID = args['subCatID'] ?? 0;
  //   subcatName = args['subCatName'] ?? "";

  //   await _fetchContentData(subCatID);
  // }

  @override
  void initState() {
    super.initState();
    final sellerRatingsProvider =
        Provider.of<SellerRatingsProvider>(context, listen: false);
    sellerRatingsProvider.fetchSellerRatingsData();
    final sellerProvider =
        Provider.of<SellerDataProvider>(context, listen: false);
    sellerProvider.fetchSellersData();
    final usersProvider = Provider.of<UserDataProvider>(context, listen: false);
    usersProvider.fetchUsersData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchSubcategoryData(); // Fetch subcategory data when the dependencies change
  }

  void _fetchSubcategoryData() {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    subCatID = args['subCatID'] ??
        0; // Initialize subCatID with a default value or handle null case
    subcatName = args['subCatName'] ?? "";
  }

  // Future<void> _fetchContentData(int subcatId) async {
  //   if (_isFirstLoadRunning) return;

  //   setState(() {
  //     _isFirstLoadRunning = true;
  //   });
  //   try {
  //     String url = Platform.isAndroid
  //         ? '$_postPhoneCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subcatId&page=$_page'
  //         : '$_postCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subcatId&page=$_page';
  //     final res = await http.get(Uri.parse(url));
  //     if (res.statusCode == 200) {
  //       final List<dynamic> newData = json.decode(res.body);
  //       if (mounted) {
  //         setState(() {
  //           displayedProducts = newData;
  //           _isFirstLoadRunning = false;
  //           _page++;
  //         });
  //       }
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (error) {
  //     setState(() {
  //       _isFirstLoadRunning = false;
  //     });
  //     rethrow;
  //   } finally {
  //     setState(() {
  //       _isFirstLoadRunning = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subcatName),
      ),
      body: _isFirstLoadRunning
          ? Center(child: buildLoadingIndicator())
          : ProductData(subCatID),
    );
  }
}

class ProductData extends StatefulWidget {
  final int subcatID;

  const ProductData(this.subcatID, {super.key});

  @override
  State<ProductData> createState() => _ProductDataState();
}

class _ProductDataState extends State<ProductData> {
  bool _isFirstLoadRunning = false;
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String sizeIdAction = "getProductSizes";
  final ScrollController _controller = ScrollController();
  final String contentAction = "getProductsForSubCategory";
  int _page = 1;
  late List displayedProducts = [];
  bool _isLoadMoreRunning = false;
  late int subCatID; // Declare subCatID as late
  bool noData = false;
  //bool isButtonDisabled = true;
  late int supplierID;

  List<dynamic> sizes = [];
  List<String> sizeNames = []; // List to store size names

  String? userName;
  String? userPhone;
  String? location;
  String? town;
  String? previousRoute;

  @override
  void initState() {
    super.initState();
    _fetchContentData(widget.subcatID);
    _controller.addListener(_scrollListener);
  }

  Future<void> _fetchContentData(int subcatId) async {
    if (_isFirstLoadRunning) return;

    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subcatId&page=$_page'
          : '$_postCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subcatId&page=$_page';
      print(url);
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final List<dynamic> newData = json.decode(res.body);
        if (mounted) {
          setState(() {
            displayedProducts = newData;
            _isFirstLoadRunning = false;
            _page++;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      setState(() {
        _isFirstLoadRunning = false;
      });
      rethrow;
    } finally {
      setState(() {
        _isFirstLoadRunning = false;
      });
    }
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      fetchMoreData();
    }
  }

  Future<void> fetchMoreData() async {
    if (_isLoadMoreRunning || noData) return;
    setState(() {
      _isLoadMoreRunning = true;
    });

    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page'
          : '$_postCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page';
      print(url);
      final res = await http.get(Uri.parse(url));
      final List fetchedData = json.decode(res.body);

      if (fetchedData.isNotEmpty && res.statusCode == 200) {
        // Keep the existing data and simply add more data to it.
        displayedProducts.addAll(fetchedData);
        _isLoadMoreRunning = false;
        _page++;
      } else {
        setState(() {
          noData = true;
        });
      }
    } catch (error) {
      setState(() {
        _isLoadMoreRunning = false;
      });
      rethrow;
    } finally {
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer3<SellerRatingsProvider, SellerDataProvider,
        UserDataProvider>(
      builder: (context, sellerRatingsProvider, sellerProvider, usersProvider,
          child) {
        return SingleChildScrollView(
            child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  if (displayedProducts.isNotEmpty || displayedProducts != null)
                    SizedBox(
                      height: screenHeight,
                      child: ListView.builder(
                        controller: _controller,
                        itemCount: displayedProducts.isNotEmpty
                            ? displayedProducts.length + 1
                            : 1, // Add 1 for potential error message
                        itemBuilder: (BuildContext context, int indexing) {
                          try {
                            if (displayedProducts.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Container(
                                      height: screenHeight,
                                      color: Colors.black.withOpacity(
                                          0.1), // Semi-transparent black background
                                      child: const Center(
                                        child:
                                            CupertinoActivityIndicator(), // Loading indicator widget
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (indexing < displayedProducts.length) {
                              Map subcatsProdMap =
                                  displayedProducts.elementAt(indexing);
                              Map subcategoryProductsMap =
                                  subcatsProdMap['product'];

                              Map ratingMap = subcatsProdMap['rating'];
                              double element = (ratingMap['averageratings'] ??
                                      0)
                                  .toDouble(); // Default to 0 if not present
                              int price = int.parse(
                                  subcategoryProductsMap.values.elementAt(3));
                              String sellerName =
                                  subcategoryProductsMap.values.elementAt(1);
                              String productName =
                                  subcategoryProductsMap.values.elementAt(2);
                              int productId = int.parse(
                                  subcategoryProductsMap.values.elementAt(0));
                              int productIndex = indexing;
                              List<String> prodImages = [];
                              for (var i = 4; i < 7; i++) {
                                var image =
                                    subcategoryProductsMap.values.elementAt(i);
                                if (image != null &&
                                    image.toString().isNotEmpty) {
                                  prodImages.add('$image');
                                }
                              }
                              return Column(
                                children: [
                                  cardData(
                                    screenWidth,
                                    screenHeight,
                                    prodImages,
                                    context,
                                    productName,
                                    productId,
                                    price,
                                    sellerName,
                                    element,
                                    // userName,
                                    // userPhone,
                                    // location,
                                    productIndex,
                                    // town
                                  ),
                                  displayedProducts.length == indexing &&
                                          _isFirstLoadRunning
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: Center(
                                                child: buildLoadingIndicator(),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  displayedProducts.length == indexing &&
                                          noData == true
                                      ? const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                child: Text(
                                                    'You have loaded all the data.')),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              );
                            } else {
                              // Loading indicator
                              return const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Text(
                                          'You have loaded all products.')),
                                ],
                              );
                            }
                          } catch (e) {
                            // Handle the case where the index is out of range
                            return null; // or any other widget you want to display
                          }
                        },
                      ),
                    )
                  else
                    SizedBox(
                      height: screenHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Testing",
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Testing",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue, // Add your desired color
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // saleProductDetails(screenHeight, sellerRatingsProvider,
            //     sellerProvider, usersProvider, screenWidth),
          ],
        ));
      },
    );
  }

  // Center saleProductDetails(
  //     double screenHeight,
  //     SellerRatingsProvider sellerRatingsProvider,
  //     SellerDataProvider sellerProvider,
  //     UserDataProvider usersProvider,
  //     double screenWidth) {
  //   var userName = usersProvider.users?.name;
  //   var phone = usersProvider.users?.phone;
  //   var location = usersProvider.users?.location;
  //   var town = usersProvider.users?.town;

  //   return Center(
  //     child: Column(
  //       children: [
  //         if (displayedProducts.isNotEmpty || displayedProducts != null)
  //           SizedBox(
  //             height: screenHeight,
  //             child: ListView.builder(
  //               controller: _controller,
  //               itemCount: displayedProducts.isNotEmpty
  //                   ? displayedProducts.length + 1
  //                   : 1, // Add 1 for potential error message
  //               itemBuilder: (BuildContext context, int indexing) {
  //                 try {
  //                   if (displayedProducts.isEmpty) {
  //                     return Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Center(
  //                           child: Container(
  //                             height: screenHeight,
  //                             color: Colors.black.withOpacity(
  //                                 0.1), // Semi-transparent black background
  //                             child: const Center(
  //                               child:
  //                                   CupertinoActivityIndicator(), // Loading indicator widget
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     );
  //                   } else if (indexing < displayedProducts.length) {
  //                     // double element =
  //                     //     sellerRatingsProvider.sellerRatings!.sellerStars;

  //                     Map subcategoryProductsMap =
  //                         displayedProducts.elementAt(indexing);

  //                     int price =
  //                         int.parse(subcategoryProductsMap.values.elementAt(3));
  //                     String sellerName =
  //                         subcategoryProductsMap.values.elementAt(1);
  //                     supplierID = subcategoryProductsMap.values.elementAt(1);

  //                     String productName =
  //                         subcategoryProductsMap.values.elementAt(2);
  //                     int productId =
  //                         int.parse(subcategoryProductsMap.values.elementAt(0));
  //                     int productIndex = indexing;

  //                     List<String> prodImages = [];
  //                     for (var i = 4; i < 7; i++) {
  //                       var image = subcategoryProductsMap.values.elementAt(i);
  //                       if (image != null && image.toString().isNotEmpty) {
  //                         prodImages.add('$image');
  //                       }
  //                     }
  //                     return Column(
  //                       children: [
  //                         cardData(
  //                           screenWidth,
  //                           screenHeight,
  //                           prodImages,
  //                           context,
  //                           productName,
  //                           productId,
  //                           price,
  //                           sellerName,
  //                           //element,
  //                           // userName,
  //                           // phone,
  //                           // location,
  //                           productIndex,
  //                           //town
  //                         ),
  //                         displayedProducts.length == indexing &&
  //                                 _isFirstLoadRunning
  //                             ? Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(
  //                                         top: 5, bottom: 5),
  //                                     child: Center(
  //                                       child: buildLoadingIndicator(),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               )
  //                             : const SizedBox(),
  //                         displayedProducts.length == indexing && noData == true
  //                             ? const Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Padding(
  //                                       padding:
  //                                           EdgeInsets.only(top: 5, bottom: 5),
  //                                       child: Text(
  //                                           'You have loaded all the data.')),
  //                                 ],
  //                               )
  //                             : const SizedBox(),
  //                       ],
  //                     );
  //                   } else {
  //                     // Loading indicator
  //                     return const Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Padding(
  //                             padding: EdgeInsets.only(top: 5, bottom: 5),
  //                             child: Text('You have loaded all products.')),
  //                       ],
  //                     );
  //                   }
  //                 } catch (e) {
  //                   // Handle the case where the index is out of range
  //                   return null; // or any other widget you want to display
  //                 }
  //               },
  //             ),
  //           )
  //         else
  //           SizedBox(
  //             height: screenHeight,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 const Text(
  //                   "Testing",
  //                   style: TextStyle(fontSize: 18),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 GestureDetector(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text(
  //                     "Testing",
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       color: Colors.blue, // Add your desired color
  //                       decoration: TextDecoration.underline,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Padding cardData(
    double screenWidth,
    double screenHeight,
    List<String> prodImages,
    BuildContext context,
    String productName,
    int productId,
    int price,
    String sellerName,
    double element,
    // String? userName,
    // String? userPhone,
    // String? location,
    int? productIndex,
    // String? town
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(screenWidth * 0.01, screenHeight * 0.01,
          screenWidth * 0.01, screenHeight * 0.0),
      child: Container(
        color: Colors.white,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              if ((prodImages).where((image) => image.isNotEmpty).length > 1)
                CarouselSlider(
                  options: CarouselOptions(height: screenHeight * 0.45),
                  items:
                      (prodImages).where((image) => image.isNotEmpty).map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        // Check if the image is a network image or a local image
                        String localImagePath = '${ServerConfig.uploads}$i';
                        // Local image
                        return CachedNetworkImage(
                          height: screenHeight * 1.0, // Adjust as needed
                          width: screenWidth *
                              0.9, // Take the full width available
                          fit: BoxFit.contain,
                          imageUrl: localImagePath,
                          placeholder: (context, url) => Image.network(
                            ServerConfig.defaultProductImage,
                            fit: BoxFit.contain,
                          ),
                          errorWidget: (context, url, error) => Image.network(
                            ServerConfig.defaultProductImage,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              // Render single image if there's only one image
              if ((prodImages).where((image) => image.isNotEmpty).length == 1)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: CachedNetworkImage(
                    height: screenHeight * 0.4, // Adjust as needed
                    width: double.infinity, // Take the full width available
                    fit: BoxFit.contain,
                    imageUrl: '${ServerConfig.uploads}${prodImages.first}',
                    placeholder: (context, url) => Image.network(
                      ServerConfig.defaultProductImage,
                      fit: BoxFit.contain,
                    ),
                    errorWidget: (context, url, error) => Image.network(
                      ServerConfig.defaultProductImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              // Render no image or placeholder if there are no images
              if ((prodImages).where((image) => image.isNotEmpty).isEmpty)
                Image.network(
                  ServerConfig.defaultProductImage,
                  fit: BoxFit.fill,
                ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.04,
                          right: screenWidth * 0.04,
                        ),
                        child: Text(
                          productName.length > 21
                              ? '${productName.substring(0, 17)}...'
                              : productName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: screenHeight * 0.017,
                              color: Colors.grey),
                        ),
                        // child: Text(
                        //   productName,
                        //   style:
                        //       const TextStyle(fontSize: 12.0, color: Colors.grey),
                        // ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.04,
                      right: screenWidth * 0.04,
                    ),
                    child: Text(
                      sellerName.length > 21
                          ? 'By ${sellerName.substring(0, 21)}...'
                          : 'By $sellerName',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: screenHeight * 0.017, color: Colors.grey),
                    ),
                    // child: Text(
                    //   'By $sellerName',
                    //   style: const TextStyle(fontSize: 12.0),
                    // ),
                  ),
                  StarRating(rating: element)
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.04,
                      right: screenWidth * 0.04,
                    ),
                    child: Text(
                      '\UGX ${NumberFormat('#,###').format(price)}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_basket_outlined),
                    onPressed: () {
                      (context);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showSizeSelectionModal(userName, userPhone, location,
                          town, price, productId, productName);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.yellow[700]!),
                      // You can customize other button properties here, like text color, padding, etc.
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12, // Font size of the text
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildLoadingIndicator() {
  //   return const Center(
  //     child: CupertinoActivityIndicator(),
  //   );
  // }

  // void _navigateToBillingInformation(
  //     BuildContext context, Map<String, dynamic> arguments) {
  //   Navigator.pushNamed(
  //     context,
  //     '/billing-information',
  //     arguments: arguments,
  //   );
  // }

// Inside an async function
  void fetchProfileInfo() async {
    // Call fetchUserProfile
    Map<String, dynamic> userProfile = await UserProfileUtil.fetchUserProfile();
    setState(() {
      userName = userProfile['name'] ?? 'Unknown';
      userPhone = userProfile['phone_number'] ?? 'Unknown';
      location = userProfile['location'] ?? 'Unknown';
      town = userProfile['town'] ?? 'Unknown';
    });
  }

  void _showSizeSelectionModal(
      String? userName,
      String? userPhone,
      String? location,
      String? town,
      int price,
      int productId,
      String? productName) async {
    // Extract the arguments
    Map<String, dynamic> arguments = {
      'username': userName,
      'phoneNo': userPhone,
      'location': location,
      'town': town,
      'price': price,
      'productId': productId,
      'productName': productName
    };

    // Get the list of sizes from the arguments
    List<dynamic> sizes = await fetchSizes(productId);
    // Call a separate function to handle the modal sheet creation
    _createSizeSelectionModal(arguments, sizes);
  }

  void _createSizeSelectionModal(
      Map<String, dynamic> arguments, List<dynamic> sizes) {
    // Now you have access to the arguments and sizes here
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Select the size",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                // Use the sizes list to build the modal content
                ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable scrolling for the inner ListView
                  itemCount: sizes.length,
                  itemBuilder: (BuildContext context, int index) {
                    // print(sizes);
                    // String formattedList =
                    //     sizes.map((e) => e.toString()).join('\n');
                    final authProvider =
                        Provider.of<AuthState>(context, listen: false);
                    try {
                      return ListTile(
                        leading: Text(
                          sizes[index]['name'],
                          style: const TextStyle(fontSize: 14.0),
                        ),

                        onTap: () {
                          // Check if the user is logged in
                          if (authProvider.isLoggedIn) {
                            Map<String, dynamic> argumentsWithSize = {
                              ...arguments, // Include existing arguments
                              'selectedSize':
                                  sizes[index], // Include selected size
                            };
                            // Pass the selected size to the billing information screen
                            _navigateToBillingInformation(
                                context, argumentsWithSize);
                          } else {
                            // User is not logged in, show a dialog or navigate to the login page
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Login Required'),
                                  content: const Text(
                                      'You need to login to proceed.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        // Navigate to the login page
                                        // NavigationService.navigateToLogin(
                                        //     context);

                                        NavigationService.navigateToLogin(
                                            context);

                                        // NavigationService.navigateToLogin(
                                        //     context,
                                        //     ModalRoute.of(context)
                                        //             ?.settings
                                        //             .name ??
                                        //         '');

                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => SignInForm(
                                        //       onVerificationSuccess: (int) {},
                                        //     ), // Replace LoginPage with your login page
                                        //   ),
                                        // );
                                      },
                                      child: const Text('Login'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },

                        // onTap: () {
                        //   Map<String, dynamic> argumentsWithSize = {
                        //     ...arguments, // Include existing arguments
                        //     'selectedSize':
                        //         sizes[index], // Include selected size
                        //   };
                        //   // Pass the selected size to the billing information screen
                        //   _navigateToBillingInformation(
                        //       context, argumentsWithSize);
                        // },
                      );
                    } catch (e) {
                      // Handle the case where the index is out of range
                      return null; // or any other widget you want to display
                    }
                    //Map<String, dynamic> size = sizes[index];
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<List<dynamic>> fetchSizes(productId) async {
  //   // Check if already loading
  //   if (_isFirstLoadRunning) return sizeNames;

  //   setState(() {
  //     _isFirstLoadRunning = true;
  //   });

  //   try {
  //     String url = Platform.isAndroid
  //         ? '$_postPhoneCatUrl/get_product_sizes.php?action=$sizeIdAction&productId=$productId'
  //         : '$_postCatUrl/get_product_sizes.php?action=$sizeIdAction&productId=$productId';
  //     print(url);
  //     final res = await http.get(Uri.parse(url));
  //     if (res.statusCode == 200) {
  //       List<dynamic> sizesList = json.decode(res.body);
  //       // for (int i = 0; i < sizesList.length; i++) {
  //       //   Map sizedetails = sizesList.elementAt(i);
  //       //   int sizeID = sizedetails['size_id'];
  //       //   String sizeName = sizedetails['name'];
  //       //   sizes.add({'size_id': sizeID, 'name': sizeName});
  //       // }

  //       // List sizes = [];
  //       for (int i = 0; i < sizesList.length; i++) {
  //         Map sizedetails = sizesList.elementAt(i);
  //         int sizeID = int.parse(sizedetails['size_id']);
  //         String sizeName = sizedetails['name'];
  //         sizes.add({'size_id': sizeID, 'name': sizeName});
  //       }
  //       // for (int i = 0; i < sizesList.length; i++) {
  //       //   Map<String, dynamic> sizeDetails = sizesList[i];
  //       //   // Extract size name from the map and add it to the list
  //       //   String sizeName = sizeDetails['name'];
  //       //   sizeNames.add(sizeName);
  //       // }
  //     } else {
  //       throw Exception('Failed to load sizes');
  //     }
  //   } catch (error) {
  //     rethrow;
  //   }

  //   // Set isFirstLoadRunning to false after fetching sizes
  //   setState(() {
  //     _isFirstLoadRunning = false;
  //   });

  //   return sizes;
  // }

  Future<List<dynamic>> fetchSizes(productId) async {
    print(productId);
    // Check if already loading
    if (_isFirstLoadRunning) return sizeNames;

    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_product_sizes.php?action=$sizeIdAction&productId=$productId'
          : '$_postCatUrl/get_product_sizes.php?action=$sizeIdAction&productId=$productId';
      print(url);
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        List<dynamic> sizesList = json.decode(res.body);
        for (int i = 0; i < sizesList.length; i++) {
          Map sizedetails = sizesList.elementAt(i);
          String sizeID = sizedetails['size_id'];
          String sizeName = sizedetails['name'];
          sizes.add({'size_id': sizeID, 'name': sizeName});
        }
      } else {
        throw Exception('Failed to load sizes');
      }
    } catch (error) {
      rethrow;
    }

    // Set isFirstLoadRunning to false after fetching sizes
    setState(() {
      _isFirstLoadRunning = false;
    });

    return sizes;
  }

  void _navigateToBillingInformation(
      BuildContext context, Map<String, dynamic> arguments) {
    Navigator.pushNamed(
      context,
      '/billing-information',
      arguments: arguments,
    );
  }
}

Widget buildLoadingIndicator() {
  return Container(
    color: Colors.black.withOpacity(0.1), // Semi-transparent black background
    child: const Center(
      child: CupertinoActivityIndicator(), // Loading indicator widget
    ),
  );
}
