import 'package:flutter/material.dart';
import 'package:myvazi/src/providers/app_state_manager.dart';
import 'package:myvazi/src/screens/profile.dart';
import 'package:myvazi/src/utils/providers.dart';
import 'package:myvazi/src/widgets/drawer_categories.dart';
import 'package:myvazi/src/widgets/drawer_furnishings.dart';
import 'package:myvazi/src/widgets/drawer_men.dart';
import 'package:myvazi/src/widgets/drawer_purchases.dart';
import 'package:myvazi/src/widgets/drawer_sales.dart';
import 'package:myvazi/src/widgets/drawer_women.dart';
import 'package:provider/provider.dart';

class DrawerActions extends StatefulWidget {
  const DrawerActions({super.key});

  @override
  State<DrawerActions> createState() => _DrawerActionsState();
}

class _DrawerActionsState extends State<DrawerActions> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserDataProvider>(context, listen: false);
    userProvider.fetchUsersData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserDataProvider>(context);

    return Drawer(
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          // Remove border radius
          borderRadius: BorderRadius.zero,
        ),
        child: ListView(
          // padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
                // Remove border radius from DrawerHeader
                borderRadius: BorderRadius.zero,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                          radius: 36.0,
                          backgroundImage:
                              AssetImage('assets/images/image1.jpg')),
                      const SizedBox(width: 10.0),
                      if (userProvider.users != null)
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Row(
                                children: [
                                  Text(userProvider.users!.userName),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.04),
                              child: Row(
                                children: [
                                  Text(userProvider.users!.userPhone),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        const Center(
                          child: Text("No Users"),
                        ),
                    ],
                  ),
                  //const SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.12),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()),
                        );
                        // Pop to the first screen
                        //Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('Account'),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Provider.of<AppStateManagerProvider>(context, listen: false)
                    .setSelectedScreenIndex(0);
                Navigator.pop(context); // Close the drawer
              },
              // onTap: () {
              //   Navigator.pop(context); // Close the drawer
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => const FrontPage()),
              //   );
              // },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'By Specific Categories',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Categories'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DrawerCategories()),
                );
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'By People',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.man),
              title: const Text('Men'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DrawerMen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.woman),
              title: const Text('Women'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DrawerWomen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.child_care_rounded),
              title: const Text('Furnishings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DrawerFurnishings()),
                );
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'Your Transactions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Purchases'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DrawerPurchases()),
                );
              },
            ),
            ListTile(
              /* leading: const FaIcon(
                FontAwesomeIcons.dollarSign,
                size: 50.0,
                color: Colors.green, // Customize the color if needed
              ),
               */
              leading: const Icon(Icons.monetization_on),
              title: const Text('Sales'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DrawerSales()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
