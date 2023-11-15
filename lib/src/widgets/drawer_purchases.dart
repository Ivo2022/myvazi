import 'package:flutter/material.dart';

class DrawerPurchases extends StatefulWidget {
  const DrawerPurchases({super.key});

  @override
  State<DrawerPurchases> createState() => _FrontPageState();
}

class _FrontPageState extends State<DrawerPurchases> {
  final List<Tab> tabs = [
    const Tab(
      text: 'MY PURCHASES',
    ),
    const Tab(text: 'CANCELLED'),
    // Add more tabs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Purchases'),
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
          ),
        ),
        body: const TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No purchases made yet. Orders of products you make appear hear.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'None of your orders for purchases has been cancelled before.',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
