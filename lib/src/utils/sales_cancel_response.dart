import 'package:flutter/material.dart';
import 'package:myvazi/routes.dart';

class SalesCancelResponse {
  static Future<void> showSalesCancelResponse(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const SalesCancelResponseDialog();
      },
    );
  }
}

class SalesCancelResponseDialog extends StatefulWidget {
  const SalesCancelResponseDialog({super.key});

  @override
  State<SalesCancelResponseDialog> createState() =>
      _SalesCancelResponseDialogState();
}

class _SalesCancelResponseDialogState extends State<SalesCancelResponseDialog> {
  Reason? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Reason",
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Set to minimize the height
        children: [
          ListTile(
            title: const Text(
              'Product is out of stock',
              style: TextStyle(fontSize: 14.0),
            ),
            leading: Radio<Reason>(
              value: Reason.option1,
              groupValue: _selectedReason,
              onChanged: (Reason? value) {
                setState(() {
                  _selectedReason = value;
                });
              },
            ),
          ),
          ListTile(
            title:
                const Text("Buyer's request", style: TextStyle(fontSize: 14.0)),
            leading: Radio<Reason>(
              value: Reason.option2,
              groupValue: _selectedReason,
              onChanged: (Reason? value) {
                setState(() {
                  _selectedReason = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Wrong order', style: TextStyle(fontSize: 14.0)),
            leading: Radio<Reason>(
              value: Reason.option3,
              groupValue: _selectedReason,
              onChanged: (Reason? value) {
                setState(() {
                  _selectedReason = value;
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            // Use _selectedReason to get the chosen option
            print('Selected Reason: $_selectedReason');
            Navigator.of(context).pop(); // Close the dialog
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Routing(),
            //   ),
            // );
          },
        ),
      ],
    );
  }
}

enum Reason { option1, option2, option3 }
