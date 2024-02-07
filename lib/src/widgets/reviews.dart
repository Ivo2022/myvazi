import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myvazi/src/configs/constants.dart';
import 'package:provider/provider.dart';
import 'package:myvazi/src/utils/providers.dart';

class SupplierReview extends StatefulWidget {
  const SupplierReview({super.key});

  @override
  State<SupplierReview> createState() => _SupplierReviewState();
}

class _SupplierReviewState extends State<SupplierReview> {
  List<Map<String, dynamic>> supplierComments = [];
  List<Map<String, dynamic>> supplierRatings = [];

  int sellerId = MainConstants.sellerId;
  String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65

  @override
  void initState() {
    super.initState();
    fetchSupplierComments();
    final sellerRatingProvider =
        Provider.of<SellerRatingsProvider>(context, listen: false);
    sellerRatingProvider.fetchSellerRatingsData();
  }

  Future<List<Map<String, dynamic>>?> fetchSupplierComments() async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_supplier_comments.php'
        : 'http://localhost/twambale/api/get_supplier_comments.php';

    final Map<String, dynamic> requestData = {
      'action': 'getSupplierComments',
      'seller_id': sellerId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
      },
      body: jsonEncode(requestData),
    );

    //print(response.body);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        List<Map<String, dynamic>> supplierComment =
            (json.decode(response.body) as List<dynamic>)
                .cast<Map<String, dynamic>>();

        setState(() {
          supplierComments = supplierComment;
        });

        return supplierComments;
      }
    } else {
      // Handle the error
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    // Return null if there is no data available
    return null;
  }

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final String formattedDate =
        "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final sellerRatingProvider = Provider.of<SellerRatingsProvider>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (sellerRatingProvider.sellerRatings != null)
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 0.0, 4.0),
                      child: Text((sellerRatingProvider
                          .sellerRatings!.sellersRating
                          .toString())),
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'Ratings', // Label
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ])
            else
              const Center(
                child: Text("No data available"),
              ),
          ],
        ),
        const SizedBox(height: 10.0),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'CUSTOMER COMMENTS', // Label
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.fromLTRB(40.0, 2.0, 16.0, 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date"),
              SizedBox(width: 135.0),
              Text("Comments"),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: supplierComments.length,
            itemBuilder: (BuildContext context, int index) {
              try {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 4.0, 16.0, 4.0),
                      child: Row(
                        children: [
                          Text(
                            supplierComments[index]['date_created'],
                          ),
                          const SizedBox(width: 40.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  supplierComments[index]['comment'] ??
                                      'No comment available',
                                  softWrap:
                                      true, // This allows text to wrap to the next line
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } catch (e) {
                // Handle the case where the index is out of range
                return null; // or any other widget you want to display
              }
            },
          ),
        ),
      ],
    );
  }
}
