import 'package:flutter/material.dart';

class DrawerSales extends StatefulWidget {
  const DrawerSales({super.key});

  @override
  State<DrawerSales> createState() => _FrontPageState();
}

class _FrontPageState extends State<DrawerSales> {
  final List<Tab> tabs = [
    const Tab(
      text: 'PENDING',
    ),
    const Tab(text: 'COMPLETED'),
    const Tab(text: 'CANCELLED'),
    // Add more tabs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sales'),
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
                "You don't have any sales pending delivery.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No sales of your products have been confirmed yet.',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'None of your orders have been confirmed.',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
