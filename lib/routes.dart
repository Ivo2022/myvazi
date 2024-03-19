// import 'package:flutter/material.dart';
// import 'package:myvazi/src/providers/app_state_manager.dart';
// import 'package:myvazi/src/screens/frontpage.dart';
// import 'package:myvazi/src/screens/profile.dart';
// import 'package:myvazi/src/screens/post.dart';
// import 'package:myvazi/src/screens/chat.dart';
// import 'package:myvazi/src/screens/sale.dart';
// import 'package:myvazi/src/widgets/sign_in_page.dart';
// import 'package:provider/provider.dart';

// class Routing extends StatefulWidget {
//   const Routing({super.key});

//   @override
//   State<Routing> createState() => _RoutingState();
// }

// class _RoutingState extends State<Routing> {
//   Widget _buildScreenContent(int selectedScreenIndex) {
//     switch (selectedScreenIndex) {
//       case 0:
//         return const FrontPage();
//       case 1:
//         return const Post();
//       case 2:
//         return const Sale();
//       case 3:
//         return const Chat();
//       case 4:
//         return const SignInPage();
//       default:
//         return Container(); // Placeholder for default case
//     }
//   }

//   void _handleBottomNavBarTap(BuildContext context,
//       AppStateManagerProvider appStateManager, int index) {
//     appStateManager.setSelectedScreenIndex(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appStateManager = Provider.of<AppStateManagerProvider>(context);
//     final selectedScreenIndex = appStateManager.selectedScreenIndex;

//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: _buildScreenContent(selectedScreenIndex),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: Colors.white,
//           currentIndex: selectedScreenIndex,
//           onTap: (index) {
//             _handleBottomNavBarTap(context, appStateManager, index);
//           },
//           type: BottomNavigationBarType
//               .fixed, // This ensures all labels are shown
//           showSelectedLabels: true, // Show labels for selected items
//           showUnselectedLabels: false, // Show labels for unselected items

//           items: [
//             const BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.home,
//                 color: Colors.black,
//               ),
//               label: 'Home',
//             ),
//             const BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.add,
//                 color: Colors.black,
//               ),
//               label: 'Post',
//             ),
//             BottomNavigationBarItem(
//               icon: Image.asset('assets/icons/sales.png'),
//               label: 'Sale',
//             ),
//             const BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.chat,
//                 color: Colors.black,
//               ),
//               label: 'Chat',
//             ),
//             const BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.person,
//                 color: Colors.black,
//               ),
//               label: 'Profile',
//             ),
//           ],
//           // Set the text style for the labels
//           selectedItemColor: Colors.black, // Set the selected text color
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:myvazi/src/forms/signin_form.dart';
import 'package:myvazi/src/providers/app_state_manager.dart';
import 'package:myvazi/src/providers/auth_state_provider.dart';
import 'package:myvazi/src/screens/frontpage.dart';
import 'package:myvazi/src/screens/profile.dart';
import 'package:myvazi/src/screens/post.dart';
import 'package:myvazi/src/screens/chat.dart';
import 'package:myvazi/src/screens/sale.dart';
import 'package:myvazi/src/widgets/sign_in_page.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, required this.initialIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthState>(context, listen: false);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const FrontPage(),
          const Post(),
          const Sale(),
          const Chat(),
          !authProvider.isLoggedIn
              ? SignInForm(
                  onVerificationSuccess: (int newIndex) {
                    _onItemTapped(newIndex);
                  },
                )
              : const Profile(phoneNo: ""),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.black),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/sales.png'),
            label: 'Sale',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.black),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
      ),
    );
  }
}



// class Routing extends StatelessWidget {
//   const Routing({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<AppStateManagerProvider>(
//       create: (context) => AppStateManagerProvider(),
//       child: const MainScreen(
//         initialIndex: 0,
//       ),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   final int initialIndex;
//   const MainScreen({super.key, required this.initialIndex});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex;
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthState>(context, listen: false);

//     List<Widget> widgetOptions = [
//       const FrontPage(),
//       const Post(),
//       const Sale(),
//       const Chat(),
//       !authProvider.isLoggedIn
//           ? SignInForm(
//               onVerificationSuccess: (int) {
//                 _onItemTapped(int);
//               },
//             )
//           : const Profile(phoneNo: "")
//     ];

//     final selectedWidget = widgetOptions.elementAt(_selectedIndex);

//     return Scaffold(
//       body: selectedWidget,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: <BottomNavigationBarItem>[
//           const BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//               color: Colors.black,
//             ),
//             label: 'Home',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(
//               Icons.add,
//               color: Colors.black,
//             ),
//             label: 'Post',
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset('assets/icons/sales.png'),
//             label: 'Sale',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(
//               Icons.chat,
//               color: Colors.black,
//             ),
//             label: 'Chat',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(
//               Icons.person,
//               color: Colors.black,
//             ),
//             label: 'Profile',
//           ),
//         ],
//         selectedItemColor: Colors.black, // Set the selected text color
//       ),
//     );
//   }
// }
