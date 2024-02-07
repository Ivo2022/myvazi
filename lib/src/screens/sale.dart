import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myvazi/src/models/cart_data.dart';
import 'package:myvazi/src/services/rating.dart';
import 'package:myvazi/src/utils/providers.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/widgets/product_view.dart';
import 'package:provider/provider.dart';

class Sale extends StatefulWidget {
  const Sale({super.key});

  @override
  State<Sale> createState() => _SaleState();
}

class _SaleState extends State<Sale> {
  final ShoppingCart cart = ShoppingCart();
  String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String _action = "getMainCategoriesWithProducts";
  final String sizeIdAction = "getProductSizes";

  //final String _action2 = "getAllProductDetails";
  final int _limit = 10;
  int _page = 1;
  bool noData = false;

  List? ourHomeList;
  Map? home;
  Map? subcats;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  dynamic _currentCategory; // Maintain the current category
  List _mainCategoriesData = [];
  // List _subcatList = [];
  int positionedTab = 0;
  int positionedTabb = 0;
  int? hoverPosition;
  int? hoverPositioned;
  List subCatsShown = [];
  List productsShown = [];
  List subCatProducts = [];

  List sellerDetails = [];

  late dynamic _error;

  List? subcatList = [];
  //int currentPage = 1;
  List<dynamic> sizes = [];
  List<String> sizeNames = []; // List to store size names

  Future<List> _firstLoad(
      String action, int category, int subcategory, int page, int limit) async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      if (_currentCategory != subcategory) {
        // Category changed, reset _page to 1
        setState(() {
          _page = 1;
        });
      }
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_maincategories_with_products.php?action=$action&current_page=$page&limit=$limit'
          : '$_postCatUrl/get_maincategories_with_products.php?action=$action&current_page=$page&limit=$limit';

      final res = await http.get(Uri.parse(url));
      setState(() {
        _mainCategoriesData = json.decode(res.body);
        homeData(category, subcategory);
      });
    } catch (err) {
      if (kDebugMode) {
        _error = err.toString();
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });

    return _mainCategoriesData;
  }

  void homeData(int categoryInt, int subcategoryInt) {
    setState(() {
      home = _mainCategoriesData.elementAt(categoryInt);
      subcatList = home!.values.last;
      subcats = subcatList!.elementAt(subcategoryInt);
      subCatProducts = subcats!.values.elementAt(2);
    });
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad(_action, 0, 0, _page, _limit);
    _controller = ScrollController()..addListener(_loadMore);
    _controller.addListener(() {
      if (_controller.position.atEdge == true &&
          _controller.position.pixels != 0) {
        if (_isLoadMoreRunning == false) {
          _loadMore();
        }
      }
    });
    final sellerRatingsProvider =
        Provider.of<SellerRatingsProvider>(context, listen: false);
    sellerRatingsProvider.fetchSellerRatingsData();
    final sellerProvider =
        Provider.of<SellerDataProvider>(context, listen: false);
    sellerProvider.fetchSellersData();
    final usersProvider = Provider.of<UserDataProvider>(context, listen: false);
    usersProvider.fetchUsersData();
  }

  void _loadMore() {
    setState(() {
      _isLoadMoreRunning = true; // Display a progress indicator at the bottom
    });

    _page += 1; // Increment the page for loading more data

    _fetchMoreData(_action, positionedTab, positionedTabb, _page, _limit)
        .then((_) {
      setState(() {
        _isLoadMoreRunning =
            false; // Display a progress indicator at the bottom
      });
    });
  }

  Future<List> _fetchMoreData(
      String action, int category, int subcategory, int page, int limit) async {
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_maincategories_with_products.php?action=$action&current_page=$page&limit=$limit'
          : '$_postCatUrl/get_maincategories_with_products.php?action=$action&current_page=$page&limit=$limit';

      final res = await http.get(Uri.parse(url));
      final List fetchedData = json.decode(res.body);

      Map homeMap = fetchedData.elementAt(category);
      List subcatList = homeMap.values.last;
      Map subcatsMap = subcatList.elementAt(subcategory);
      List fetchedsubCatProducts = subcatsMap.values.elementAt(2);

      if (fetchedData.isNotEmpty) {
        setState(() {
          // Keep the existing data and simply add more data to it.
          subCatProducts.addAll(fetchedsubCatProducts);
        });
      } else {
        setState(() {
          noData = true;
        });
      }
      // print('Fetching more data complete.');
    } catch (error) {
      _error = error; // Assign the caught error to _error
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
    return subCatProducts;
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
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: 'imageTag',
              child: Image.asset(
                'assets/images/default_image.png',
                fit: BoxFit
                    .cover, // Adjust this to control the image's appearance
              ),
            ),
          ),
        );
      },
    );
  }

  void removeFromCart(CartItem cartItem) {
    setState(() {
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
      } else {
        cart.items.remove(cartItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final sellerRatingsProvider = Provider.of<SellerRatingsProvider>(context);
    final sellerProvider = Provider.of<SellerDataProvider>(context);
    final usersProvider = Provider.of<UserDataProvider>(context);

    return Scaffold(
      body: _isFirstLoadRunning
          ? Center(
              child: buildLoadingIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
              children: [
                saleMainTab(screenWidth, screenHeight),
                saleSubCatTab(screenWidth),
                if (subCatProducts.isNotEmpty)
                  saleProductDetails(screenHeight, sellerRatingsProvider,
                      sellerProvider, usersProvider, screenWidth),
                // subCatProducts!.isEmpty
                //     ? const Center(child: SizedBox())
                //     : saleProductDetails(screenHeight, sellerRatingsProvider,
                //         sellerProvider, usersProvider, screenWidth),
              ],
            )),
    );
  }

  Container saleMainTab(double screenWidth, double screenHeight) {
    return Container(
      height: 70,
      padding: EdgeInsets.fromLTRB(
          screenWidth * .02, screenWidth * .08, screenWidth * .02, 0),
      child: home == null
          ? Container()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _mainCategoriesData.length,
              itemBuilder: (BuildContext context, int index) {
                try {
                  home = _mainCategoriesData.elementAt(index);
                  String tabName = home!.values.elementAt(0);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        positionedTab = index;
                        positionedTabb = 0;
                      });
                      //homeData(index, 0);
                      _firstLoad(_action, index, 0, 1, _limit);
                    },
                    onHover: (s) {
                      setState(() {
                        hoverPosition = index;
                      });
                    },
                    hoverColor: Colors.grey[200],
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 1,
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: screenHeight * 0.01,
                              ),
                              child: Text(
                                tabName.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          index == positionedTab
                              ? Container(
                                  width: tabName.characters.length * 6,
                                  height: 3,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[800]),
                                )
                              : const SizedBox(
                                  height: 1,
                                )
                        ],
                      ),
                    ),
                  );
                } catch (e) {
                  // Handle the case where the index is out of range
                  return null; // or any other widget you want to display
                }
              },
            ),
    );
  }

  Container saleSubCatTab(double screenWidth) {
    return Container(
      height: 50,
      padding: EdgeInsets.fromLTRB(
          screenWidth * .02, screenWidth * .0, screenWidth * .02, 0),
      child: subcats == null
          ? Container()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subcatList?.length,
              itemBuilder: (BuildContext context, int indexed) {
                try {
                  subcats = subcatList!.elementAt(indexed);
                  String subtabName = subcats!.values.elementAt(1);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        positionedTabb = indexed;
                      });
                      //homeData(positionedTab, indexed);
                      _firstLoad(
                          _action, positionedTab, indexed, _page, _limit);
                    },
                    onHover: (s) {
                      setState(() {
                        hoverPosition = indexed;
                      });
                    },
                    hoverColor: Colors.grey[200],
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 1,
                          ),
                          Center(
                            child: Text(
                              subtabName.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          indexed == positionedTabb
                              ? Container(
                                  width: subtabName.characters.length * 6,
                                  height: 3,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[800]),
                                )
                              : const SizedBox(
                                  height: 1,
                                )
                        ],
                      ),
                    ),
                  );
                } catch (e) {
                  // Handle the case where the index is out of range
                  return null; // or any other widget you want to display
                }
              },
            ),
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
          SizedBox(
            height: screenHeight,
            child: ListView.builder(
              controller: _controller,
              itemCount: subCatProducts.length,
              itemBuilder: (BuildContext context, int indexing) {
                try {
                  double element =
                      sellerRatingsProvider.sellerRatings!.sellerStars;
                  Map subCatprods = subCatProducts[indexing];
                  int price = subCatprods.values.elementAt(3);
                  String sellerName = subCatprods.values.elementAt(1);
                  String productName = subCatprods.values.elementAt(2);
                  int productId = subCatprods.values.elementAt(0);

                  int productIndex = indexing;

                  List<String> prodImages = [];
                  for (var i = 4; i < 7; i++) {
                    if (subCatprods.values.elementAt(i) != null &&
                        subCatprods.values.elementAt(i).toString().isNotEmpty) {
                      prodImages.add('${subCatprods.values.elementAt(i)}');
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
                          town),
                      subCatProducts.length - 1 == indexing &&
                              _isLoadMoreRunning == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Center(
                                    child: buildLoadingIndicator(),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      subCatProducts.length - 1 == indexing && noData == true
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    child:
                                        Text('You have loaded all the data.')),
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
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product-view',
                      arguments: {
                        'productName': productName,
                        'price': price,
                        'image': i.isNotEmpty
                            ? i
                            : 'assets/icons/myvazi_app_logo.png',
                      },
                    );
                  },
                  child: Builder(
                    builder: (BuildContext context) {
                      // Check if the image is a network image or a local image
                      if (i.toString().contains('http')) {
                        // Network image
                        //String fullImageUrl = '${ServerConfig.baseUrl}${ServerConfig.uploads}$i';
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
                        String? imageUrl = ServerConfig.defaultImage;
                        // Local image
                        return CachedNetworkImage(
                          height: screenHeight * 0.25, // Adjust as needed
                          width:
                              double.infinity, // Take the full width available
                          fit: BoxFit.cover,
                          imageUrl: i.isNotEmpty
                              ? localImagePath
                              : ServerConfig.defaultImageSquare,
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/default_image.png',
                            fit: BoxFit.cover,
                          ),
                        );
                        // Container(
                        //   margin: EdgeInsets.symmetric(
                        //       horizontal: screenWidth * 0.01),
                        //   decoration: const BoxDecoration(color: Colors.white),
                        //   child: CachedNetworkImage(
                        //     height: screenHeight * 9.0,
                        //     width: screenWidth * 0.9,
                        //     fit: BoxFit.cover,
                        //     imageUrl: localImagePath.isNotEmpty
                        //         ? "${ServerConfig.baseUrl}${ServerConfig.uploads}$localImagePath"
                        //         : imageUrl,
                        //     errorWidget: (context, url, error) => Image.asset(
                        //       'assets/images/default_image.png',
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // );
                      }
                    },
                  ),
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
                  onPressed: () {
                    _showSizeSelectionModal(userName, phone, location, town,
                        price, productId, productName);
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
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // subCatProducts.length - 1 == productIndex &&
            //         _isLoadMoreRunning == true
            //     ? Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(top: 5, bottom: 5),
            //             child: Center(
            //               child: buildLoadingIndicator(),
            //             ),
            //           ),
            //         ],
            //       )
            //     : const SizedBox(),
            // subCatProducts.length - 1 == productIndex &&
            //         noData == true
            //     ? const Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Padding(
            //               padding: EdgeInsets.only(top: 5, bottom: 5),
            //               child: Text('You have loaded all the data.')),
            //         ],
            //       )
            //     : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void _navigateToBillingInformation(
      BuildContext context, Map<String, dynamic> arguments) {
    Navigator.pushNamed(
      context,
      '/billing-information',
      arguments: arguments,
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
                itemCount: sizes.length,
                itemBuilder: (BuildContext context, int index) {
                  // print(sizes);
                  // String formattedList =
                  //     sizes.map((e) => e.toString()).join('\n');
                  try {
                    return ListTile(
                      leading: Text(
                        sizes[index]['name'],
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      onTap: () {
                        Map<String, dynamic> argumentsWithSize = {
                          ...arguments, // Include existing arguments
                          'selectedSize': sizes[index], // Include selected size
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
                  //Map<String, dynamic> size = sizes[index];
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
