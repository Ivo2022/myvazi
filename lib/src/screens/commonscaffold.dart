import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const CommonScaffold({super.key, required this.body, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.yellow[700],
        currentIndex: currentIndex,
        // onTap: _onTabTapped,

        type: BottomNavigationBarType.fixed, // This ensures all labels are shown
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: false, // Show labels for unselected items

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black, ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.black, ),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/sales.png'),
            label: 'Sale',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.black, ),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black, ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
