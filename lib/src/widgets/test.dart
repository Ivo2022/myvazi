import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/utils/drawer_actions.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _dataList = []; // Initialize with an empty list
  List<dynamic> _filteredDataList = [];
  String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  //final String _action = "getSearchedProductsByName";
  final int _limit = 20;
  List<dynamic> searchResults = [];
  String query = "";

  final String _action = "getAllMainCategoriesWithProducts";
  final String _action2 = "getAllSubCategories";
  int _page = 1;
  bool noData = false;
  Map? home;
  List? subcatList = [];
  List? subCatProducts = [];
  Map? subcats;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreButtonVisible = true;
  bool _isLoadMoreRunning = false;
  dynamic _currentCategory; // Maintain the current category

  List _mainCategoriesData = [];
  // List<dynamic>? _mainCategoriesData;
  List _subcatList = [];

  int positionedTab = 0;
  int positionedTabb = 0;
  int? hoverPosition;
  int? hoverPositioned;
  // int category = 0;
  late dynamic _error;
  bool atBottom = false;
  bool _isSearchExpanded = false;
  final random = Random();
  double boxHeight = 40;
  double boxWidth = 200;
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _firstLoad(_action, 0, _page, _limit, query);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge == true &&
          _scrollController.position.pixels != 0 &&
          _scrollController.position.pixels !=
              _scrollController.position.maxScrollExtent) {
        if (atBottom == false) {
          setState(() {
            atBottom = true;
            _isLoadMoreRunning = false;
          });
        }
      }
    });
  }

  Future<List> _firstLoad(
      String action, int category, int page, int limit, query) async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    String url = Platform.isAndroid
        ? '$_postPhoneCatUrl/get_maincategories_with_products.php?action=$action&current_page=$_page&limit=$limit'
        : '$_postCatUrl/get_maincategories_with_products.php?action=$action&current_page=$_page&limit=$limit';

    try {
      //Append the query to the URL if it's not empty
      // if (query.isNotEmpty) {
      //   url += '?action=getSearchedProductsByName&search_string=$query';
      // } else {
      //   url += '?action=getSearchedProducts';
      // }
      if (_currentCategory != category) {
        // Category changed, reset _page to 1
        setState(() {
          _page = 1;
        });
      }
      final res = await http.get(Uri.parse(url));
      setState(() {
        _mainCategoriesData = json.decode(res.body);
        homeData(category, 0);
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

  void homeData(dynamic categoryInt, int subcategoryInt) {
    setState(() {
      home = _mainCategoriesData.elementAt(categoryInt);
      _subcatList = home!.values.last;
      //print("Before Sorting: $_subcatList");
      setState(() {
        // Sort _subcatList based on the most recently added product
        _subcatList.sort((a, b) {
          // Assuming each subcategory has a 'products' field associated with its products
          List<dynamic>? productsA = a['products'];
          List<dynamic>? productsB = b['products'];

          // Check if products lists are not empty
          if (productsA != null &&
              productsB != null &&
              productsA.isNotEmpty &&
              productsB.isNotEmpty) {
            // Assuming each product has a 'date_of_upload' field
            String? timeA = productsA.last['date_of_upload'];
            String? timeB = productsB.last['date_of_upload'];

            // Check if date_of_upload is not null
            if (timeA != null && timeB != null) {
              //print('timeA: $timeA, timeB: $timeB');
              // Compare timestamps in descending order
              return timeB.compareTo(timeA);
            }
          }

          // Default case: return 0 (no change in order) if there's an issue with the data
          return 0;
        });
      });
      //print("After Sorting: $_subcatList");

      subcats = _subcatList.elementAt(subcategoryInt);
      subCatProducts = subcats!.values.elementAt(2);
    });
  }

  late ScrollController _scrollController;

  void _loadMore() async {
    setState(() {
      _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      _isLoadMoreButtonVisible = false;
    });

    // Simulate loading delay
    // await Future.delayed(const Duration(seconds: 2));

    _page += 1; // Increment the page for loading more data

    await _fetchMoreData();

    setState(() {
      _isLoadMoreRunning = false; // Set to false after loading
      _isLoadMoreButtonVisible = true; // Show the "Load More" button
    });
  }

  Future<List> _fetchMoreData() async {
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_maincategories_with_products.php?action=$_action2&current_page=$_page&limit=$_limit'
          : '$_postCatUrl/get_maincategories_with_products.php?action=$_action2&current_page=$_page&limit=$_limit';

      final res = await http.get(Uri.parse(url));

      final List fetchedData = json.decode(res.body);
      if (fetchedData.isNotEmpty) {
        setState(() {
          // Keep the existing data and simply add more data to it.
          _subcatList.addAll(fetchedData);
        });
      } else {
        setState(() {
          noData = true;
        });
      }
    } catch (error) {
      _error = error; // Assign the caught error to _error
      print('Error fetching more data: $_error');
    }
    return _subcatList;
  }

  Future<void> searchProducts(query) async {
    // Replace this URL with your backend API endpoint
    String url = Platform.isAndroid
        ? '$_postPhoneCatUrl/get_products_searched_by_name.php'
        : '$_postCatUrl/get_products_searched_by_name.php';

    try {
      // Append the query to the URL if it's not empty
      if (query.isNotEmpty) {
        url += '?action=getSearchedProductsByName&search_string=$query';
      } else {
        url += '?action=getSearchedProducts';
      }
      print(url);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Handle the response from the backend
        setState(() {
          searchResults = json.decode(response.body);
        });
      } else {
        // Handle errors
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // void _updateFilteredResults(String query) {
  //   setState(() {
  //     _filteredDataList = _dataList
  //         .where(
  //             (item) => item.toLowerCase().contains(query.toLowerCase().trim()))
  //         .toList();
  //   });
  // }

  void changeBoxSize() {
    setState(() {
      boxHeight = random.nextInt(700).toDouble();
      boxWidth = random.nextInt(700).toDouble();
    });
  }

  void changeSearchVisibility() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Color boxColor = Colors.deepPurple;
    BorderRadius borderRadius = BorderRadius.circular(30);

    return Scaffold(
      appBar: frontAppBar(screenWidth, boxHeight, boxWidth, random, boxColor,
          borderRadius, context),
      drawer: const DrawerActions(),
      body: _isFirstLoadRunning
          ? Center(
              child: buildLoadingIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  frontMainTabs(screenWidth, screenHeight),
                  if (_mainCategoriesData.isNotEmpty)
                    frontProductDetails(screenHeight, screenWidth),
                ],
              ),
            ),
    );
  }

  PreferredSize frontAppBar(
      double screenWidth,
      double boxHeight,
      double boxWidth,
      Random random,
      Color boxColor,
      BorderRadius borderRadius,
      BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.001), // Adjust padding as needed
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/myvazi_app_logo.png',
                  fit: BoxFit.cover,
                ),
                Visibility(
                  visible: !_isSearchVisible,
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: changeSearchVisibility,
                  ),
                ),
                Visibility(
                  visible: _isSearchVisible,
                  child: GestureDetector(
                    onTap: changeSearchVisibility,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                      width: _isSearchVisible ? boxWidth : 0,
                      height: boxHeight,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                labelText: 'Enter search query',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                String searchQuery = _searchController.text;
                                searchProducts(searchQuery);
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !_isSearchVisible,
                  child: IconButton(
                    icon: const Icon(Icons.shopping_basket_outlined),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CartScreen(
                      //       cart: cart,
                      //       removeFromCart: removeFromCart,
                      //       addToCart: (Product) {},
                      //     ),
                      //   ),
                      // );
                      //print('Basket pressed!');
                    },
                  ),
                ),
                Visibility(
                  visible: !_isSearchVisible,
                  child: PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                          value: 'option1',
                          child: Text('Grid View'),
                        ),
                        const PopupMenuItem(
                          value: 'option2',
                          child: Text('List View'),
                        ),
                        const PopupMenuItem(
                          value: 'option3',
                          child: Text('Help'),
                        )
                      ];
                    },
                    onSelected: (value) {
                      print('Selected: $value');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container frontMainTabs(double screenWidth, double screenHeight) {
    return Container(
      height: 50,
      padding: EdgeInsets.fromLTRB(screenWidth * .02, 0, screenWidth * .02, 0),
      child: _mainCategoriesData.isEmpty
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
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

                      _firstLoad(_action, index, _page, _limit, query);
                    },
                    onHover: (s) {
                      setState(() {
                        hoverPosition = index;
                      });
                    },
                    hoverColor: Colors.grey[200],
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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

  Column frontProductDetails(double screenHeight, double screenWidth) {
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.8,
          child: GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            // gridDelegate: SliverWovenGridDelegate.count(
            //   crossAxisCount: 2,
            //   mainAxisSpacing: 0.1, // Vertical spacing between cards
            //   crossAxisSpacing: 0.1, // Horrizontal spacing between cards
            //   pattern: [
            //     const WovenGridTile(2 / 3),
            //     const WovenGridTile(
            //       2 / 3,
            //       crossAxisRatio: 1.0,
            //       alignment: AlignmentDirectional.center,
            //     ),
            //   ],
            // ),
            itemCount: _subcatList.length,
            itemBuilder: (_, indexing) {
              try {
                subcats = _subcatList.elementAt(indexing);
                String name = capitalizeFirstLetter(
                    subcats!.values.elementAt(1).toString());

                Map subCatprods = subCatProducts![indexing];

                String prodName = subCatprods.values.elementAt(2);
                int prodId = subCatprods.values.elementAt(0);
                int price = subCatprods.values.elementAt(3);

                List<String> prodImages = [];
                for (var i = 4; i < 7; i++) {
                  if (subCatprods.values.elementAt(i) != null &&
                      subCatprods.values.elementAt(i).toString().isNotEmpty) {
                    prodImages.add('${subCatprods.values.elementAt(i)}');
                  }
                }
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.01,
                    screenHeight * 0.01,
                    screenWidth * 0.01,
                    screenHeight * 0.01,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // print(subCatProducts);
                          Navigator.pushNamed(
                            context,
                            '/product-view',
                            arguments: {
                              'subCatProducts': _subcatList,
                              'subCatName': name
                            },
                          );
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(screenWidth * 0.04),
                              bottomRight: Radius.circular(screenWidth * 0.04),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                carouselFrontPage(
                                  screenHeight,
                                  prodImages,
                                  subCatprods,
                                  context,
                                  name,
                                  price,
                                  prodName,
                                  prodId,
                                  screenWidth,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: screenHeight * 0.01,
                                        ),
                                        child: Text(
                                          name,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: screenHeight * 0.017,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: screenHeight * 0.01,
                                        ),
                                        child: Text(
                                          price.toString(),
                                          style: TextStyle(
                                            fontSize: screenHeight * 0.026,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } catch (e) {
                // Handle the case where the index is out of range
                return null; // or any other widget you want to display
              }
            },
          ),
        ),
        _isLoadMoreRunning == false && noData == true && atBottom == true
            ? const SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text('You have loaded all the data.')),
                  ],
                ),
              )
            : const SizedBox(),
        // if (_isLoadMoreRunning) buildLoadingIndicator(),
        Visibility(
          visible: _isLoadMoreRunning ? true : false,
          child: ElevatedButton(
            onPressed: () {
              // Trigger load more when the button is pressed
              _loadMore();
            },
            child: const Text("Load More"),
          ),
        ),
      ],
    );
  }

  CarouselSlider carouselFrontPage(
      double screenHeight,
      List<String> prodImages,
      Map<dynamic, dynamic> subCatprods,
      BuildContext context,
      String name,
      int price,
      String prodName,
      int prodId,
      double screenWidth) {
    return CarouselSlider(
      options: CarouselOptions(height: screenHeight * 0.25),
      items: prodImages.map((i) {
        return Builder(
          builder: (BuildContext context) {
            //print(i);
            // Check if the image is a network image or a local image
            if (i.toString().contains('http')) {
              // Network image
              return Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 231, 217, 61),
                ),
                child: CachedNetworkImage(
                  height: screenHeight * 0.25, // Adjust as needed
                  width: double.infinity, // Take the full width available
                  fit: BoxFit.cover,
                  imageUrl: i,
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/default_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              String localImagePath =
                  '${ServerConfig.baseUrl}${ServerConfig.uploads}$i';
              //print(localImagePath);
              // Local image
              return CachedNetworkImage(
                height: screenHeight * 0.25, // Adjust as needed
                width: double.infinity, // Take the full width available
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
              //   margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              //   decoration: const BoxDecoration(color: Colors.white),
              //   child: Image.file(
              //     File(localImagePath),
              //     height: screenHeight * 0.25, // Adjust as needed
              //     width: double.infinity, // Take the full width available
              //     fit: BoxFit.cover,
              //     errorBuilder: (context, error, stackTrace) => Image.asset(
              //       'assets/images/default_image.png',
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // );
            }
          },
        );
      }).toList(),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Search for products"),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           TextField(
  //             controller: _searchController,
  //             decoration:
  //                 const InputDecoration(labelText: 'Enter search query'),
  //           ),
  //           const SizedBox(height: 16.0),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Get the text entered into the TextField
  //               String searchQuery = _searchController.text;
  //               // Call your backend with the search query or all results if empty
  //               searchProducts(searchQuery);
  //             },
  //             child: const Text('Search'),
  //           ),
  //           Expanded(
  //             child: GridView.builder(
  //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 2,
  //                 crossAxisSpacing: 2.0,
  //                 mainAxisSpacing: 2.0,
  //               ),
  //               itemCount: searchResults.length,
  //               itemBuilder: (context, index) {
  //                 print(searchResults);
  //                 return Card(
  //                   child: Row(
  //                     children: [Text(searchResults[index].toString())],
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Search for products"),
  //     ),
  //     body: Column(
  //       children: [
  //         TextField(
  //           controller: _searchController,
  //           decoration: const InputDecoration(
  //               labelText: 'Search for products',
  //               hintText: 'Search...',
  //               border: InputBorder.none),
  //           onChanged: (value) {
  //             // Call the search function when the user types
  //             searchProducts(value);
  //           },
  //         ),
  //         Expanded(
  //           child: GridView.builder(
  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2,
  //               crossAxisSpacing: 8.0,
  //               mainAxisSpacing: 8.0,
  //             ),
  //             itemCount: searchResults.length,
  //             itemBuilder: (context, index) {
  //               return Card(
  //                 child: Center(
  //                   child: Text(searchResults[index].toString()),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: TextField(
  //         controller: _searchController,
  //         decoration: const InputDecoration(
  //             labelText: 'Search for products',
  //             hintText: 'Search...',
  //             border: InputBorder.none),
  //         onChanged: (value) {
  //           // Call the search function when the user types
  //           searchProducts(value);
  //         },
  //       ),
  //     ),
  //     body: GridView.builder(
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         crossAxisSpacing: 8.0,
  //         mainAxisSpacing: 8.0,
  //       ),
  //       itemCount: _filteredDataList.length,
  //       itemBuilder: (context, index) {
  //         return Card(
  //           child: Center(
  //             child: Text(_filteredDataList[index]),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
