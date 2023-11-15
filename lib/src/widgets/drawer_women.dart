import 'package:flutter/material.dart';

class DrawerWomen extends StatefulWidget {
  const DrawerWomen({super.key});

  @override
  State<DrawerWomen> createState() => _DrawerWomenState();
}

class _DrawerWomenState extends State<DrawerWomen> {
  final List<Tab> tabs = [
    const Tab(text: 'DRESSES'),
    const Tab(text: 'SHOES'),
    const Tab(text: 'JACKETS'),
    const Tab(text: 'ACCESSORIES'),
    const Tab(text: 'TROUSERS'),
    const Tab(text: 'BAGS'),
    const Tab(text: 'SKIRTS'),
    const Tab(text: 'MORE SUITS'),
    const Tab(text: 'TOPS'),
    const Tab(text: 'UNDERWEAR'),
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
                print('Icon pressed!');
              },
            ),
            IconButton(
              icon: const Icon(
                  Icons.shopping_basket_outlined), // Add your desired icon here
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(),
                // );
                // Implement the desired action when the icon is pressed
                print('Icon pressed!');
              },
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'option1',
                    child: Text('Grid View'),
                  ),
                  const PopupMenuItem(
                    value: 'option2',
                    child: Text('List View'),
                  ),
                  const PopupMenuItem(
                    value: 'option3',
                    child: Text('Help'),
                  )
                ];
              },
              onSelected: (value) {
                // Handle menu item selection here
                print('Selected: $value');
              },
            ),
          ],
          title: const Text('Women'),
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Content for Dresses')),
            Center(child: Text('Content for Shoes')),
            Center(child: Text('Content for Jackets')),
            Center(child: Text('Content for Accessories')),
            Center(child: Text('Content for Trousers')),
            Center(child: Text('Content for Bags')),
            Center(child: Text('Content for Skirts')),
            Center(child: Text('Content for More suits')),
            Center(child: Text('Content for Tops')),
            Center(child: Text('Content for Underwear')),
          ],
        ),
      ),
    );
  }
}
