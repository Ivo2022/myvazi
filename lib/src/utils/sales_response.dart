import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myvazi/routes.dart';
import 'package:http/http.dart' as http;
import 'package:myvazi/src/configs/constants.dart';

String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65

class SalesResponse {
  static late int orderId;
  static int newDeliveredStatus = 1;

  static Future<void> showSalesResponseMessage(
      BuildContext context, int orderId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.red, // Set the color of the danger icon
              ),
              SizedBox(
                  width: 8.0), // Add spacing between the icon and the title
              Text(
                "Set the sale as delivered",
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Text(
                "Do you confirm that you have delivered all the products of this sale?"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                // Close the dialog
                Navigator.of(context).pop();

                // Perform the update operation
                await _updateDeliveredStatus(
                    context, orderId, newDeliveredStatus);

                // Navigate to the next screen
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Routing()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

Future<void> _updateDeliveredStatus(
    context, orderId, newDeliveredStatus) async {
  String url = Platform.isAndroid
      ? 'http://$ipAddress/twambale/api/post_order_details.php'
      : 'http://localhost/twambale/api/post_order_details.php';

  // Replace 'YOUR_API_ENDPOINT' with the actual URL of your API endpoint
  var apiUrl = Uri.parse(url);

  // Prepare the data to be sent in the request body
  Map<String, dynamic> data = {
    'action': 'updateOrderDetails',
    'order_id': orderId.toString(),
    'delivered_status': newDeliveredStatus.toString(),
  };

  // Send a POST request to the API
  var response = await http.post(apiUrl, body: json.encode(data));
  // Check the status code of the response
  if (response.statusCode == 200) {
    // Data successfully submitted
    print('Delivered status updated successfully');
  } else {
    // Something went wrong
    print(
        'Failed to update delivered status. Status code: ${response.statusCode}');
  }
}
