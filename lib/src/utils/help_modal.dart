import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpModal extends StatelessWidget {
  const HelpModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Help"),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            const TextSpan(
              text: "Please contact us on this number ",
            ),
            TextSpan(
              text: "+256 774452509",
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchPhone("+256774452509");
                },
            ),
            const TextSpan(
              text: " for any queries. Thank you.",
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            _launchPhone("256774452509");
          },
          child: const Text('PLACE CALL'),
        ),
      ],
    );
  }

  _launchPhone(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
    // await launchUrl(url.toString());
  }
}
