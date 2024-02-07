import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/providers/app_state_manager.dart';
import 'package:myvazi/src/screens/profile.dart';
import 'package:myvazi/src/utils/providers.dart';
import 'package:myvazi/src/widgets/drawer_categories.dart';
import 'package:myvazi/src/widgets/drawer_details.dart';
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
  List<dynamic>? ourMainCatList;
  Map? drawer;
  int positionedTab = 0;
  int? hoverPosition;
  String tabName = '';
  int currentPage = 1;

  void drawerData(int categoryInt) {
    Map? drawer = ourMainCatList!
        .elementAt(categoryInt); // Obtain your drawer details here
    String drawerName = drawer!.values.elementAt(0);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(drawer: drawer, tabs: drawerName),
      ),
    );
  }

  // void drawerData(int categoryInt) {
  //   setState(() {
  //     drawer = ourMainCatList!.elementAt(categoryInt);
  //     Navigator.
  //   });
  // }

  @override
  void initState() {
    super.initState();
    homeList.addListener(() {
      if (homeList.value.isNotEmpty) {
        setState(() {
          ourMainCatList = homeList.value;
          //drawerData(0); // Initialize with the first category
        });
      }
    });
    fetchMaincategories();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double sizeWidth =
        screenWidth < 480 ? screenWidth * 0.1 : screenWidth * 0.04;
    final sellerProvider = Provider.of<SellerDataProvider>(context);
    return Drawer(
      elevation: 0,
      child: ourMainCatList == null
          ? Container()
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 120, // Adjust as needed
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: sizeWidth,
                            backgroundImage: const AssetImage(
                                'assets/images/default_image.png'),
                          ),
                          const SizedBox(width: 10.0),
                          sellerProvider.sellers != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(sellerProvider.sellers!.userName),
                                    Text(sellerProvider.sellers!.userPhone),
                                  ],
                                )
                              : const Center(
                                  child: Text("No Users"),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                const Center(
                  child: Text(
                    'By Specific Categories',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
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
                // const Center(
                //   child: Text(
                //     'By People',
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                // ),
                // const Divider(),
                // ...ourMainCatList!.map((drawer) {
                //   String drawerName = drawer.values.elementAt(0);
                //   tabName = capitalizeFirstLetter(drawerName.toLowerCase());
                //   int index = ourMainCatList!.indexOf(drawer);
                //   return Container(
                //     height: 27.0,
                //     child: Material(
                //       color: index == hoverPosition
                //           ? Colors.grey[200]
                //           : Colors.transparent,
                //       child: InkWell(
                //         onTap: () {
                //           setState(() {
                //             positionedTab = index;
                //           });
                //           drawerData(index);
                //         },
                //         child: ListTile(
                //           title: Padding(
                //             padding: const EdgeInsets.only(left: 16.0),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               //mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Text(
                //                   tabName,
                //                   style: const TextStyle(fontSize: 13.0),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   );
                // }),
                const Center(
                  child: Text(
                    'Your Transactions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
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
                  leading: const Icon(Icons.monetization_on),
                  title: const Text('Sales'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DrawerSales()),
                    );
                  },
                ),
              ],
            ),
    );

    // return Drawer(
    //   elevation: 0,
    //   child: ourMainCatList == null
    //       ? Container()
    //       : Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.only(left: 33.0, top: 40.0),
    //               child: Row(
    //                 children: [
    //                   CircleAvatar(
    //                       radius: sizeWidth,
    //                       backgroundImage: const AssetImage(
    //                           'assets/images/default_image.png')),
    //                   const SizedBox(width: 10.0),
    //                   if (sellerProvider.sellers != null)
    //                     Column(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Padding(
    //                           padding:
    //                               EdgeInsets.only(left: screenWidth * 0.03),
    //                           child: Row(
    //                             children: [
    //                               Text(sellerProvider.sellers!.userName),
    //                             ],
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding:
    //                               EdgeInsets.only(left: screenWidth * 0.04),
    //                           child: Row(
    //                             children: [
    //                               Text(sellerProvider.sellers!.userPhone),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     )
    //                   else
    //                     const Center(
    //                       child: Text("No Users"),
    //                     ),
    //                 ],
    //               ),
    //             ),
    //             const Divider(),
    //             const Padding(
    //               padding: EdgeInsets.only(left: 16.0),
    //               child: Text(
    //                 'By Specific Categories',
    //                 style: TextStyle(fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             const Divider(),
    //             ListTile(
    //               leading: const Icon(Icons.list_alt),
    //               title: const Text('Categories'),
    //               onTap: () {
    //                 Navigator.pop(context); // Close the drawer
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => const DrawerCategories()),
    //                 );
    //               },
    //             ),
    //             const Divider(),
    //             const Padding(
    //               padding: EdgeInsets.only(left: 16.0),
    //               child: Text(
    //                 'By People',
    //                 style: TextStyle(fontWeight: FontWeight.bold),
    //               ),
    //             ),
    // const Divider(),
    // ...ourMainCatList!.map((drawer) {
    //   String drawerName = drawer.values.elementAt(0);
    //   tabName = capitalizeFirstLetter(drawerName.toLowerCase());
    //   int index = ourMainCatList!.indexOf(drawer);
    //   return Container(
    //     height: 27.0,
    //     child: Material(
    //       color: index == hoverPosition
    //           ? Colors.grey[200]
    //           : Colors.transparent,
    //       child: InkWell(
    //         onTap: () {
    //           setState(() {
    //             positionedTab = index;
    //           });
    //           drawerData(index);
    //         },
    //         child: ListTile(
    //           title: Padding(
    //             padding: const EdgeInsets.only(left: 16.0),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               //mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text(
    //                   tabName,
    //                   style: const TextStyle(fontSize: 13.0),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }),
    //             const Divider(),
    //             const Padding(
    //               padding: EdgeInsets.only(left: 16.0),
    //               child: Text(
    //                 'Your Transactions',
    //                 style: TextStyle(fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             const Divider(),
    //             ListTile(
    //               leading: const Icon(Icons.shopping_bag),
    //               title: const Text('Purchases'),
    //               onTap: () {
    //                 Navigator.pop(context); // Close the drawer
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => const DrawerPurchases()),
    //                 );
    //               },
    //             ),
    //             ListTile(
    //               /* leading: const FaIcon(
    //           FontAwesomeIcons.dollarSign,
    //           size: 50.0,
    //           color: Colors.green, // Customize the color if needed
    //         ),
    //          */
    //               leading: const Icon(Icons.monetization_on),
    //               title: const Text('Sales'),
    //               onTap: () {
    //                 Navigator.pop(context); // Close the drawer
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => const DrawerSales()),
    //                 );
    //               },
    //             ),
    //           ],
    //         ),
    // );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
