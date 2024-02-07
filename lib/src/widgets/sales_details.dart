import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/utils/sales_cancel_response.dart';
import 'package:myvazi/src/utils/sales_response.dart';

class SalesDetails extends StatefulWidget {
  const SalesDetails(
      {super.key, required this.arguments, required this.tabName});
  final Map<dynamic, dynamic> arguments;
  final String tabName;

  @override
  State<SalesDetails> createState() => _SalesDetailsState();
}

class _SalesDetailsState extends State<SalesDetails> {
  late Map<dynamic, dynamic> arguments;
  late String tabName;
  // Replace the placeholder image URL with your actual image URL
  String imageUrlSquare = ServerConfig.defaultImageSquare;

  String imageUrl = ServerConfig.defaultImage;

  @override
  void initState() {
    super.initState();
    arguments = widget.arguments;
    tabName = widget.tabName;
  }

  @override
  Widget build(BuildContext context) {
    print('We are now within sales_details: $arguments');

    List<dynamic> orderItemDetailsList = arguments.values.elementAt(0);
    Map orderItemDetailsMap = orderItemDetailsList.first;
    print(orderItemDetailsMap);
    Map<String, dynamic> productDetailsMap = arguments.values.elementAt(1);
    String productTitle = productDetailsMap.values.elementAt(2);
    String productPurpose = productDetailsMap.values.elementAt(3);
    Map<String, dynamic> productImagesMap = arguments.values.elementAt(2);

    List<dynamic> buyerDetailsList = arguments.values.elementAt(3);
    Map buyerDetailsMap = buyerDetailsList.first;

    String imageUrlSquare = productImagesMap.values.elementAt(0);
    String profileImage = buyerDetailsMap.values.elementAt(3);
    // print(imageUrlSquare);
    // print("${ServerConfig.baseUrl}${ServerConfig.uploads}$profileImage");
    String orderNo = orderItemDetailsMap.values.elementAt(8);
    int orderId = orderItemDetailsMap.values.elementAt(1);
    int amount = orderItemDetailsMap.values.elementAt(5);
    int orderItems = orderItemDetailsMap.values.elementAt(4);
    String seller = capitalizeFirstLetter(buyerDetailsMap.values.elementAt(2));
    // String? imageUrl = ServerConfig.defaultImage;
    String telephone = buyerDetailsMap.values.elementAt(1);
    String dateOrdered = orderItemDetailsMap.values.elementAt(10);
    String location = buyerDetailsMap.values.elementAt(5);
    String town = buyerDetailsMap.values.elementAt(6);
    int deliveredStatus = orderItemDetailsMap.values.elementAt(6);
    int cancellation = orderItemDetailsMap.values.elementAt(9);
    int sizeID = orderItemDetailsMap.values.elementAt(3);
    // String imageUrlSquare = arguments.values.elementAt(4);
    // String profileImage = arguments.values.elementAt(10);
    // String dateOrdered = arguments.values.elementAt(5);
    // String location = arguments.values.elementAt(12);
    // String town = arguments.values.elementAt(13);
    // String telephone = arguments.values.elementAt(11);

    // print("${ServerConfig.baseUrl}${ServerConfig.uploads}$profileImage");

    // String orderNo = arguments.values.elementAt(0);
    // int amount = arguments.values.elementAt(3);
    // int orderItems = arguments.values.elementAt(1);
    // int orderId = arguments.values.elementAt(13);

    // String seller = capitalizeFirstLetter(arguments.values.elementAt(9));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order No: $orderNo',
          style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        title: Row(
          children: [
            const Text(
              'Customer Information:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(), // Add spacer to push the close icon to the right
            // Close Icon
            // Close Button
            Visibility(
              visible: deliveredStatus == 0 && cancellation == 0 ? true : false,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle close button press
                      print('Close button pressed');
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle check button press
                      print('Check button pressed');
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            // Check Button
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    height: 40, // Adjust as needed
                    width: 40, // Take the full width available
                    fit: BoxFit.cover,
                    imageUrl: profileImage.isNotEmpty
                        ? "${ServerConfig.baseUrl}${ServerConfig.uploads}$profileImage"
                        : ServerConfig.defaultImage,
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/default_image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Container(
                //   width: 70.0, // Adjust the width as needed
                //   height: 70.0, // Adjust the height as needed
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     image: DecorationImage(
                //       fit: BoxFit.fill,
                //       image: AssetImage(
                //           imageUrlSquare), // Use AssetImage to load image from assets
                //     ),
                //   ),
                // ),
                const SizedBox(
                    width: 8.0), // Add spacing between image and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(seller),
                    Text(
                      telephone,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0), // Add spacing between the two rows
            // Another row with three Text lines
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location),
                // SizedBox(width: 8.0),
                Text(town, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8.0),
                Text('Placed on $dateOrdered'),
                Text('Total Sale Price: Ugx $amount'),
              ],
            ),
            const Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              title: Visibility(
                visible:
                    deliveredStatus == 0 && cancellation == 0 ? true : false,
                child: Row(
                  children: [
                    // Check Icon
                    // Container(
                    //   width: 40.0, // Adjust the width as needed
                    //   height: 40.0, // Adjust the height as needed
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.rectangle,
                    //     image: DecorationImage(
                    //       fit: BoxFit.contain,
                    //       image: AssetImage(
                    //           imageUrl), // Use AssetImage to load image from assets
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //     width: 4.0), // Add spacing between check icon and text
                    // const Text(
                    //   'P&P Stores',
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    const Spacer(), // Add spacer to push the close icon to the right
                    // Close Icon
                    // Close Button
                    const Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.red,
                          fontWeight: FontWeight.w700),
                    ),

                    IconButton(
                      onPressed: () {
                        // Handle close button press
                        SalesCancelResponse.showSalesCancelResponse(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                    // Check Button
                    const Text(
                      "Deliver",
                      style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.green,
                          fontWeight: FontWeight.w700),
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
              subtitle: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    height: 100, // Adjust as needed
                    width: 100, // Take the full width available
                    fit: BoxFit.cover,
                    imageUrl: imageUrlSquare.isNotEmpty
                        ? "${ServerConfig.baseUrl}${ServerConfig.uploads}$imageUrlSquare"
                        : ServerConfig.defaultImageSquare,
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/default_image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Container(
                  //   width: 100.0, // Adjust the width as needed
                  //   height: 100.0, // Adjust the height as needed
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.rectangle,
                  //     image: DecorationImage(
                  //       fit: BoxFit.fill,
                  //       image: AssetImage(
                  //           imageUrlSquare), // Use AssetImage to load image from assets
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                      width: 8.0), // Add spacing between image and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(productTitle),
                      Text(productPurpose),
                      Text('Amount: Ugx $amount'),
                      Row(
                        children: [
                          Text('Quantity: $orderItems'),
                          const SizedBox(width: 20.0),
                          Text(
                            'Size: $sizeID',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            tabName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 40.0),
                          // const Text(
                          //   'Buy',
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              // onTap: () {
              //   // Handle onTap for each ListTile if needed
              //   print('Tapped on $tabName Sale #$index');
              // },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
