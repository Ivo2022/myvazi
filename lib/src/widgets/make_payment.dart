import 'package:flutter/material.dart';

class MakePayment extends StatefulWidget {
  const MakePayment({super.key});

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  @override
  Widget build(BuildContext context) {
    final myVariable = ModalRoute.of(context)!.settings.arguments as double;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
      ),
      body: Text('$myVariable'),
    );
  }
}
