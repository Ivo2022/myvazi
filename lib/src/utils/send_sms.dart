import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:myvazi/src/configs/constants.dart';
import 'package:http/http.dart' as http;
import 'package:myvazi/src/utils/verify_number.dart';

class SendSMS extends StatefulWidget {
  final String username;
  final String phoneNo;
  final String bizName;
  final String address;
  final String statusMessage;
  final bool userStatus;

  const SendSMS(
      {super.key,
      required this.username,
      required this.phoneNo,
      required this.bizName,
      required this.address,
      required this.statusMessage,
      required this.userStatus});

  @override
  State<SendSMS> createState() => _SendSMSState();
}

class _SendSMSState extends State<SendSMS> {
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  late dynamic _error;
  int? code;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Verify Number"),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(text: widget.statusMessage),
          ],
        ),
      ),
      actions: [
        Visibility(
          visible: !widget.userStatus,
          child: TextButton(
            onPressed: () {},
            child: const Text('ANOTHER NUMBER'),
          ),
        ),
        TextButton(
          onPressed: () {
            // Generate and send the SMS
            String code = generateRandomCode();
            sendSMS(widget.phoneNo, code);
            // Navigate to the verification screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    VerificationScreen(phoneno: widget.phoneNo, code: code),
              ),
            );
          },
          child: const Text('SEND SMS'),
        ),
      ],
    );
  }

  String generateRandomCode() {
    // Generate a random number between 1000 and 9999 (inclusive)
    int code = Random().nextInt(9000) + 1000;
    // Convert the number to a string
    return code.toString();
  }

  void sendSMS(String phone, String code) async {
    try {
      String url = Platform.isAndroid
          ? '$_postPhoneCatUrl/confirm_phone_number.php?code=$code&&phone=$phone'
          : '$_postCatUrl/confirm_phone_number.php?code=$code&&phone=$phone';

      print(url);
      final res = await http.get(Uri.parse(url));
      setState(() {
        // Keep the existing data and simply add more data to it.
        code = json.decode(res.body);
        print(code);
      });
    } catch (error) {
      _error = error; // Assign the caught error to _error
      print('Error fetching menu data: $_error');
    }
  }
}
