import 'package:flutter/material.dart';
import 'package:myvazi/src/providers/app_state_manager.dart';
import 'package:myvazi/src/screens/frontpage.dart';
import 'package:myvazi/src/screens/profile.dart';
import 'package:myvazi/src/screens/post.dart';
import 'package:myvazi/src/screens/chat.dart';
import 'package:myvazi/src/screens/sale.dart';
import 'package:provider/provider.dart';

class Routing extends StatefulWidget {
  const Routing({super.key});

  @override
  State<Routing> createState() => _RoutingState();
}

class _RoutingState extends State<Routing> {
  Widget _buildScreenContent(int selectedScreenIndex) {
    switch (selectedScreenIndex) {
      case 0:
        return const FrontPage();
      case 1:
        return const Post();
      case 2:
        return const Sale();
      case 3:
        return const Chat();
      case 4:
        return const Profile();
      default:
        return Container(); // Placeholder for default case
    }
  }

  void _handleBottomNavBarTap(BuildContext context,
      AppStateManagerProvider appStateManager, int index) {
    appStateManager.setSelectedScreenIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManagerProvider>(context);
    final selectedScreenIndex = appStateManager.selectedScreenIndex;

    return Scaffold(
      body: Center(
        child: _buildScreenContent(selectedScreenIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: selectedScreenIndex,
        onTap: (index) {
          _handleBottomNavBarTap(context, appStateManager, index);
        },
        type:
            BottomNavigationBarType.fixed, // This ensures all labels are shown
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: false, // Show labels for unselected items

        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/sales.png'),
            label: 'Sale',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: Colors.black,
            ),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
