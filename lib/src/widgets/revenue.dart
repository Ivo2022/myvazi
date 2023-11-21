import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:myvazi/src/services/make_payment.dart';
// import 'package:myvazi/src/widgets/make_payment.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:myvazi/src/utils/providers.dart';

class Revenue extends StatefulWidget {
  const Revenue({super.key});

  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  Map<String, dynamic> monthlyOrders = {};
  Map<String, dynamic> yearlyOrders = {};
  String totalRevenue = "";
  Map<String, dynamic> currentMonthOrders = {};
  String totalPayments = "";
  int sellerId = 152;
  String ipAddress = "192.168.43.65";

  int deliveredStatus = 1;
  final double itemHeight = 36.0; // Adjust this value accordingly

  @override
  void initState() {
    super.initState();
    fetchMonthlyOrders();
    fetchYearlyOrders();
    fetchTotalRevenue();
    fetchCurrMonthOrders();
    fetchsellerPayments();
    final userProvider = Provider.of<UserDataProvider>(context, listen: false);
    userProvider.fetchUsersData();
  }

  fetchMonthlyOrders() async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_monthly_orders.php'
        : 'http://localhost/twambale/api/get_monthly_orders.php';

    final Map<String, dynamic> requestData = {
      'action': 'getMonthlyOrders',
      'seller_id': sellerId,
      'delivered_status': deliveredStatus,
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
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        setState(() {
          monthlyOrders = json.decode(response.body);
        });
        // return List<Map<String, dynamic>>.from(orders);
        // final items = json.decode(response.body);
        // OrdersModel ordersModels = OrdersModel.fromJson(items);

        return monthlyOrders;
      }
    } else {
      // Handle the error
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  fetchYearlyOrders() async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_yearly_orders.php'
        : 'http://localhost/twambale/api/get_yearly_orders.php';

    final Map<String, dynamic> requestData = {
      'action': 'getYearlyOrders',
      'seller_id': sellerId,
      'delivered_status': deliveredStatus,
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
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        // return data.cast<Map<String, dynamic>>();

        setState(() {
          yearlyOrders = json.decode(response.body);
        });
        // return List<Map<String, dynamic>>.from(orders);
        // final items = json.decode(response.body);
        // OrdersModel ordersModels = OrdersModel.fromJson(items);

        return yearlyOrders;
      }
    } else {
      // Handle the error
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  fetchTotalRevenue() async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_total_orders.php'
        : 'http://localhost/twambale/api/get_total_orders.php';

    final Map<String, dynamic> requestData = {
      'action': 'getTotalRevenue',
      'seller_id': sellerId,
      'delivered_status': deliveredStatus,
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

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        // return data.cast<Map<String, dynamic>>();

        setState(() {
          totalRevenue = json.decode(response.body);
        });
        // return List<Map<String, dynamic>>.from(orders);
        // final items = json.decode(response.body);
        // OrdersModel ordersModels = OrdersModel.fromJson(items);

        return totalRevenue;
      }
    } else {
      // Handle the error
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  fetchCurrMonthOrders() async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_current_orders.php'
        : 'http://localhost/twambale/api/get_current_orders.php';

    final Map<String, dynamic> requestData = {
      'action': 'getCurrentOrders',
      'seller_id': sellerId,
      'delivered_status': deliveredStatus,
    };

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
          'connection': 'keep-alive',
        },
        body: jsonEncode(requestData));

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        // return data.cast<Map<String, dynamic>>();

        setState(() {
          currentMonthOrders = json.decode(response.body);
        });

        return currentMonthOrders;
      }
    } else {
      // Handle the error
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  fetchsellerPayments() async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_payments_info.php'
        : 'http://localhost/twambale/api/get_payments_info.php';

    final Map<String, dynamic> requestData = {
      'action': 'getTotalPayments',
      'seller_id': sellerId,
      'delivered_status': deliveredStatus
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

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        // return data.cast<Map<String, dynamic>>();

        setState(() {
          totalPayments = json.decode(response.body);
        });
        // return List<Map<String, dynamic>>.from(orders);
        // final items = json.decode(response.body);
        // OrdersModel ordersModels = OrdersModel.fromJson(items);

        return totalPayments;
      }
    } else {
      // Handle the error
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  double extractNumericValue(String totalPayments) {
    RegExp regExp = RegExp(r'(\d+(\.\d+)?)');
    Match? match = regExp.firstMatch(totalPayments);

    if (match != null) {
      String numericValue = match.group(0)!; // Use ! to assert non-nullability
      return double.parse(numericValue).abs();
    } else {
      return 0.0; // Return a default value if no numeric value is found
    }
  }

  String getAbsoluteValue(String totalPayments) {
    // Remove the currency code and negative sign (if present) and convert to double
    double value = double.parse(
        totalPayments.replaceAll(RegExp(r'[A-Z]+'), '').replaceAll(',', ''));

    // Get the absolute (positive) value
    double absoluteValue = value.abs();

    return absoluteValue
        .toStringAsFixed(2); // Format as a string with 2 decimal places
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserDataProvider>(context);
    userProvider.fetchUsersData();
    String? phoneNo = userProvider.users?.userPhone ?? "No phone Number";
    var height = MediaQuery.sizeOf(context).height;

    return SingleChildScrollView(
      child: Column(
        children: [
          const Divider(),
          const Text("CURRENT STATUS",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          SizedBox(
            height: height * .05,
            child: currentMonthOrders.isEmpty
                ? const Center(
                    child: Text(
                      "No previous monthly data",
                    ),
                  )
                : ListView.builder(
                    itemCount: currentMonthOrders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: height * .17),
                              child: Text(
                                currentMonthOrders.values.first,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // SizedBox(width: 10.0),
                            Text(currentMonthOrders.values.last),
                          ],
                        ),
                      );
                    }),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            child: totalPayments.isEmpty
                ? const Center(
                    child: Text("No payments data"),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        double.parse(totalPayments
                                    .replaceAll(RegExp(r'[A-Z]+'), '')
                                    .replaceAll(',', '')) <
                                0
                            ? "Extra payments:"
                            : "You owe:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: double.parse(totalPayments
                                      .replaceAll(RegExp(r'[A-Z]+'), '')
                                      .replaceAll(',', '')) <
                                  0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text(
                        getAbsoluteValue(totalPayments),
                        style: TextStyle(
                          color: double.parse(totalPayments
                                      .replaceAll(RegExp(r'[A-Z]+'), '')
                                      .replaceAll(',', '')) <
                                  0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Visibility(
                        visible: double.parse(totalPayments
                                    .replaceAll(RegExp(r'[A-Z]+'), '')
                                    .replaceAll(',', '')) <
                                0
                            ? false
                            : true,
                        child: ElevatedButton(
                          onPressed: () {
                            double owe = double.parse(totalPayments
                                .replaceAll(RegExp(r'[A-Z]+'), '')
                                .replaceAll(',', ''));

                            _makePayment(context,
                                toPay: owe, phoneNumber: phoneNo);
                          },
                          child: const Text('Pay'),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 10.0),
          const Divider(),
          const Text("MONTHS OF THE CURRENT YEAR",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          SizedBox(
            height: monthlyOrders.isEmpty
                ? MediaQuery.of(context).size.height *
                    0.04 // Default height when no data
                : monthlyOrders.length *
                    40.0, // Assuming each item is 50.0 in height
            child: monthlyOrders.isEmpty
                ? const Center(
                    child: Text("No monthly data"),
                  )
                : ListView.builder(
                    itemCount: monthlyOrders.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Your existing code for each item
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              monthlyOrders.keys.toList().elementAt(index),
                            ),
                            Text(
                              monthlyOrders.values
                                  .toList()
                                  .elementAt(index)
                                  .toString(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(),
          const Text("PREVIOUS YEARS",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          SizedBox(
            height: math.max(
              // Minimum height when there is no data
              height * 0.05,
              // Calculate the height based on the number of items in the list
              yearlyOrders.isNotEmpty ? yearlyOrders.length * itemHeight : 0.0,
            ),
            child: yearlyOrders.isEmpty
                ? const Center(
                    child: Text("No yearly data"),
                  )
                : ListView.builder(
                    itemCount: yearlyOrders.length,
                    itemExtent: itemHeight, // Set the height of each item
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(yearlyOrders.keys.toList().elementAt(index)),
                            Text(yearlyOrders.values
                                .toList()
                                .elementAt(index)
                                .toString()),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(
            height: height * .05,
            child: totalRevenue.isEmpty
                ? const Center(
                    child: Text(
                      "No revenue data",
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "TOTAL REVENUE: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          totalRevenue,
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

_makePayment(BuildContext context,
    {required double toPay, required String phoneNumber}) {
  makePayment(
    context,
    toPay,
    phoneNumber,
    () {
      // Perform deletion logic here
      print('Payment Made!');
    },
  );
}
