import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myvazi/src/services/rating.dart';
import 'package:myvazi/src/utils/providers.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String contentAction = "getProductsForSubCategory";
  final String sizeIdAction = "getProductSizes";

  String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
  String emptyStateMessage = "";
  String emptyStateAction = "";
  String subcatName = '';

  List? ourHomeList;
  List sellerDetails = [];
  List subCatsShown = [];
  List productsShown = [];
  List? subcatList = [];

  Map? home;
  Map? subcats;

  bool noData = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  //bool isButtonDisabled = true;

  int _page = 1;

// Maintain the current category

  late List subcategoryProductsList = [];
  late List filteredSubCatProducts = [];
  late ScrollController _controller;
  late List filteredSubCatProductsList;
  late List displayedProducts;
  List<dynamic> sizes = [];
  List<String> sizeNames = []; // List to store size names

  late int subCatID;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    // Attach listener for scroll events
    _controller.addListener(_scrollListener);

    final sellerRatingsProvider =
        Provider.of<SellerRatingsProvider>(context, listen: false);
    sellerRatingsProvider.fetchSellerRatingsData();
    final sellerProvider =
        Provider.of<SellerDataProvider>(context, listen: false);
    sellerProvider.fetchSellersData();
    final usersProvider = Provider.of<UserDataProvider>(context, listen: false);
    usersProvider.fetchUsersData();
  }

  Future<List> _fetchContentData(subcatId) async {
    if (_isFirstLoadRunning) return [];

    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subcatId&page=$_page'
          : '$_postCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subcatId&page=$_page';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final List<dynamic> newData = json.decode(res.body);
        setState(() {
          displayedProducts = newData;
          _isFirstLoadRunning = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      setState(() {
        _isFirstLoadRunning = false;
      });
      rethrow;
    }
    return displayedProducts;
  }

  Future<List> fetchMoreData(int subCatID, int page) async {
    if (_isLoadMoreRunning) return [];

    _isLoadMoreRunning = true;

    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page'
          : '$_postCatUrl/get_product_view_subcats_products.php?action=$contentAction&subCatID=$subCatID&page=$_page';
      final res = await http.get(Uri.parse(url));
      final List fetchedData = json.decode(res.body);

      if (fetchedData.isNotEmpty && res.statusCode == 200) {
        // Keep the existing data and simply add more data to it.
        displayedProducts.addAll(fetchedData);
        _isLoadMoreRunning = false;
        _page++;
      } else {
        noData = true;
      }
    } catch (error) {
      _isLoadMoreRunning = false;
      rethrow;
    }
    return displayedProducts;
  }

  Future<List<dynamic>> fetchSizes(productId) async {
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
        // for (int i = 0; i < sizesList.length; i++) {
        //   Map sizedetails = sizesList.elementAt(i);
        //   int sizeID = sizedetails['size_id'];
        //   String sizeName = sizedetails['name'];
        //   sizes.add({'size_id': sizeID, 'name': sizeName});
        // }

        // List sizes = [];
        for (int i = 0; i < sizesList.length; i++) {
          Map sizedetails = sizesList.elementAt(i);
          int sizeID = sizedetails['size_id'];
          String sizeName = sizedetails['name'];
          sizes.add({'size_id': sizeID, 'name': sizeName});
        }
        // for (int i = 0; i < sizesList.length; i++) {
        //   Map<String, dynamic> sizeDetails = sizesList[i];
        //   // Extract size name from the map and add it to the list
        //   String sizeName = sizeDetails['name'];
        //   sizeNames.add(sizeName);
        // }
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // // Retrieve data from the previous screen
    // Map<String, dynamic>? arguments =
    //     (ModalRoute.of(context)!.settings.arguments ?? {})
    //         as Map<String, dynamic>?;

    // Retrieve the passed arguments
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    subCatID = args['subCatID'];

    subcatName = args['subCatName'] ?? "";
    _fetchContentData(subCatID);
    // if (arguments.isNotEmpty) {
    //   if (arguments['subCatProducts'] is List<dynamic>) {
    //     final List subCatProducts = arguments['subCatProducts'] ?? [];
    //     print(subCatProducts);
    //     // Filter products based on the selected subcategory
    //     filteredSubCatProducts = subCatProducts
    //         .where((product) => product['subcat_name'] == subcatName)
    //         .toList();
    //     // print(filteredSubCatProducts);
    //     if (filteredSubCatProducts.isNotEmpty) {
    //       Map filteredSubCatProductsMap = filteredSubCatProducts.first;
    //       filteredSubCatProductsList =
    //           filteredSubCatProductsMap.values.elementAt(2);

    //       // Ensure filteredSubCatProductsList is not null
    //     } else {
    //       // Handle the case where filteredSubCatProductsList is null
    //       displayEmptyState();
    //       // Initialize displayedProducts with an empty list or handle it as needed
    //       displayedProducts = [];
    //     }

    //     // Initialize displayedProducts with an initial set of items
    //     setState(() {
    //       _isFirstLoadRunning = true;

    //       // Ensure that filteredSubCatProductsList is not null
    //       if (filteredSubCatProductsList != null) {
    //         displayedProducts = List.from(filteredSubCatProductsList.take(10));
    //         displayedProducts.sort((a, b) {
    //           String? timeA = a['date_of_upload'];
    //           String? timeB = b['date_of_upload'];

    //           //print('timeA: $timeA, timeB: $timeB');

    //           if (timeA != null && timeB != null) {
    //             return timeB.compareTo(timeA);
    //           }

    //           return 0;
    //         });
    //       } else {
    //         // Handle the case where filteredSubCatProductsList is null
    //         displayEmptyState();
    //       }
    //       _isFirstLoadRunning = false;
    //     });
    //   } else if (arguments['subCatProducts'] is String) {
    //     // Handle the case where 'subCatProducts' is a string
    //     print("It is a String!");
    //   }
    // }
  }

  void displayEmptyState() {
    // For example, set a message and actions
    filteredSubCatProductsList = []; // Example: Assign an empty list
    emptyStateMessage = "No products found";
    emptyStateAction = "Explore other subcategories";
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      fetchMoreData(subCatID, _page);
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
    final sellerRatingsProvider = Provider.of<SellerRatingsProvider>(context);
    final sellerProvider = Provider.of<SellerDataProvider>(context);
    final usersProvider = Provider.of<UserDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(subcatName),
      ),
      body: _isFirstLoadRunning
          ? Center(
              child: buildLoadingIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
              children: [
                saleProductDetails(screenHeight, sellerRatingsProvider,
                    sellerProvider, usersProvider, screenWidth),
              ],
            )),
    );
  }

  Center saleProductDetails(
      double screenHeight,
      SellerRatingsProvider sellerRatingsProvider,
      SellerDataProvider sellerProvider,
      UserDataProvider usersProvider,
      double screenWidth) {
    var userName = usersProvider.users?.name;
    var phone = usersProvider.users?.phone;
    var location = usersProvider.users?.location;
    var town = usersProvider.users?.town;

    return Center(
      child: Column(
        children: [
          if (displayedProducts.isNotEmpty)
            SizedBox(
              height: screenHeight,
              child: ListView.builder(
                controller: _controller,
                itemCount: displayedProducts.length,
                itemBuilder: (BuildContext context, int indexing) {
                  try {
                    double element =
                        sellerRatingsProvider.sellerRatings!.sellerStars;

                    Map subcategoryProductsMap =
                        displayedProducts.elementAt(indexing);

                    int price = subcategoryProductsMap.values.elementAt(3);
                    String sellerName =
                        subcategoryProductsMap.values.elementAt(1);
                    String productName =
                        subcategoryProductsMap.values.elementAt(2);
                    int productId = subcategoryProductsMap.values.elementAt(0);
                    int productIndex = indexing;

                    // List<String> prodImages = [];
                    // for (var i = 4; i < 7; i++) {
                    //   if (subcategoryProductsMap.values.elementAt(i) != null &&
                    //       subcategoryProductsMap.values
                    //           .elementAt(i)
                    //           .toString()
                    //           .isNotEmpty) {
                    //     prodImages.add(
                    //         '${subcategoryProductsMap.values.elementAt(i)}');
                    //   }
                    // }

                    List<String> prodImages = [];
                    for (var i = 4; i < 7; i++) {
                      if (subcategoryProductsMap.values.elementAt(i) != null &&
                          subcategoryProductsMap.values
                              .elementAt(i)
                              .toString()
                              .isNotEmpty) {
                        prodImages.add(
                            '${subcategoryProductsMap.values.elementAt(i)}');
                      }
                    }

                    // List<String> prodImages = [];
                    // for (var i = 4; i < 7; i++) {
                    //   if (subcategoryProductsMap.values
                    //       .elementAt(i)
                    //       .toString()
                    //       .contains('http')) {
                    //     prodImages
                    //         .add(subcategoryProductsMap.values.elementAt(i));
                    //   }
                    // }
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
                            userName,
                            phone,
                            location,
                            productIndex,
                            town),
                        displayedProducts.length - 1 == indexing &&
                                _isLoadMoreRunning == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                        displayedProducts.length - 1 == indexing &&
                                noData == true
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Text(
                                          'You have loaded all the data.')),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    );
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
                  Text(
                    emptyStateMessage,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      emptyStateAction,
                      style: const TextStyle(
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
    );
  }

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
      String? userName,
      String? phone,
      String? location,
      int? productIndex,
      String? town) {
    return Padding(
      padding: EdgeInsets.fromLTRB(screenWidth * 0.01, screenHeight * 0.01,
          screenWidth * 0.01, screenHeight * 0.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(height: screenHeight * 0.45),
              items: prodImages.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    // Check if the image is a network image or a local image
                    if (i.toString().contains('http')) {
                      // Network image
                      return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.01),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 201, 137, 137)),
                          child: CachedNetworkImage(
                            height: screenHeight * 9.0,
                            width: screenWidth * 0.9,
                            fit: BoxFit.cover,
                            imageUrl: i,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/default_image.png', // Specify the path to your default image
                              fit: BoxFit.fitWidth,
                            ),
                          ));
                    } else {
                      String localImagePath =
                          '${ServerConfig.baseUrl}${ServerConfig.uploads}$i';
                      // Local image
                      return CachedNetworkImage(
                        height: screenHeight * 9.0, // Adjust as needed
                        width: double.infinity, // Take the full width available
                        fit: BoxFit.cover,
                        imageUrl: i.isNotEmpty
                            ? localImagePath
                            : ServerConfig.defaultImageSquare,
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/default_image.png',
                          fit: BoxFit.fitWidth,
                        ),
                      );

                      // Container(
                      //   margin: EdgeInsets.symmetric(
                      //       horizontal: screenWidth * 0.01),
                      //   decoration: const BoxDecoration(color: Colors.white),
                      //   child: Image.file(
                      //     File(localImagePath),
                      //     height: screenHeight * 9.0,
                      //     width: screenWidth * 0.9,
                      //     fit: BoxFit.cover,
                      //     errorBuilder: (context, error, stackTrace) =>
                      //         Image.asset(
                      //       'assets/images/default_image.png', // Specify the path to your default image
                      //       fit: BoxFit.fitWidth,
                      //     ),
                      //   ),
                      // );
                    }
                  },
                );
              }).toList(),
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
                        productName,
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
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
                    'By $sellerName',
                    style: const TextStyle(fontSize: 12.0),
                  ),
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
                  // onPressed: isButtonDisabled
                  //     ? null
                  //     : () {
                  //         setState(() {
                  //           isButtonDisabled = true; // Disable the button
                  //         });
                  //         _showSizeSelectionModal(userName, phone, location,
                  //             town, price, productId, productName);
                  //       },
                  onPressed: () {
                    _showSizeSelectionModal(userName, phone, location, town,
                        price, productId, productName);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.yellow[700]!),
                    // You can customize other button properties here, like text color, padding, etc.
                  ),
                  child: Text(
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
    );
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _showSizeSelectionModal(
      String? userName,
      String? phone,
      String? location,
      String? town,
      int price,
      int productId,
      String? productName) async {
    // Extract the arguments
    Map<String, dynamic> arguments = {
      'username': userName,
      'phoneNo': phone,
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
        return Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Text(
                "Select the size",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sizes.length,
                  itemBuilder: (BuildContext context, int index) {
                    try {
                      return ListTile(
                        leading: Text(
                          sizes[index]['name'],
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        onTap: () {
                          Map<String, dynamic> argumentsWithSize = {
                            ...arguments, // Include existing arguments
                            'selectedSize':
                                sizes[index], // Include selected size
                          };
                          // Pass the selected size to the billing information screen
                          _navigateToBillingInformation(
                              context, argumentsWithSize);
                        },
                      );
                    } catch (e) {
                      // Handle the case where the index is out of range
                      return null; // or any other widget you want to display
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _showSizeSelectionModal(
  //     BuildContext context,
  //     String? userName,
  //     String? phone,
  //     String? location,
  //     String? town,
  //     int price,
  //     int productId) async {
  //   // Extract the arguments
  //   Map<String, dynamic> arguments = {
  //     'username': userName,
  //     'phoneNo': phone,
  //     'location': location,
  //     'town': town,
  //     'price': price,
  //     'productId': productId
  //   };
  //   // Get the list of sizes from the arguments
  //   sizes = await fetchSizes(productId); // Await the result of fetchSizes

  //   // Call a separate function to handle the modal sheet creation
  //   _createSizeSelectionModal(context, arguments);
  //   print(sizeNames);
  // }

  // void _createSizeSelectionModal(
  //     BuildContext context, Map<String, dynamic> arguments) {
  //   // Use the arguments and create the modal sheet
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: const EdgeInsets.all(12.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const Text(
  //               "Select the size",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 18.0,
  //               ),
  //             ),
  // Generate ListTile widgets dynamically for each size
  // ListView.builder(
  //   shrinkWrap: true,
  //   itemCount: sizeNames.length,
  //   itemBuilder: (BuildContext context, int index) {
  //     try {
  //       print(sizeNames.length);
  //       return ListTile(
  //         leading: Text(
  //           sizeNames.toString(),
  //           style: const TextStyle(fontSize: 14.0),
  //         ),
  //         // onTap: () {
  //         //   // Pass the selected size to the billing information screen
  //         //   _navigateToBillingInformation(context, arguments);
  //         // },
  //       );
  //     } catch (e) {
  //       // Handle the case where the index is out of range
  //       return null; // or any other widget you want to display
  //     }
  //     //Map<String, dynamic> size = sizes[index];
  //   },
  // ),
  //           ],
  //         ),
  //       );
  //     },
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
  void _navigateToBillingInformation(
      BuildContext context, Map<String, dynamic> arguments) {
    Navigator.pushNamed(
      context,
      '/billing-information',
      arguments: arguments,
    );
  }
}

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
