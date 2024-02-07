import 'dart:convert';
import 'dart:io';
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
  Map _storeProducts = {};

  var _currentCategory;

  Map singleCategory = {};

  List prodList = [];

  @override
  bool get wantKeepAlive => true;

  String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
  int seller = MainConstants.sellerId;
  late Future<Map<String, dynamic>> data;
  Map? ourStoreMap;
  Map yo = {};
  int positionedTab = 0;
  int? hoverPosition;
  List productsShown = [];

  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String _action = "getSellerSubCats";
  final String storeAction = "archiveProducts";

  final int _limit = 10;
  int _page = 1;
  bool noData = false;
  late dynamic _error;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  void archiveProduct(BuildContext context, int productID, int seller) async {
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_sellers_subcategories.php?action=$storeAction&productID=$productID&seller_id=$seller'
          : '$_postCatUrl/get_sellers_subcategories.php?action=$storeAction&productID=$productID&seller_id=$seller';
      print(url);
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

  Future<Map> _loadFirst(String action, int seller, int page, int limit) async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/get_sellers_subcategories.php?action=$action&seller_id=$seller&current_page=$page&limit=$limit'
          : '$_postCatUrl/get_sellers_subcategories.php?action=$action&seller_id=$seller&current_page=$page&limit=$limit';

      final res = await http.get(Uri.parse(url));
      //print(res.body);

      _storeProducts = json.decode(res.body);

      if (_storeProducts.isNotEmpty) {
        //print(_storeProducts);

        setState(() {
          yo = _storeProducts.values.last;
          Map tabMap = yo.values.elementAt(0);
          prodList = _storeProducts.values.first;
          singleCategory = tabMap.values.last.split(',').toList();
          for (var i = 0; i < singleCategory.length; i++) {
            for (var j = 0; j < prodList.length; j++) {
              Map prodInput = prodList[j];

              List prodInptValue = prodInput.values.first;
              Map productInputDdetail = prodInptValue.elementAt(0);
              if (productInputDdetail.values.elementAt(0).toString() ==
                  singleCategory[i].toString()) {
                setState(() {
                  productsShown.add(prodInput);
                });
              }
            }
          }
        });
      } else {
        setState(() {
          noData = true;
        });
      }
    } catch (err) {
      if (kDebugMode) {
        _error = err.toString();
      }
    }
    setState(() {
      _isFirstLoadRunning = false;
    });

    return _storeProducts;
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _loadFirst(_action, seller, _page, _limit);
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
    super.build(context);
    return _isFirstLoadRunning
        ? Center(
            child: buildLoadingIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                storeTabs(context),
                productsShown == [] ? const SizedBox() : storeDetails(context),
              ],
            ),
          );
  }

  Container storeTabs(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.fromLTRB(MediaQuery.sizeOf(context).width * .1, 0,
          MediaQuery.sizeOf(context).width * .1, 0),
      child: yo == null
          ? Container()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: yo.values.length,
              itemBuilder: (BuildContext context, int index) {
                Map tabMap = yo.values.elementAt(index);
                print(tabMap);
                String tabName = tabMap.values.elementAt(1);

                return InkWell(
                  onTap: () {
                    setState(() {
                      productsShown = [];
                      positionedTab = index;
                    });
                    List prodList = _storeProducts.values.first;
                    // print(prodList);

                    List singleCategory =
                        tabMap.values.last.split(',').toList();
                    // print(singleCategory);

                    for (var i = 0; i < singleCategory.length; i++) {
                      // print('object');
                      for (var j = 0; j < prodList.length; j++) {
                        Map prodInput = prodList[j];
                        List prodInptValue = prodInput.values.first;
                        Map productInputDdetail = prodInptValue.elementAt(0);

                        // print(productInputDdetail.values.elementAt(0));
                        if (productInputDdetail.values
                                .elementAt(0)
                                .toString() ==
                            singleCategory[i].toString()) {
                          setState(() {
                            productsShown.add(prodInput);
                          });
                          //print(productsShown);
                        }
                        // if(prodInptValue.v)
                      }
                    }

                    //print(singleCategory);
                  },
                  onHover: (s) {
                    setState(() {
                      hoverPosition = index;
                    });
                  },
                  hoverColor: Colors.grey[200],
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 1,
                        ),
                        Center(
                          child: Text(
                            tabName.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w500),
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
              },
            ),
    );
  }

  SizedBox storeDetails(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.7,
      child: ListView.builder(
          controller: _controller,
          itemCount: productsShown == [] ? 0 : productsShown.length,
          itemBuilder: (BuildContext context, int index) {
            try {
              List prodInptValue = productsShown[index].values.last;
              int price = 0;
              String name = "";
              String purpose = '';

              List detailsList = productsShown[index].values.first;
              Map detailsMap = detailsList.first;
              price = detailsMap.values.elementAt(4);
              name = detailsMap.values.elementAt(2).toString();
              purpose = detailsMap.values.elementAt(3).toString();
              // String sellerName = detailsMap.values.elementAt(1);
              int prodId = detailsMap.values.elementAt(0);
              //print(detailsMap);
              Map image = prodInptValue.first;
              List<String> ImageList = [];

              for (Map<String, dynamic> image in prodInptValue) {
                String imageName = image['image_name_one'];
                String imageUrl =
                    "${ServerConfig.baseUrl}${ServerConfig.uploads}$imageName";
                ImageList.add(imageUrl);
              }
              // String localImagePath =
              //     '${ServerConfig.baseUrl}${ServerConfig.uploads}$image';
              //List ImageList = image.values.toList();
              // for (var i = 2; i > -1; i--) {
              //   if (!ImageList.elementAt(i).toString().contains('http')) {
              //     ImageList.removeAt(i);
              //   }
              // }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(21.0, 0.0, 21.0, 0.0),
                        child: CarouselSlider(
                          options: CarouselOptions(height: screenHeight * 0.25),
                          items: ImageList.map((i) {
                            return GestureDetector(
                              onTap: () {
                                // print(
                                //     'Before navigating: selectedProduct=$subCatprods, allProducts=$subCatProducts');
                                Navigator.pushNamed(
                                  context,
                                  '/product-view',
                                  arguments: {
                                    'productName': name,
                                    'price': price,
                                    'image': i.isNotEmpty
                                        ? i
                                        : 'assets/icons/myvazi_app_logo.png',
                                    'productId': prodId
                                  },
                                );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ProductView(
                                //       arguments: {
                                //         'selectedProduct': subCatprods,
                                //         'allProducts': subCatProducts,
                                //       },
                                //     ),
                                //   ),
                                // );
                              },
                              child: Builder(
                                builder: (BuildContext context) {
                                  // Check if the image is a network image or a local image
                                  if (i.toString().contains('http')) {
                                    // Network image
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.01),
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 231, 217, 61),
                                      ),
                                      child: CachedNetworkImage(
                                        height: screenHeight *
                                            0.25, // Adjust as needed
                                        width: double
                                            .infinity, // Take the full width available
                                        fit: BoxFit.cover,
                                        imageUrl: i,
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/default_image.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  } else {
                                    String localImagePath =
                                        '${ServerConfig.baseUrl}${ServerConfig.uploads}$i';
                                    // Local image
                                    return CachedNetworkImage(
                                      height: screenHeight *
                                          0.25, // Adjust as needed
                                      width: double
                                          .infinity, // Take the full width available
                                      fit: BoxFit.cover,
                                      imageUrl: i.isNotEmpty
                                          ? localImagePath
                                          : ServerConfig.defaultImageSquare,
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/default_image.png',
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                    // Container(
                                    //   margin: EdgeInsets.symmetric(
                                    //       horizontal: screenWidth * 0.01),
                                    //   decoration: const BoxDecoration(
                                    //       color: Colors.white),
                                    //   child: Image.file(
                                    //     File(localImagePath),
                                    //     height: screenHeight *
                                    //         0.25, // Adjust as needed
                                    //     width: double
                                    //         .infinity, // Take the full width available
                                    //     fit: BoxFit.cover,
                                    //     errorBuilder:
                                    //         (context, error, stackTrace) =>
                                    //             Image.asset(
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
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(21.0, 0.0, 21.0, 2.0),
                            child: Text(
                              name,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(21.0, 0.0, 21.0, 0.0),
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
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(21.0, 0.0, 21.0, 2.0),
                            child: Text(
                              '\UGX ${NumberFormat('#,###').format(price)}',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(
                          //       MediaQuery.sizeOf(context).width *
                          //           0.07,
                          //       MediaQuery.sizeOf(context).width *
                          //           0.0,
                          //       MediaQuery.sizeOf(context).width *
                          //           0.0,
                          //       MediaQuery.sizeOf(context).width *
                          //           0.04),
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //       _showConfirmDelete(context);
                          //     },
                          //     style: ButtonStyle(
                          //       backgroundColor:
                          //           MaterialStateProperty.all<Color>(
                          //               const Color.fromARGB(
                          //                   255, 50, 47, 211)),
                          //       // You can customize other button properties here, like text color, padding, etc.
                          //     ),
                          //     child: const Text(
                          //       'Edit',
                          //       style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize:
                          //               12, // Font size of the text
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                screenWidth * 0.3,
                                screenHeight * 0.0,
                                screenWidth * 0.0,
                                screenHeight * 0.04),
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
      child: CircularProgressIndicator(),
    );
  }

  void _showConfirmDelete(BuildContext context, int prodId) {
    showConfirmDelete(
      context,
      'Delete Item',
      'Are you sure you want to delete this item?',
      () {
        archiveProduct(context, prodId, seller);
      },
    );
  }
}
