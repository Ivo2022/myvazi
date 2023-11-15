import 'package:flutter/material.dart';

Future<void> makePayment(BuildContext context, double amount,
    String phoneNumber, Function onConfirm) async {
  int? selectedRadioValue = 1;
  TextEditingController textController =
      TextEditingController(text: phoneNumber);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Make your Payment:'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text("You owe:"),
                    const SizedBox(width: 10.0),
                    Text(
                      '$amount',
                      style: const TextStyle(
                        fontSize: 21.0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: selectedRadioValue,
                      onChanged: (value) {
                        setState(() {
                          selectedRadioValue = value;
                        });
                      },
                    ),
                    const Text('Mobile Money'),
                    Radio(
                      value: 2,
                      groupValue: selectedRadioValue,
                      onChanged: (value) {
                        // setState(() {
                        //   selectedRadioValue = value;
                        // });
                      },
                    ),
                    const Text('Card'),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.32,
                      child: SizedBox(
                        width: 200.0,
                        child: TextField(
                          controller: textController,
                          decoration: const InputDecoration(
                            hintText: '+256...',
                            labelText: 'Phone Number',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onConfirm(selectedRadioValue);
              Navigator.of(context).pop();
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}
