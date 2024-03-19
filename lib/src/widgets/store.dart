import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/utils/confirm_delete.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myvazi/src/widgets/product_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> with AutomaticKeepAliveClientMixin {
  Map singleCategory = {};

  List prodList = [];

  @override
  bool get wantKeepAlive => true;

  String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
  //int seller = MainConstants.sellerId;
  int seller = sellerID.value;
  late Future<Map<String, dynamic>> data;
  Map? ourStoreMap;
  Map yo = {};
  int positionedTab = 0;
  int? hoverPosition;
  List productsShown = [];

  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String _action = "getSellerSubCatsProducts";
  final String storeAction = "archiveProducts";

  final int _limit = 10;
  int _page = 1;
  String selectedMenuID = "";
  bool noData = false;
  late dynamic _error;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    // _loadFirst(_action, seller, _page, _limit);
    _controller = ScrollController()..addListener(_loadMore);
    _controller.addListener(() {
      if (_controller.position.atEdge == true &&
          _controller.position.pixels != 0) {
        if (_isLoadMoreRunning == false) {
          _loadMore();
        }
      }
    });
  }

  void _loadMore() {
    setState(() {
      _isLoadMoreRunning = true; // Display a progress indicator at the bottom
    });

    _page += 1; // Increment the page for loading more data

    _loadMoreData(_action, _page, _limit).then((_) {
      setState(() {
        _isLoadMoreRunning =
            false; // Display a progress indicator at the bottom
      });
    });
  }

  Future<List> _loadMoreData(String action, int page, int limit) async {
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_sellers_subcategories.php?action=$action&seller_id=$seller&current_page=$page&limit=$limit'
          : '$_postCatUrl/get_sellers_subcategories.php?action=$action&seller_id=$seller&current_page=$page&limit=$limit';

      //print(url);
      final res = await http.get(Uri.parse(url));
      final Map fetchedData = json.decode(res.body);
      if (fetchedData.isNotEmpty) {
        setState(() {
          yo = fetchedData.values.last;
          Map tabMap = yo.values.elementAt(0);
          prodList = fetchedData.values.first;
          singleCategory = tabMap.values.last.split(',').toList();
          for (var i = 0; i < singleCategory.length; i++) {
            for (var j = 0; j < prodList.length; j++) {
              Map prodInput = prodList[j];

              List prodInptValue = prodInput.values.first;
              setState(() {
                productsShown.addAll(prodInptValue);
              });
            }
          }
        });
      } else {
        setState(() {
          noData = true;
        });
      }
      print('Fetching more data complete.');
    } catch (error) {
      _error = error; // Assign the caught error to _error
      print('Error fetching more data: $_error');

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
    return productsShown;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    super.build(context);
    return _isFirstLoadRunning
        ? Center(
            child: buildLoadingIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                StoreMainTabs(
                  screenHeight,
                  screenWidth,
                  seller,
                  _controller,
                  selectedMenuID,
                  (selectedSubItemID) {
                    setState(() {
                      selectedMenuID = selectedSubItemID;
                    });
                  },
                )
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

class StoreMainTabs extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final int seller;
  final ScrollController _controller;
  final String selectedMenuID;
  final Function(String) onMenuItemSelected;

  const StoreMainTabs(this.screenHeight, this.screenWidth, this.seller,
      this._controller, this.selectedMenuID, this.onMenuItemSelected,
      {super.key});

  @override
  State<StoreMainTabs> createState() => _StoreMainTabsState();
}

class _StoreMainTabsState extends State<StoreMainTabs> {
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String menuAction = "getSellerSubCatsMenu";

  bool includeAll = false;
  bool _isSubCatProductsLoaded = false;

  int positionedTab = 0;
  int positionedTabb = 0;
  int? hoverPosition;
  int? hoverPositioned;
  int page = 1; // Track the current page number
  int oldDataHeight = 80;

  String selectedMenuItemID = '';

  List _menuList = [];
  late dynamic _error;
  Map yo = {};
  Map? home;
  bool _isLoading = true; // Track loading state

  Future<List> _fetchSubMenu() async {
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_sellers_subcategories.php?action=$menuAction&seller_id=${widget.seller}'
          : '$_postCatUrl/get_sellers_subcategories.php?action=$menuAction&seller_id=${widget.seller}';

      final res = await http.get(Uri.parse(url));
      setState(() {
        _isLoading = false; // Update loading state
        // Keep the existing data and simply add more data to it.
        _menuList = json.decode(res.body);
      });
    } catch (error) {
      _error = error; // Assign the caught error to _error
      print('Error fetching menu data: $_error');
    }
    return _menuList;
  }

  @override
  void initState() {
    super.initState();
    _fetchSubMenu().then((_) {
      setState(() {
        homeData(0);
      });
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchSubMenu().then((_) {
  //     setState(() {
  //       int index = 0;
  //       homeData(index, 0);
  //     });
  //   });
  // }

  void homeData(int categoryInt) {
    setState(() {
      var home = _menuList.elementAt(categoryInt);
      int tabId = int.parse(home!.values.elementAt(0));
      // Call the function to send tabId
      widget.onMenuItemSelected(tabId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    // You can access screenWidth and screenHeight using widget.screenWidth and widget.screenHeight
    return Container(
      height: widget.screenHeight * 0.7,
      padding: EdgeInsets.fromLTRB(
          widget.screenWidth * .03, 0, widget.screenWidth * .03, 0),
      child: _isLoading
          ? buildLoadingIndicator()
          : _menuList.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 40,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _menuList.length,
                          itemBuilder: (context, index) {
                            try {
                              Map tabMap = _menuList.elementAt(index);
                              String tabName = capitalizeFirstLetter(
                                  tabMap.values.elementAt(1));
                              int storeTabId =
                                  int.parse(tabMap.values.elementAt(0));

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    positionedTab = index;
                                  });
                                  homeData(index);
                                  widget.onMenuItemSelected(
                                      storeTabId.toString());
                                },
                                onHover: (s) {
                                  setState(() {
                                    hoverPosition = index;
                                  });
                                },
                                hoverColor: Colors.grey[200],
                                child: Container(
                                  height: 40,
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 16, 8),
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
                                            tabName,
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ),
                                      index == positionedTab
                                          ? Container(
                                              width:
                                                  tabName.characters.length * 6,
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
                      flex: 8,
                      child: StoreDetailsWidget(
                          widget.screenHeight,
                          widget.screenWidth,
                          widget.seller,
                          widget._controller,
                          widget.selectedMenuID
                          // selectedSubMenuItemID,
                          ),
                    ),
                  ],
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Your error message widget
                    Text('You have no products to display!'),
                  ],
                ),
    );
  }

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

class StoreDetailsWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final int seller;
  final ScrollController _controller;
  final String selectedMenuID;

  const StoreDetailsWidget(this.screenHeight, this.screenWidth, this.seller,
      this._controller, this.selectedMenuID,
      {super.key});

  @override
  State<StoreDetailsWidget> createState() => _StoreDetailsWidgetState();
}

class _StoreDetailsWidgetState extends State<StoreDetailsWidget> {
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String storeAction = "archiveProducts";
  final String contentAction = "getSellerSubCatsProducts";
  // final ScrollController _scrollController = ScrollController();

  late dynamic _error;

  String _prevSubCatID = '';
  bool noData = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List _subcatList = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    _fetchContentData();

    widget._controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget._controller.position.pixels ==
        widget._controller.position.maxScrollExtent) {
      // If user scrolled to the bottom
      if (!_isLoadMoreRunning) {
        // If not currently loading, load more data
        _fetchMoreData();
      }
    }
  }

  void archiveProduct(BuildContext context, int productID, int seller) async {
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_sellers_subcategories.php?action=$storeAction&productID=$productID&seller_id=$seller'
          : '$_postCatUrl/get_sellers_subcategories.php?action=$storeAction&productID=$productID&seller_id=$seller';
      final res = await http.get(Uri.parse(url));
      String response = json.decode(res.body);

      // Check if the product was successfully archived
      if (response == "Product archived successfully") {
        // Show snack message indicating success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product archived successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show snack message indicating failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to archive product'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (err) {
      // Show snack message indicating error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $err'),
          backgroundColor: Colors.red,
        ),
      );

      if (kDebugMode) {
        _error = err.toString();
      }
    }
  }

  Future<List> _fetchContentData() async {
    String currentMenuID = widget.selectedMenuID;
    // Fetch data based on the updated positionedTab value
    if (_isFirstLoadRunning) return [];
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      if (_prevSubCatID != widget.selectedMenuID) {
        page = 1;
        _prevSubCatID = widget.selectedMenuID;
      }
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_sellers_subcategories.php?action=$contentAction&subCatID=$currentMenuID&seller_id=${widget.seller}&page=$page'
          : '$_postCatUrl/get_sellers_subcategories.php?action=$contentAction&subCatID=$currentMenuID&seller_id=${widget.seller}&page=$page';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        // Decode response body
        final newProducts = json.decode(res.body);
        if (mounted) {
          // Update state with new data
          setState(() {
            _subcatList = newProducts;
            _isFirstLoadRunning = false;
            page++;
          });
        }
      } else {
        print('HTTP request failed with status code: ${res.statusCode}');
        throw Exception('Failed to load data, ');
      }
    } catch (error) {
      setState(() {
        _isFirstLoadRunning = false;
      });
      print('Error occurred: $error');
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
          ? '$_postPhoneCatUrl/get_sellers_subcategories.php?action=$contentAction&subCatID=${widget.selectedMenuID}&seller_id=${widget.seller}&page=$page'
          : '$_postCatUrl/get_sellers_subcategories.php?action=$contentAction&subCatID=${widget.selectedMenuID}&seller_id=${widget.seller}&page=$page';
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

  @override
  void didUpdateWidget(StoreDetailsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Call _fetchContentData whenever positionedTab changes
    if (oldWidget.selectedMenuID != widget.selectedMenuID) {
      _fetchContentData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.screenHeight,
      child: ListView.builder(
          controller: widget._controller,
          itemCount: _subcatList.length,
          itemBuilder: (BuildContext context, int index) {
            try {
              Map detailsMap = _subcatList.elementAt(index);
              int? price = int.parse(detailsMap.values.elementAt(3));
              String name = detailsMap.values.elementAt(1).toString();
              String purpose = detailsMap.values.elementAt(2).toString();
              int? prodId = int.parse(detailsMap.values.elementAt(0));
              List<String> imageList = [];
              for (var i = 4; i < 7; i++) {
                if (detailsMap.values.elementAt(i) != null &&
                    detailsMap.values.elementAt(i).toString().isNotEmpty) {
                  imageList.add('${detailsMap.values.elementAt(i)}');
                }
              }
              // Remove null values from imageList
              imageList.removeWhere((element) => element == null);

              // Remove elements starting with 'http' from imageList
              imageList.removeWhere(
                  (element) => element.toString().contains('http'));

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            widget.screenWidth * 0.07,
                            widget.screenHeight * 0.0,
                            widget.screenWidth * 0.07,
                            widget.screenWidth * 0.07),
                        child: CarouselSlider(
                          options: CarouselOptions(
                              height: widget.screenHeight * 0.27),
                          items: imageList.map((i) {
                            return GestureDetector(
                              onTap: () {
                                //Navigator.pushNamed(
                                //   context,
                                //   '/product-view',
                                //   arguments: {
                                //     'productName': name,
                                //     // 'price': price,
                                //     'image':
                                //         i ?? 'assets/icons/myvazi_app_logo.png',
                                //     // 'productId': prodId
                                //   },
                                // );
                              },
                              child: Builder(
                                builder: (BuildContext context) {
                                  String localImagePath = i != null
                                      ? '${ServerConfig.uploads}$i'
                                      : 'assets/icons/myvazi_app_logo.png';
                                  // String localImagePath =
                                  //     '${ServerConfig.uploads}$imageList';
                                  // String localImagePath = '$imageList';
                                  // print(localImagePath);
                                  // Local image
                                  return CachedNetworkImage(
                                    height:
                                        widget.screenHeight, // Adjust as needed
                                    width: double
                                        .infinity, // Take the full width available
                                    fit: BoxFit.contain,
                                    imageUrl: i != null
                                        ? '${ServerConfig.uploads}$i'
                                        : ServerConfig.defaultProductImage,
                                    placeholder: (context, url) =>
                                        Image.network(
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
                            );
                          }).toList(),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                widget.screenWidth * 0.07,
                                widget.screenHeight * 0.0,
                                widget.screenWidth * 0.07,
                                widget.screenHeight * 0.01),
                            // child: Text(
                            //   name,
                            //   overflow: TextOverflow.ellipsis,
                            //   maxLines:
                            //       1, // Set to the maximum number of lines you want to display
                            //   softWrap: true,
                            //   style: TextStyle(
                            //     fontSize: 12.0,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                            child: Text(
                              name.length > 20
                                  ? '${name.substring(0, 21)}...'
                                  : name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                widget.screenWidth * 0.07,
                                widget.screenHeight * 0.0,
                                widget.screenWidth * 0.07,
                                widget.screenHeight * 0.01),
                            child: Column(
                              children: [
                                Text(
                                  purpose,
                                  style: const TextStyle(
                                      fontSize: 12.0, color: Colors.grey),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                widget.screenWidth * 0.07,
                                widget.screenHeight * 0.0,
                                widget.screenWidth * 0.07,
                                widget.screenHeight * 0.01),
                            child: Text(
                              '\UGX ${NumberFormat('#,###').format(price)}',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(
                          //       MediaQuery.sizeOf(context).width * 0.07,
                          //       MediaQuery.sizeOf(context).width * 0.0,
                          //       MediaQuery.sizeOf(context).width * 0.0,
                          //       MediaQuery.sizeOf(context).width * 0.04),
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //       // _showConfirmDelete(context, prodId);
                          //     },
                          //     style: ButtonStyle(
                          //       backgroundColor:
                          //           MaterialStateProperty.all<Color>(
                          //               const Color.fromARGB(255, 50, 47, 211)),
                          //       // You can customize other button properties here, like text color, padding, etc.
                          //     ),
                          //     child: const Text(
                          //       'Edit',
                          //       style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 12, // Font size of the text
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                widget.screenWidth * 0.07,
                                widget.screenHeight * 0.0,
                                widget.screenWidth * 0.0,
                                widget.screenHeight * 0.01),
                            child: ElevatedButton(
                              onPressed: () {
                                _showConfirmDelete(context, prodId);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red[700]!),
                                // You can customize other button properties here, like text color, padding, etc.
                              ),
                              child: const Text(
                                'Remove',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12, // Font size of the text
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } catch (e) {
              // Handle the case where the index is out of range
              return null; // or any other widget you want to display
            }
          }),
    );
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  void _showConfirmDelete(BuildContext context, int prodId) {
    showConfirmDelete(
      context,
      'Delete Item',
      'Are you sure you want to delete this item?',
      () {
        archiveProduct(context, prodId, widget.seller);
      },
    );
  }
}
