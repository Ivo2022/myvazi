import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myvazi/src/services/rating.dart';
import 'package:myvazi/src/utils/providers.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:provider/provider.dart';

class ProductDetailsDisplay extends StatefulWidget {
  const ProductDetailsDisplay({super.key});

  @override
  State<ProductDetailsDisplay> createState() => _ProductDetailsDisplayState();
}

class _ProductDetailsDisplayState extends State<ProductDetailsDisplay> {
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

  late int productID;

  @override
  void initState() {
    super.initState();
    final sellerRatingsProvider =
        Provider.of<SellerRatingsProvider>(context, listen: false);
    sellerRatingsProvider.fetchSellerRatingsData();
    final sellerProvider =
        Provider.of<SellerDataProvider>(context, listen: false);
    //sellerProvider.fetchSellersData();
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
          ? '$_postPhoneCatUrl/get_product_view_subcats_products.php?action=$contentAction&productID=$productID'
          : '$_postCatUrl/get_product_view_subcats_products.php?action=$contentAction&productID=$productID';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final List<dynamic> newData = json.decode(res.body);
        setState(() {
          displayedProducts = newData;
          print(displayedProducts);
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

        // List sizes = [];
        for (int i = 0; i < sizesList.length; i++) {
          Map sizedetails = sizesList.elementAt(i);
          int sizeID = int.parse(sizedetails['size_id']);
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the passed arguments
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    productID = args['productID'];
    _fetchContentData(productID);
  }

  void displayEmptyState() {
    // For example, set a message and actions
    filteredSubCatProductsList = []; // Example: Assign an empty list
    emptyStateMessage = "No products found";
    emptyStateAction = "Explore other subcategories";
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
                itemCount: displayedProducts.isNotEmpty
                    ? displayedProducts.length + 1
                    : 1,
                itemBuilder: (BuildContext context, int indexing) {
                  try {
                    double element =
                        sellerRatingsProvider.sellerRatings!.sellerStars;

                    Map subcategoryProductsMap =
                        displayedProducts.elementAt(indexing);

                    int price =
                        int.parse(subcategoryProductsMap.values.elementAt(3));
                    String sellerName =
                        subcategoryProductsMap.values.elementAt(1);
                    String productName =
                        subcategoryProductsMap.values.elementAt(2);
                    int productId =
                        int.parse(subcategoryProductsMap.values.elementAt(0));
                    int productIndex = indexing;

                    List<String> prodImages = [];
                    for (var i = 4; i < 7; i++) {
                      var image = subcategoryProductsMap.values.elementAt(i);
                      if (image != null && image.toString().isNotEmpty) {
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
                            userName,
                            phone,
                            location,
                            productIndex,
                            town)
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
            if ((prodImages).where((image) => image.isNotEmpty).length > 1)
              CarouselSlider(
                options: CarouselOptions(height: screenHeight * 0.45),
                items: (prodImages).where((image) => image.isNotEmpty).map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      // Check if the image is a network image or a local image
                      String localImagePath = '${ServerConfig.uploads}$i';
                      // Local image
                      return CachedNetworkImage(
                        height: screenHeight * 1.0, // Adjust as needed
                        width:
                            screenWidth * 0.9, // Take the full width available
                        fit: BoxFit.fill,
                        imageUrl: localImagePath,
                        placeholder: (context, url) => Image.network(
                          ServerConfig.defaultProductImage,
                          fit: BoxFit.fill,
                        ),
                        errorWidget: (context, url, error) => Image.network(
                          ServerConfig.defaultProductImage,
                          fit: BoxFit.fill,
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
                  fit: BoxFit.fill,
                  imageUrl: '${ServerConfig.uploads}${prodImages.first}',
                  placeholder: (context, url) => Image.network(
                    ServerConfig.defaultProductImage,
                    fit: BoxFit.fill,
                  ),
                  errorWidget: (context, url, error) => Image.network(
                    ServerConfig.defaultProductImage,
                    fit: BoxFit.fill,
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
                  onPressed: () {},
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
    );
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  // void _navigateToBillingInformation(
  //     BuildContext context, Map<String, dynamic> arguments) {
  //   Navigator.pushNamed(
  //     context,
  //     '/billing-information',
  //     arguments: arguments,
  //   );
  // }
}
