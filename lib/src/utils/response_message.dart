import 'package:flutter/material.dart';
import 'package:myvazi/routes.dart';

class DialogUtils {
  static Future<void> showResponseMessage(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message"),
          content: const SingleChildScrollView(
            child: Text("Product Upload Successful!"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const Routing()), // Replace with your next screen
                );
              },
            ),
          ],
        );
      },
    );
  }
}
