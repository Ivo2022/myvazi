import 'package:flutter/material.dart';

class DrawerCategories extends StatefulWidget {
  const DrawerCategories({super.key});

  @override
  State<DrawerCategories> createState() => _DrawerCategoriesState();
}

class _DrawerCategoriesState extends State<DrawerCategories> {
  final List<Tab> tabs = [
    const Tab(text: 'MEN'),
    const Tab(text: 'WOMEN'),
    const Tab(text: 'FURNISINGS'),
    const Tab(text: 'SPORT'),
    // Add more tabs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.search), // Add your desired icon here
              onPressed: () {
                // Implement the desired action when the icon is pressed
                print('Search button pressed!');
              },
            )
          ],
          title: const Text('Categories'),
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Content for Men')),
            Center(child: Text('Content for Women')),
            Center(child: Text('Content for Furnishings')),
            Center(child: Text('Content for Sport')),
          ],
        ),
      ),
    );
  }
}
