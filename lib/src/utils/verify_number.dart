// import 'package:flutter/material.dart';

// class VerificationScreen extends StatefulWidget {
//   const VerificationScreen({super.key});

//   @override
//   State<VerificationScreen> createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends State<VerificationScreen> {
//   int? code;
//   String phone = "";
//   int? smsCode;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Verify Number"),
//       content: RichText(
//         text: const TextSpan(
//           style: TextStyle(color: Colors.black),
//           children: [
//             TextSpan(
//               text:
//                   "Phone number already exists. Send SMS to verify or use a different number",
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('CANCEL'),
//         ),
//         TextButton(
//           onPressed: () {},
//           child: const Text('VERIFY'),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationScreen extends StatefulWidget {
  final String code;
  final String phoneno;
  const VerificationScreen(
      {super.key, required this.code, required this.phoneno});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter Verification Code',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Verification Code'),
              keyboardType: TextInputType
                  .number, // Set keyboard type to accept only numbers
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
                LengthLimitingTextInputFormatter(
                    4), // Limit input to 6 characters
              ],
            ),
            // TextField(
            //   controller: _codeController,
            //   decoration: const InputDecoration(labelText: 'Verification Code'),
            // ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String enteredCode = _codeController.text.trim();
                if (enteredCode == widget.code) {
                  // Code is valid, call a function to handle verification success
                  _handleVerificationSuccess();
                } else {
                  // Code is invalid, show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid verification code'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVerificationSuccess() {
    // Close the verification screen dialog
    Navigator.pop(context);

    // Navigate to the front page
    Navigator.pushReplacementNamed(
      context,
      '/profile',
      arguments: {'phoneNo': widget.phoneno},
    );
  }
}
