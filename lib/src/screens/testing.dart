import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myvazi/src/models/cart_data.dart';
import 'package:myvazi/src/utils/drawer_actions.dart';
import 'package:myvazi/src/widgets/my_cart.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/controllers/controllers.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  final ShoppingCart cart = ShoppingCart();
  List? ourHomeList;
  Map? home;
  Map? subcats;

  int positionedTab = 0;
  int positionedTabb = 0;
  int? hoverPosition;
  int? hoverPositioned;
  List subCatsShown = [];
  List productsShown = [];
  List? subCatProducts = [];

  List? subcatList = [];

  void homeData(int categoryInt, int subcategoryInt) {
    setState(() {
      home = ourHomeList!.elementAt(categoryInt);
      subcatList = home!.values.last;
      subcats = subcatList!.elementAt(subcategoryInt);
      subCatProducts = subcats!.values.elementAt(2);
    });
  }

  @override
  void initState() {
    super.initState();
    homeList.addListener(() {
      if (homeList.value.isNotEmpty) {
        setState(() {
          ourHomeList = homeList.value;
          homeData(0, 0);
        });
        //print(subCatProducts);

        if (ourHomeList != null) {
          List singleCatList = home!.values.last;
          for (var i = 0; i < singleCatList.length; i++) {
            for (var j = 0; j < ourHomeList!.length; j++) {
              home = ourHomeList!.elementAt(j);
              String tabName = home!.values.elementAt(0);
              // Filter the data for the target main category
              List<dynamic> targetMainCatData = ourHomeList!
                  .where((element) => element['maincat_name'] == tabName)
                  .toList();

              // Extract subcategories for the target main category
              List<dynamic> subcategories = targetMainCatData.isNotEmpty
                  ? targetMainCatData.first['subcategory_details']
                  : [];
            }
          }
        }
      }
    });
    fetchMaincategories();
  }

  void _showImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: 'imageTag',
              child: Image.asset(
                'assets/images/image1.jpg',
                fit: BoxFit
                    .cover, // Adjust this to control the image's appearance
              ),
            ),
          ),
        );
      },
    );
  }

  void removeFromCart(CartItem cartItem) {
    setState(() {
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
      } else {
        cart.items.remove(cartItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            width * 0.1, // Left padding (0% of screen width)
            height * 0.0, // Top padding (0% of screen height)
            width * 0.15, // Right padding (50% of screen width)
            height * 0.0, // Bottom padding (10% of screen height)
          ),
          child: IconButton(
            icon: Image.asset(
                'assets/icons/myvazi_app_logo.png'), // Add your desired icon here
            onPressed: () {
              // Implement the desired action when the icon is pressed
              print('Icon pressed!');
            },
          ),
        ),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CartScreen(
                        cart: cart,
                        removeFromCart: removeFromCart,
                        addToCart: (Product) {},
                      )),
            );
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
      ]),
      drawer: const DrawerActions(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(MediaQuery.sizeOf(context).width * .1,
                0, MediaQuery.sizeOf(context).width * .1, 0),
            child: home == null
                ? Container()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ourHomeList?.length,
                    itemBuilder: (BuildContext context, int index) {
                      home = ourHomeList!.elementAt(index);
                      String tabName = home!.values.elementAt(0);

                      return InkWell(
                        onTap: () {
                          setState(() {
                            positionedTab = index;
                            positionedTabb = 0;
                          });
                          homeData(index, 0);
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
                                  padding: const EdgeInsets.fromLTRB(
                                      1.0, 16.0, 1.0, 0.0),
                                  child: Text(
                                    tabName.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              index == positionedTab
                                  ? Container(
                                      width: tabName.characters.length * 6,
                                      height: 3,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[800]),
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
          ),
          Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(MediaQuery.sizeOf(context).width * .1,
                0, MediaQuery.sizeOf(context).width * .1, 0),
            child: subcats == null
                ? Container()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: subcatList?.length,
                    itemBuilder: (BuildContext context, int indexed) {
                      subcats = subcatList!.elementAt(indexed);
                      String subtabName = subcats!.values.elementAt(1);

                      return InkWell(
                        onTap: () {
                          setState(() {
                            positionedTabb = indexed;
                          });
                          homeData(positionedTab, indexed);
                        },
                        onHover: (s) {
                          setState(() {
                            hoverPosition = indexed;
                          });
                        },
                        hoverColor: Colors.grey[200],
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                height: 1,
                              ),
                              Center(
                                child: Text(
                                  subtabName.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              indexed == positionedTabb
                                  ? Container(
                                      width: subtabName.characters.length * 6,
                                      height: 3,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[800]),
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
          ),
          subCatProducts!.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: height * 0.9,
                  child: ListView.builder(
                    itemCount: subCatProducts!.length,
                    itemBuilder: (BuildContext context, int indexing) {
                      Map subCatprods = subCatProducts![indexing];
                      String price = subCatprods.values.elementAt(2).toString();
                      String name = subCatprods.values.elementAt(1);
                      List<String> prodImages = [];
                      for (var i = 3; i < 6; i++) {
                        if (subCatprods.values
                            .elementAt(i)
                            .toString()
                            .contains('http')) {
                          prodImages.add(subCatprods.values.elementAt(i));
                        }
                      }
                      return Padding(
                        padding: EdgeInsets.fromLTRB(width * 0.01, height * 0.0,
                            width * 0.01, height * 0.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: CarouselSlider(
                                  options:
                                      CarouselOptions(height: height * 0.20),
                                  items: prodImages.map((i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 1.0),
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: CachedNetworkImage(
                                                fit: BoxFit.fitHeight,
                                                imageUrl: i));
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: width * 0.1),
                                    child: Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.01),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        width * 0.04,
                                        height * 0.0,
                                        width * 0.04,
                                        height * 0.0),
                                    child: Text(
                                      price,
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      )),
    );
  }
}

class BackGroundTile extends StatelessWidget {
  final Color backgroundColor;
  final IconData icondata;

  const BackGroundTile(
      {super.key, required this.backgroundColor, required this.icondata});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.15, horizontal: 0.15),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/image1.jpg',
                      height: 180.0,
                      fit: BoxFit.cover,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Lorem ipsum...',
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Text(
                              '${50000}',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
