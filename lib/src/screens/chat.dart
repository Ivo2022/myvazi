import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/myvazi_app_logo.png',
              height: 90,
              width: 210,
              fit: BoxFit.fill,
            ),
            const Text('Chat coming soon...'),
          ],
        ),
      ),
    );
  }
}
