import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/utils/sales_cancel_response.dart';
import 'package:myvazi/src/utils/sales_response.dart';
import 'package:myvazi/src/widgets/sales_details.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DrawerSales extends StatefulWidget {
  const DrawerSales({super.key});

  @override
  State<DrawerSales> createState() => _DrawerSalesState();
}

class _DrawerSalesState extends State<DrawerSales> {
  final List<Tab> tabs = [
    const Tab(
      text: 'PENDING',
    ),
    const Tab(text: 'COMPLETED'),
    const Tab(text: 'CANCELLED'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sales'),
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
          ),
        ),
        body: const TabBarView(
          children: [
            MyListView(
              tabName: 'PENDING',
              action: "getAllSalesPendingOrders",
            ),
            MyListView(
              tabName: 'COMPLETED',
              action: "getAllSalesCompletedOrders",
            ),
            MyListView(
              tabName: 'CANCELLED',
              action: "getAllSalesCancelledOrders",
            ),
            // Add more MyListView widgets for additional tabs
          ],
        ),
      ),
    );
  }
}

class MyListView extends StatefulWidget {
  final String tabName;
  final String action;

  const MyListView({
    super.key,
    required this.tabName,
    required this.action,
  });

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
  final _postOrdersUrl = MainConstants.baseUrl;
  final _postPhoneOrdersUrl = MainConstants.phoneUrl;
  late int sellerId = 152;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  final int limit = 10;
  int page = 1;
  //List Orders = [];
  String errorMessage = '';
  List<dynamic> dataList = []; // Initialize outside build method
  final ScrollController _scrollController = ScrollController();
  bool allDataLoaded = false;

  List data = [];

  @override
  void initState() {
    super.initState();
    firstloadSalesOrders(widget.action);
  }

  Future<List> firstloadSalesOrders(String action) async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      String url = Platform.isAndroid
          ? '$_postPhoneOrdersUrl/get_sales_orders.php?action=$action&seller_id=$sellerId&current_page=$page&limit=$limit'
          : '$_postOrdersUrl/get_sales_orders.php?action=$action&seller_id=$sellerId&current_page=$page&limit=$limit';
      final res = await http.get(Uri.parse(url));

      setState(() {
        dataList = json.decode(res.body);
        if (dataList.isEmpty) {
          setState(() {
            allDataLoaded = true;
          });
        }
      });
    } catch (err) {
      if (kDebugMode) {
        print('Error in _loadSalesOrders: $err');
      }
    }
    setState(() {
      _isFirstLoadRunning = false;
    });

    return dataList;
  }

  Future<void> loadMoreData() async {
    page += 1;
    // Fetch additional data
    List<dynamic>? additionalData = await fetchMoreData(page);

    // Update state to append new data
    setState(() {
      if (additionalData!.isNotEmpty) {
        dataList.addAll(additionalData);
      } else {
        // Set allDataLoaded to true when there's no more data
        allDataLoaded = true;
      }
      _isLoadMoreRunning = false;
    });
  }

  Future<List<dynamic>?> fetchMoreData(newPage) async {
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneOrdersUrl/get_sales_orders.php?action=${widget.action}&seller_id=$sellerId&current_page=$newPage&limit=$limit'
          : '$_postOrdersUrl/get_sales_orders.php?action=${widget.action}&seller_id=$sellerId&current_page=$newPage&limit=$limit';
      final res = await http.get(Uri.parse(url));

      setState(() {
        List newdataList = json.decode(res.body);
        dataList.addAll(newdataList);
      });

      //print(dataList);
    } catch (err) {
      if (kDebugMode) {
        print('Error fetching data: $err');
      }
      return dataList;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: dataList.length + 1, // +1 for loading indicator
      itemBuilder: (context, index) {
        if (index < dataList.length) {
          try {
            Map salesOrdersDataMap = dataList.elementAt(index);
            List<dynamic> orderItemDetailsList =
                salesOrdersDataMap.values.elementAt(0);
            Map orderItemDetailsMap = orderItemDetailsList.first;
            int deliveredStatus = orderItemDetailsMap.values.elementAt(6);
            int cancellation = orderItemDetailsMap.values.elementAt(9);

            Map<String, dynamic> productDetailsMap =
                salesOrdersDataMap.values.elementAt(1);
            Map<String, dynamic> productImagesMap =
                salesOrdersDataMap.values.elementAt(2);

            List<dynamic> buyerDetailsList =
                salesOrdersDataMap.values.elementAt(3);
            Map buyerDetailsMap = buyerDetailsList.first;

            String imageUrlSquare = productImagesMap.values.elementAt(0);
            String profileImage = buyerDetailsMap.values.elementAt(3);
            // print(imageUrlSquare);
            // print("${ServerConfig.baseUrl}${ServerConfig.uploads}$profileImage");
            String orderNo = orderItemDetailsMap.values.elementAt(8);
            int orderId = orderItemDetailsMap.values.elementAt(1);
            int amount = orderItemDetailsMap.values.elementAt(5);
            int orderItems = orderItemDetailsMap.values.elementAt(4);
            String seller =
                capitalizeFirstLetter(buyerDetailsMap.values.elementAt(2));
            String? imageUrl = ServerConfig.defaultImage;

            // Display the data
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    title: Row(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            height: 40, // Adjust as needed
                            width: 40, // Take the full width available
                            fit: BoxFit.cover,
                            imageUrl: profileImage.isNotEmpty
                                ? "${ServerConfig.baseUrl}${ServerConfig.uploads}$profileImage"
                                : imageUrl,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/default_image.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                            width:
                                4.0), // Add spacing between check icon and text
                        Text(
                          seller,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(), // Add spacer to push the close icon to the right
                        Visibility(
                          visible: deliveredStatus == 0 && cancellation == 0
                              ? true
                              : false,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Handle close button press
                                  SalesCancelResponse.showSalesCancelResponse(
                                      context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Handle check button press
                                  SalesResponse.showSalesResponseMessage(
                                      context, orderId);
                                },
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              height: 120, // Adjust as needed
                              width: 120, // Take the full width available
                              fit: BoxFit.cover,
                              imageUrl: imageUrlSquare.isNotEmpty
                                  ? "${ServerConfig.baseUrl}${ServerConfig.uploads}$imageUrlSquare"
                                  : ServerConfig.defaultImageSquare,
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/default_image_square.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                                width:
                                    8.0), // Add spacing between image and text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Order No.: $orderNo'),
                                Text('Order Items: $orderItems'),
                                Text('Amount: Ugx $amount'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SalesDetails(
                                            arguments: salesOrdersDataMap,
                                            tabName: widget.tabName),
                                      ),
                                    );

                                    // Handle button press, e.g., navigate to details screen
                                    print('View Details button pressed');
                                  },
                                  child: const Text(
                                    'VIEW DETAILS >>',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            );
          } catch (e) {
            return null;
          }
        } else if (errorMessage.isNotEmpty) {
          // Display the error message
          return Center(
            child: Text(
              'Error: $errorMessage',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          // Display loading indicator at the bottom if not all data is loaded
          return allDataLoaded
              ? const Text("You have loaded all data!")
              :
              //Display a loading indicator while fetching additional data
              GestureDetector(
                  onTap: () {
                    loadMoreData();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text('Load More'),
                  ),
                );
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
