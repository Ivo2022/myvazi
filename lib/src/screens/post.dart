import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
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
            const Text('Load image...'),
          ],
        ),
      ),
    );
  }
}
