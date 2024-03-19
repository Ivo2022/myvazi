import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/providers/auth_state_provider.dart';
import 'package:myvazi/src/utils/create_shop.dart';
import 'package:myvazi/src/utils/drawer_actions.dart';
import 'package:intl/intl.dart';
import 'package:myvazi/src/utils/help_modal.dart';
import 'package:myvazi/src/utils/retrieve_token.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final random = Random();

  String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
  String query = "";

  List? subcatList = [];
  List? subCatProducts = [];
  List<dynamic> searchResults = [];
  List searchResultsList = [];

  Map? home;

  final bool _isFirstLoadRunning = false;
  bool atBottom = false;
  bool _isSearchVisible = false;
  bool _searchActive = false;
  bool _isGridView = true;
  int? hoverPosition;
  int? hoverPositioned;
  final int _page = 1;
  int positionedTab = 0;
  int positionedTabb = 0;
  int page = 1; // Track the current page number
  int oldDataHeight = 80;

  double boxHeight = 40;
  double boxWidth = 200;

  @override
  void initState() {
    super.initState();
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
      print(url);
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
      boxWidth = random.nextInt(1600).toDouble();
    });
  }

  void changeSearchVisibility() {
    if (mounted) {
      setState(() {
        _isSearchVisible = !_isSearchVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double sizeWidth =
        screenWidth < 400 ? screenWidth * 0.1 : screenWidth * 0.04;
    double spacingBetween =
        screenWidth < 400 ? screenWidth * 0.01 : screenWidth * 0.3;
    // Color boxColor = Colors.deepPurple;
    BorderRadius borderRadius = BorderRadius.circular(4);
    return SafeArea(
      child: Scaffold(
        appBar: frontAppBar(
            screenWidth, boxHeight, boxWidth, random, borderRadius, context),
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
                        child: FrontMainTabs(
                            screenWidth,
                            screenHeight,
                            searchResultsList,
                            _searchActive,
                            spacingBetween,
                            _isGridView))
                  ],
                ),
              ),
      ),
    );
  }

  PreferredSize frontAppBar(
      double screenWidth,
      double boxHeight,
      double boxWidth,
      Random random,
      BorderRadius borderRadius,
      BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading:
            true, // Set to false to remove the default leading icon
        actions: [
          SizedBox(
            width: screenWidth,
            // Adjust padding as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 33.0),
                  child: Image.asset(
                    'assets/icons/myvazi_app_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(), // Add Spacer to push the following widgets to the extreme right
                PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    final authProvider =
                        Provider.of<AuthState>(context, listen: false);
                    // Build menu items based on login status
                    List<PopupMenuItem<String>> menuItems = [
                      const PopupMenuItem(
                        value: 'grid',
                        child: Text('Grid View'),
                      ),
                      const PopupMenuItem(
                        value: 'list',
                        child: Text('List View'),
                      ),
                      if (!authProvider
                          .isLoggedIn) // Only include "Create Shop" if user is not logged in
                        // ignore: dead_code
                        const PopupMenuItem(
                          value: 'create-shop',
                          child: Text('Create Shop'),
                        ),
                      const PopupMenuItem(
                        value: 'help',
                        child: Text('Help'),
                      ),
                    ];

                    return menuItems;
                  },
                  onSelected: (value) {
                    setState(() {
                      if (value == 'grid') {
                        _isGridView = true;
                      } else if (value == 'list') {
                        _isGridView = false;
                      } else if (value == 'create-shop') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateShopScreen()),
                        );
                      } else if (value == 'help') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const HelpModal();
                          },
                        );
                      }
                    });
                  },
                ),

                // PopupMenuButton(
                //   itemBuilder: (BuildContext context) {
                //     return [
                //       const PopupMenuItem(
                //         value: 'grid',
                //         child: Text('Grid View'),
                //       ),
                //       const PopupMenuItem(
                //         value: 'list',
                //         child: Text('List View'),
                //       ),
                //       const PopupMenuItem(
                //         value: 'create-shop',
                //         child: Text('Create Shop'),
                //       ),
                //       const PopupMenuItem(
                //         value: 'help',
                //         child: Text('Help'),
                //       ),
                //     ];
                //   },
                //   onSelected: (value) {
                //     setState(() {
                //       if (value == 'grid') {
                //         _isGridView = true;
                //       } else if (value == 'list') {
                //         _isGridView = false;
                //       } else if (value == 'create-shop') {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => const CreateShopScreen()),
                //         );
                //       } else if (value == 'help') {
                //         showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return const HelpModal();
                //           },
                //         );
                //       }
                //     });
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}

class FrontMainTabs extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final List searchResultsList;
  final bool _searchActive;
  final double spacingBetween;
  final bool _isGridView;

  const FrontMainTabs(
      this.screenWidth,
      this.screenHeight,
      this.searchResultsList,
      this._searchActive,
      this.spacingBetween,
      this._isGridView,
      {super.key});

  @override
  State<FrontMainTabs> createState() => _FrontMainTabsState();
}

class _FrontMainTabsState extends State<FrontMainTabs> {
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String menuAction = "getMainCategories";

  bool includeAll = true;

  int positionedTab = 0;
  int positionedTabb = 0;
  int? hoverPosition;
  int? hoverPositioned;
  int page = 1; // Track the current page number
  int oldDataHeight = 80;

  List _menuList = [];

  late dynamic _error;

  Map? home;

  @override
  void initState() {
    super.initState();
    _fetchMenuData().then((_) {
      setState(() {});
    });
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

  // void _onMenuItemSelected(int menuId) {
  //   setState(() {
  //     _subcatList.clear(); // Clear existing data before adding new data
  //     positionedTab = menuId;
  //     page = 1; // Reset the page number to 1
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // You can access screenWidth and screenHeight using widget.screenWidth and widget.screenHeight
    return Container(
      height: widget.screenHeight,
      padding: EdgeInsets.fromLTRB(
          widget.screenWidth * .03, 0, widget.screenWidth * .03, 0),
      child: _menuList.isEmpty
          ? buildLoadingIndicator()
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 10,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _menuList.length,
                      itemBuilder: (context, index) {
                        try {
                          home = _menuList.elementAt(index);
                          String tabName = home!.values.elementAt(1);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                positionedTab = index;
                                positionedTabb = 0;
                              });
                            },
                            onHover: (s) {
                              setState(() {
                                hoverPosition = index;
                              });
                            },
                            hoverColor: Colors.grey[200],
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: widget.screenHeight * 0.01,
                                      ),
                                      child: Text(
                                        tabName.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  index == positionedTab
                                      ? Container(
                                          width: tabName.characters.length * 6,
                                          height: 3,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[800]),
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
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: FrontProductDetails(
                      positionedTab,
                      widget.spacingBetween,
                      widget.screenHeight,
                      widget.screenWidth,
                      widget.searchResultsList,
                      widget._searchActive,
                      widget._isGridView),
                ),
              ],
            ),
    );
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}

class FrontProductDetails extends StatefulWidget {
  final int positionedTab;
  final double spacingBetween;
  final double screenHeight;
  final double screenWidth;
  final List searchResultsList;
  final bool _searchActive;
  final bool _isGridView;

  const FrontProductDetails(
      this.positionedTab,
      this.spacingBetween,
      this.screenHeight,
      this.screenWidth,
      this.searchResultsList,
      this._searchActive,
      this._isGridView,
      {super.key});

  @override
  State<FrontProductDetails> createState() => _FrontProductDetailsState();
}

class _FrontProductDetailsState extends State<FrontProductDetails> {
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String contentAction = "getSubcategoriesForMainCategory";
  final ScrollController _scrollController = ScrollController();

  int page = 1; // Track the current page number
  int? _prevMainCatID;

  bool noData = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  List _subcatList = [];

  Map? subcats;

  @override
  void initState() {
    super.initState();
    _fetchContentData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(FrontProductDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Call _fetchContentData whenever positionedTab changes
    if (oldWidget.positionedTab != widget.positionedTab) {
      _fetchContentData();
    }
  }
  //   setState(() {
  //     _subcatList.clear(); // Clear existing data before adding new data
  //     positionedTab = menuId;
  //     page = 1; // Reset the page number to 1
  //   });

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

  // Future<void> checkAutoLogin() async {
  //   String? token = await getToken();
  //   if (token == null) {
  //     // Handle the case where the token is not available
  //     return;
  //   }

  //   if (token != null) {
  //     // Send token to server for validation
  //     bool isValid = await validateToken(token);

  //     if (isValid) {
  //       // Navigate to the home screen
  //       Navigator.pushReplacementNamed(context, '/home');
  //     } else {
  //       // Token is invalid, delete it from storage
  //       return prefs.remove('token');
  //     }
  //   }
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Implement your frontProductDetails widget here
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: widget.screenHeight * 0.8,
              child: widget._isGridView
                  ? gridViewMethod(
                      widget.spacingBetween,
                      widget.screenWidth,
                      widget.screenHeight,
                    )
                  : listViewMethod(
                      widget.screenWidth,
                      widget.screenHeight,
                    ),
            ),
          ],
        ),
        if (_isFirstLoadRunning) // Display loading indicator if data is loading
          Container(
            color: Colors.black
                .withOpacity(0.1), // Semi-transparent black background
            child: const Center(
              child: CupertinoActivityIndicator(), // Loading indicator widget
            ),
          ),
      ],
    );
  }

  Future<List> _fetchContentData() async {
    // Fetch data based on the updated positionedTab value
    int currentPositionedTab = widget.positionedTab;
    if (_isFirstLoadRunning) return [];

    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      if (_prevMainCatID != widget.positionedTab) {
        page = 1;
        _prevMainCatID = widget.positionedTab;
      }
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_frontend_products.php?action=$contentAction&mainCatID=$currentPositionedTab&page=$page'
          : '$_postCatUrl/get_frontend_products.php?action=$contentAction&mainCatID=$currentPositionedTab&page=$page';

      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final List<dynamic> newProducts = json.decode(res.body);
        if (mounted) {
          setState(() {
            _subcatList = newProducts;
            _isFirstLoadRunning = false;
            page++;
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
          ? '$_postPhoneCatUrl/get_frontend_products.php?action=$contentAction&mainCatID=${widget.positionedTab}&page=$page'
          : '$_postCatUrl/get_frontend_products.php?action=$contentAction&mainCatID=${widget.positionedTab}&page=$page';
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

  GridView gridViewMethod(
      double spacingBetween, double screenWidth, double screenHeight) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: MediaQuery.of(context).size.width < 320
          ? const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  1, // Adjust the number of columns for small screens
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
            )
          : MediaQuery.of(context).size.width < 600
              ? SliverWovenGridDelegate.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0.0, // Vertical spacing between cards
                  crossAxisSpacing: 0.0, // Horrizontal spacing between cards
                  pattern: [
                    const WovenGridTile(2 / 3),
                    const WovenGridTile(
                      2 / 3,
                      // crossAxisRatio: 1.0,
                      // alignment: AlignmentDirectional.centerStart,
                    ),
                  ],
                )
              : const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      4, // Adjust the number of columns for larger screens
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                ),
      itemCount: widget._searchActive
          ? widget.searchResultsList.length + (_isLoadMoreRunning ? 1 : 0)
          : _subcatList.length + (_isLoadMoreRunning ? 1 : 0),
      itemBuilder: (_, indexing) {
        try {
          subcats = widget._searchActive
              ? widget.searchResultsList.elementAt(indexing)
              : _subcatList.elementAt(indexing);
          String mainCatName =
              capitalizeFirstLetter(subcats!.values.elementAt(3));
          String subCatName =
              capitalizeFirstLetter(subcats!.values.elementAt(1));
          int subcatID = int.parse(subcats!.values.elementAt(0));
          int price = int.parse(subcats!.values.elementAt(5));
          String prodImage = subcats!.values.elementAt(6);
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/product-view',
                    arguments: {'subCatName': subCatName, 'subCatID': subcatID},
                  );
                },
                child: Container(
                  color: Colors.white,
                  child: Card(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(screenWidth * 0.01),
                        bottomRight: Radius.circular(screenWidth * 0.01),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(
                            builder: (BuildContext context) {
                              String localImagePath =
                                  '${ServerConfig.uploads}$prodImage';
                              // Local image
                              return CachedNetworkImage(
                                height: screenHeight * 0.25, // Adjust as needed
                                width: double
                                    .infinity, // Take the full width available
                                fit: BoxFit.contain,
                                imageUrl: prodImage.isNotEmpty
                                    ? localImagePath
                                    : ServerConfig.defaultProductImage,
                                placeholder: (context, url) => Image.network(
                                  ServerConfig.defaultProductImage,
                                  fit: BoxFit.contain,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.network(
                                  ServerConfig.defaultProductImage,
                                  fit: BoxFit.contain,
                                ),
                              );
                              // }
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
                                    subCatName.length > 17
                                        ? '$mainCatName, ${subCatName.substring(0, 14)}...'
                                        : '$mainCatName, $subCatName',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: screenHeight * 0.017,
                                        color: Colors.grey),
                                  ),
                                ),
                                Text(
                                  '\UGX ${NumberFormat('#,###').format(price)}',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 54, 51, 51),
                                    fontSize: screenHeight * 0.017,
                                    fontWeight: FontWeight.bold,
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
              ),
            ],
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
      itemCount: widget._searchActive
          ? widget.searchResultsList.length + (_isLoadMoreRunning ? 1 : 0)
          : _subcatList.length + (_isLoadMoreRunning ? 1 : 0),
      itemBuilder: (_, indexing) {
        try {
          subcats = widget._searchActive
              ? widget.searchResultsList.elementAt(indexing)
              : _subcatList.elementAt(indexing);

          String mainCatName =
              capitalizeFirstLetter(subcats!.values.elementAt(3));
          // String subCatName =
          //     capitalizeFirstLetter(subcats!.values.elementAt(1));
          // int subcatID = int.parse(subcats!.values.elementAt(0));
          // int price = int.parse(subcats!.values.elementAt(5));
          // String prodImage = subcats!.values.elementAt(6);

          String subcatName =
              capitalizeFirstLetter(subcats!.values.elementAt(1).toString());
          int price = int.parse(subcats!.values.elementAt(5));
          String prodImage = subcats!.values.elementAt(6);
          int subcatID = int.parse(subcats!.values.elementAt(0));
          String localImagePath = '${ServerConfig.uploads}$prodImage';
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/product-view',
                  arguments: {'subCatName': subcatName, 'subCatID': subcatID},
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
                            subcatName.length > 20
                                ? '$mainCatName, ${subcatName.substring(0, 14)}...'
                                : '$mainCatName, $subcatName',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: screenHeight * 0.017,
                              color: Colors.grey,
                            ),
                          ),
                          // Text(
                          //   purpose,
                          //   style: const TextStyle(
                          //     fontSize: 13.0,
                          //   ),
                          // ),
                          const SizedBox(height: 8.0),
                          Text(
                            '\UGX ${NumberFormat('#,###').format(price)}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
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

  // Widget buildLoadingIndicator() {
  //   return Center(
  //     child: LinearProgressIndicator(
  //       backgroundColor:
  //           Colors.grey[200], // Background color of the progress bar
  //       valueColor: const AlwaysStoppedAnimation<Color>(
  //           Colors.blue), // Color of the progress indicator
  //     ),
  //   );
  // }

  Widget buildLoadingIndicator() {
    return const Center(child: CupertinoActivityIndicator());
    //   LinearProgressIndicator(
    //     backgroundColor:
    //         Colors.grey[200], // Background color of the progress bar
    //     valueColor: const AlwaysStoppedAnimation<Color>(
    //         Colors.blue), // Color of the progress indicator
    //   ),
    // );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
