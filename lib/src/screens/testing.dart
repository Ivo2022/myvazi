import 'package:flutter/material.dart';
import 'package:myvazi/src/screens/commonscaffold.dart';

class Testing extends StatelessWidget {
  const Testing({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonScaffold(
      body: Center(child: Text('Testing')),
      currentIndex: 0, // Set the index for the "Home" tab
    );
  }
}
