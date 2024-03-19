import 'package:flutter/material.dart';
import 'package:myvazi/routes.dart';

class OrderResponse {
  static Future<void> showResponseMessage(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thank You"),
          content: const SingleChildScrollView(
            child: Text("Order Made Successfully"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           Routing()), // Replace with your next screen
                // );
              },
            ),
          ],
        );
      },
    );
  }
}
