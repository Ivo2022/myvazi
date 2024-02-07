import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/utils/drawer_actions.dart';
import 'package:intl/intl.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});
  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final int _limit = 20;
  final String menuAction = "getMainCategories";
  final String contentAction = "getSubcategoriesForMainCategory";
  final random = Random();

  String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
  String query = "";

  List? subcatList = [];
  List? subCatProducts = [];
  List<dynamic> searchResults = [];
  List _subcatList = [];
  List _menuList = [];
  List searchResultsList = [];

  Map? home;
  Map? subcats;

  bool noData = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  bool includeAll = true;
  bool atBottom = false;
  bool _isSearchVisible = false;
  bool _searchActive = false;
  bool _isGridView = true;

  int? hoverPosition;
  int? hoverPositioned;
  int _page = 1;
  int positionedTab = 0;
  int positionedTabb = 0;
  int page = 1; // Track the current page number
  int oldDataHeight = 80;

  double boxHeight = 40;
  double boxWidth = 200;

  late dynamic _error;

  @override
  void initState() {
    super.initState();
    _fetchMenuData().then((_) {
      // Once the menu data is fetched, fetch content data for the first tab
      _fetchContentData();
    });
    // Add scroll listener
    _scrollController.addListener(_scrollListener);
    // Add listener to search controller
    _searchController.addListener(_searchListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose(); // Dispose the search controller

    super.dispose();
  }

  void _searchListener() {
    setState(() {
      _isSearchVisible = _searchController.text.isNotEmpty;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // If user scrolled to the bottom
      if (!_isLoadMoreRunning) {
        // If not currently loading, load more data
        _fetchMoreData();
      }
    }
  }

  Future<List> _fetchContentData() async {
    if (_isFirstLoadRunning) return [];

    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_frontend_products.php?action=$contentAction&mainCatID=$positionedTab&page=$page'
          : '$_postCatUrl/get_frontend_products.php?action=$contentAction&mainCatID=$positionedTab&page=$page';
      // print(url);
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final List<dynamic> newData = json.decode(res.body);
        setState(() {
          _subcatList = newData;
          _isFirstLoadRunning = false;
          page++;
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
    return _subcatList;
  }

  Future<List> _fetchMoreData() async {
    if (_isLoadMoreRunning) return [];

    setState(() {
      _isLoadMoreRunning = true;
    });
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_frontend_products.php?action=$contentAction&mainCatID=$positionedTab&page=$page'
          : '$_postCatUrl/get_frontend_products.php?action=$contentAction&mainCatID=$positionedTab&page=$page';

      final res = await http.get(Uri.parse(url));
      final List fetchedData = json.decode(res.body);
      if (fetchedData.isNotEmpty && res.statusCode == 200) {
        setState(() {
          // Keep the existing data and simply add more data to it.
          _subcatList.addAll(fetchedData);
          _isLoadMoreRunning = false;
          page++;
        });
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
    }
    return _subcatList;
  }

  Future<List> _fetchMenuData() async {
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_frontend_products.php?action=$menuAction&include_all=$includeAll'
          : '$_postCatUrl/get_frontend_products.php?action=$menuAction&include_all=$includeAll';
      final res = await http.get(Uri.parse(url));
      setState(() {
        // Keep the existing data and simply add more data to it.
        _menuList = json.decode(res.body);
      });
    } catch (error) {
      _error = error; // Assign the caught error to _error
      print('Error fetching menu data: $_error');
    }
    return _menuList;
  }

  void _onMenuItemSelected(int menuId) {
    setState(() {
      _subcatList.clear(); // Clear existing data before adding new data
      positionedTab = menuId;
      page = 1; // Reset the page number to 1
    });
    _fetchContentData();

    _scrollController.animateTo(
      _scrollController.position.pixels + oldDataHeight,
      duration: const Duration(milliseconds: 500), // Adjust duration as needed
      curve: Curves.ease,
    );
  }

  void clearSearchResults() {
    _searchController.clear(); // Clear the text input
    setState(() {
      _isSearchVisible = false; // Hide the search results
    });
  }

  Future<void> searchProducts(String query) async {
    // Replace this URL with your backend API endpoint
    String url = Platform.isAndroid
        ? '$_postPhoneCatUrl/get_products_searched_by_name.php'
        : '$_postCatUrl/get_products_searched_by_name.php';

    try {
      // Append the query to the URL if it's not empty
      if (query.isNotEmpty) {
        url +=
            '?action=getSearchedSubCategories&search_string=$query&mainCatID=$positionedTab&current_page=$_page&limit=$_limit';
        setState(() {
          _searchActive = true; // Set the flag to indicate a search is active
        });
      } else {
        url += '?action=getSearchedProducts';
        setState(() {
          _searchActive =
              false; // Set the flag to indicate a search is not active
        });
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final fetchedData = json.decode(response.body);
        // Handle the response from the backend
        setState(() {
          searchResultsList = fetchedData;
        });
      } else {
        // Handle errors
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
                  Visibility(
                      visible: _searchActive ? false : true,
                      child: frontMainTabs(screenWidth, screenHeight)),
                  if (_subcatList.isNotEmpty)
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Spacer(),
                Image.asset(
                  'assets/icons/myvazi_app_logo.png',
                  fit: BoxFit.cover,
                ),
                Visibility(
                  visible: !_isSearchVisible,
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      changeSearchVisibility();
                      if (!_isSearchVisible) {
                        clearSearchResults(); // Clear search results when exiting search mode
                      }
                    },
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
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    // Alternatively, you can set _isSearchVisible to false here
                                  },
                                ),
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
                  child: PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                          value: 'grid',
                          child: Text('Grid View'),
                        ),
                        const PopupMenuItem(
                          value: 'list',
                          child: Text('List View'),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      setState(() {
                        if (value == 'grid') {
                          _isGridView = true;
                        } else if (value == 'list') {
                          _isGridView = false;
                        }
                      });
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
      child: _menuList.isEmpty
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _menuList.length,
              itemBuilder: (BuildContext context, int index) {
                try {
                  home = _menuList.elementAt(index);
                  String tabName = home!.values.elementAt(1);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        positionedTab = index;
                        positionedTabb = 0;
                      });
                      _onMenuItemSelected(positionedTab);

                      // _firstLoad(_action, index, _page, _limit, query);
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
          child: _isGridView
              ? gridViewMethod(screenWidth, screenHeight)
              : listViewMethod(screenWidth, screenHeight),
        )
      ],
    );
  }

  GridView gridViewMethod(double screenWidth, double screenHeight) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: SliverWovenGridDelegate.count(
        crossAxisCount: 2,
        mainAxisSpacing: 0.1, // Vertical spacing between cards
        crossAxisSpacing: 0.1, // Horrizontal spacing between cards
        pattern: [
          const WovenGridTile(2 / 3),
          const WovenGridTile(
            2 / 3,
            crossAxisRatio: 1.0,
            alignment: AlignmentDirectional.centerStart,
          ),
        ],
      ),
      itemCount: _searchActive
          ? searchResultsList.length + (_isLoadMoreRunning ? 1 : 0)
          : _subcatList.length + (_isLoadMoreRunning ? 1 : 0),
      itemBuilder: (_, indexing) {
        try {
          subcats = _searchActive
              ? searchResultsList.elementAt(indexing)
              : _subcatList.elementAt(indexing);
          // print(subcats);
          String name =
              capitalizeFirstLetter(subcats!.values.elementAt(1).toString());
          int subcatID = subcats!.values.elementAt(0);
          int price = subcats!.values.elementAt(3);
          String prodImage = subcats!.values.elementAt(4);
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
                    Navigator.pushNamed(
                      context,
                      '/product-view',
                      arguments: {'subCatName': name, 'subCatID': subcatID},
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
                          Builder(
                            builder: (BuildContext context) {
                              // Check if the image is a network image or a local image
                              if (prodImage.toString().contains('http')) {
                                // Network image
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.01),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 231, 217, 61),
                                  ),
                                  child: CachedNetworkImage(
                                    height:
                                        screenHeight * 0.25, // Adjust as needed
                                    width: double
                                        .infinity, // Take the full width available
                                    fit: BoxFit.cover,
                                    imageUrl: prodImage,
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/default_image.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              } else {
                                String localImagePath =
                                    '${ServerConfig.baseUrl}${ServerConfig.uploads}$prodImage';
                                // Local image
                                return CachedNetworkImage(
                                  height:
                                      screenHeight * 0.25, // Adjust as needed
                                  width: double
                                      .infinity, // Take the full width available
                                  fit: BoxFit.cover,
                                  imageUrl: prodImage.isNotEmpty
                                      ? localImagePath
                                      : ServerConfig.defaultImageSquare,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/default_image.png',
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    '\UGX ${NumberFormat('#,###').format(price)}',
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 54, 51, 51),
                                      fontSize: screenHeight * 0.023,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Text(
                                  //   price.toString(),
                                  //   style: TextStyle(
                                  //     fontSize: screenHeight * 0.026,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
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
    );
  }

  ListView listViewMethod(double screenWidth, double screenHeight) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _searchActive
          ? searchResultsList.length + (_isLoadMoreRunning ? 1 : 0)
          : _subcatList.length + (_isLoadMoreRunning ? 1 : 0),
      itemBuilder: (_, indexing) {
        try {
          subcats = _searchActive
              ? searchResultsList.elementAt(indexing)
              : _subcatList.elementAt(indexing);
          String name =
              capitalizeFirstLetter(subcats!.values.elementAt(1).toString());
          String purpose = subcats!.values.elementAt(5);
          int price = subcats!.values.elementAt(3);
          String prodImage = subcats!.values.elementAt(4);
          int subcatID = subcats!.values.elementAt(0);
          String localImagePath =
              '${ServerConfig.baseUrl}${ServerConfig.uploads}$prodImage';
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/product-view',
                  arguments: {'subCatName': name, 'subCatID': subcatID},
                );
              },
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: screenHeight * 0.17,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3.0),
                          topRight: Radius.circular(3.0),
                        ),
                      ),
                      child: prodImage.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: prodImage.isNotEmpty
                                  ? localImagePath
                                  : ServerConfig.defaultImageSquare,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            )
                          : const Placeholder(), // Placeholder for empty image
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            purpose,
                            style: const TextStyle(
                              fontSize: 13.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '\UGX ${NumberFormat('#,###').format(price)}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } catch (e) {
          return null;
        }
      },
    );
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
