import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/widgets/product_view.dart';
import 'package:myvazi/src/controllers/controllers.dart';

class DrawerMen extends StatefulWidget {
  const DrawerMen({super.key});

  @override
  State<DrawerMen> createState() => _DrawerMenState();
}

class _DrawerMenState extends State<DrawerMen> {
  List? ourdrawerMenList;
  List? innerdrawerCatList;
  Map? drawermen;
  Map? innerdrawerCatMap;
  Map? subcats;

  int positionedTab = 0;
  int? hoverPosition;
  List subCatsShown = [];
  List productsShown = [];
  List? subCatProducts = [];
  String imageUrlFromDatabase =
      'image1.jpg'; // Replace with the actual image name from your database

  List? productList = [];
  void drawerData(int categoryInt) {
    setState(() {
      drawermen = ourdrawerMenList!.elementAt(0);
      productList = drawermen!.values.last;
      subcats = productList!.elementAt(categoryInt);
      subCatProducts = subcats!.values.elementAt(3);
    });
  }

  @override
  void initState() {
    super.initState();
    drawerMenList.addListener(() {
      if (drawerMenList.value.isNotEmpty) {
        setState(() {
          ourdrawerMenList = drawerMenList.value;
          drawerData(0);
        });
      }
    });
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: frontAppBar(screenWidth, context),
      body: SingleChildScrollView(
          child: Column(
        children: [
          drawerCatTabs(screenWidth, screenHeight),
          subCatProducts!.isEmpty
              ? const Center(child: SizedBox())
              : frontProductDetails(screenHeight, screenWidth),
        ],
      )),
    );
  }

  PreferredSize frontAppBar(double screenWidth, BuildContext context) {
    double sizeWidth =
        screenWidth < 400 ? screenWidth * 0.08 : screenWidth * 0.03;
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          Container(
            // Adjust padding as needed
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/myvazi_app_logo.png',
                  fit: BoxFit.cover,
                ),
                SizedBox(
                    width: screenWidth *
                        0.007), // Adjust spacing between logo and other icons
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    print('Search pressed!');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_basket_outlined),
                  onPressed: () {},
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
                    print('Selected: $value');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container drawerCatTabs(double screenWidth, double screenHeight) {
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(screenWidth * .02, 0, screenWidth * .02, 0),
      child: drawermen == null
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: innerdrawerCatList?.length,
              itemBuilder: (BuildContext context, int index) {
                innerdrawerCatList = drawermen!.values.first;
                innerdrawerCatMap = innerdrawerCatList!.elementAt(index);
                String tabName = innerdrawerCatMap!.values.elementAt(1);
                //print(tabName);
                return InkWell(
                  onTap: () {
                    setState(() {
                      positionedTab = index;
                    });
                    drawerData(index);
                  },
                  onHover: (s) {
                    setState(() {
                      hoverPosition = index;
                    });
                  },
                  hoverColor: Colors.grey[200],
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 1,
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.01,
                            ),
                            child: Text(
                              tabName.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        index == positionedTab
                            ? Container(
                                width: tabName.characters.length * 6,
                                height: 3,
                                decoration:
                                    BoxDecoration(color: Colors.grey[800]),
                              )
                            : const SizedBox(
                                height: 1,
                              )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Center frontProductDetails(double screenHeight, double screenWidth) {
    return Center(
      child: SizedBox(
        height: screenHeight * 0.7,
        child: GridView.builder(
          gridDelegate: SliverWovenGridDelegate.count(
            crossAxisCount: 2,
            mainAxisSpacing: 1, // Vertical spacing between cards
            crossAxisSpacing: 1,
            pattern: [
              const WovenGridTile(2 / 3),
              const WovenGridTile(
                2 / 3,
                crossAxisRatio: 1.0,
                alignment: AlignmentDirectional.center,
              ),
            ],
          ),
          itemCount: subCatProducts!.length,
          itemBuilder: (BuildContext context, int indexing) {
            Map subCatprods = subCatProducts![indexing];
            double price = subCatprods.values.elementAt(2);
            String name = capitalizeFirstLetter(
                subCatprods.values.elementAt(0).toString());

            List<String> prodImages = [];
            for (var i = 3; i < 6; i++) {
              if (subCatprods.values.elementAt(i) != null &&
                  subCatprods.values.elementAt(i).toString().isNotEmpty) {
                prodImages.add('${subCatprods.values.elementAt(i)}');
              }
            }
            return Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.01,
                  screenHeight * 0.01, screenWidth * 0.01, screenHeight * 0.01),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(screenWidth * 0.04),
                    bottomRight: Radius.circular(screenWidth * 0.04),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(height: screenHeight * 0.25),
                        items: prodImages.map((i) {
                          return GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ProductView(
                              //       arguments: {
                              //         'name': name,
                              //         'price': price,
                              //         'image': i,
                              //       },
                              //     ),
                              //   ),
                              // );
                            },
                            child: Builder(
                              builder: (BuildContext context) {
                                // Check if the image is a network image or a local image
                                if (i.toString().contains('http')) {
                                  // Network image
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 231, 217, 61),
                                    ),
                                    child: CachedNetworkImage(
                                      height: screenHeight *
                                          0.25, // Adjust as needed
                                      width: double
                                          .infinity, // Take the full width available
                                      fit: BoxFit.cover,
                                      imageUrl: i,
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/default_image.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                } else {
                                  String localImagePath =
                                      '${ServerConfig.baseUrl}${ServerConfig.uploads}$i';
                                  // Local image
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01),
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    child: Image.file(
                                      File(localImagePath),
                                      height: screenHeight *
                                          0.25, // Adjust as needed
                                      width: double
                                          .infinity, // Take the full width available
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        'assets/images/default_image.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.01),
                              child: Text(
                                "By $name",
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: screenHeight * 0.017,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.01),
                              child: Text(
                                price.toString(),
                                style: TextStyle(
                                  fontSize: screenHeight * 0.026,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
