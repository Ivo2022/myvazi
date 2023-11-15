import 'package:flutter/material.dart';

class DrawerFurnishings extends StatefulWidget {
  const DrawerFurnishings({super.key});

  @override
  State<DrawerFurnishings> createState() => _DrawerFurnishingsState();
}

class _DrawerFurnishingsState extends State<DrawerFurnishings> {
  final List<Tab> tabs = [
    const Tab(text: 'SITTING ROOM'),
    const Tab(text: 'BEDROOM'),
    const Tab(text: 'BATHROOM'),
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
          title: const Text('Furnishings'),
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Content for sitting room')),
            Center(child: Text('Content for Bedroom')),
            Center(child: Text('Content for Bathroom')),
          ],
        ),
      ),
    );
  }
}
