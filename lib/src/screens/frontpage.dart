import 'package:flutter/material.dart';
import 'package:myvazi/src/models/cart_data.dart';
import 'package:myvazi/src/utils/drawer_actions.dart';
import 'package:myvazi/src/models/data.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:myvazi/src/widgets/my_cart.dart';
import 'package:myvazi/src/widgets/product_view.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final ShoppingCart cart = ShoppingCart();

  final List<Item> data = [
    Item(
        title: 'Shoes',
        desc: 'Lorem ipsum dolor sit amet...',
        amount: 50000,
        image: 'assets/images/image1.jpg',
        seller: 'Seller One',
        rating: 4,
        tag: 'image1'),
    Item(
        title: 'Bags',
        desc: 'Lorem ipsum dolor sit amet...',
        amount: 20000,
        image: 'assets/images/image2.jpg',
        seller: 'Seller Two',
        rating: 5,
        tag: 'image2'),
    Item(
        title: 'Shirts',
        desc: 'Lorem ipsum dolor sit amet...',
        amount: 40000,
        image: 'assets/images/image3.jpg',
        seller: 'Seller Three',
        rating: 2,
        tag: 'image3'),
    Item(
        title: 'Wallets',
        desc: 'Lorem ipsum dolor sit amet...',
        amount: 15000,
        image: 'assets/images/image4.jpg',
        seller: 'Seller Four',
        rating: 1,
        tag: 'image4'),
    Item(
        title: 'Shorts',
        desc: 'Lorem ipsum dolor sit amet...',
        amount: 17000,
        image: 'assets/images/image5.jpg',
        seller: 'Seller Five',
        rating: 4,
        tag: 'image5'),
    Item(
        title: 'Bags',
        desc: 'Lorem ipsum dolor sit amet...',
        amount: 20000,
        image: 'assets/images/image2.jpg',
        seller: 'Seller Six',
        rating: 5,
        tag: 'image6'),
    Item(
        title: 'Wallets',
        desc: 'Lorem ipsum dolor sit amet...',
        amount: 15000,
        image: 'assets/images/image4.jpg',
        seller: 'Seller Seven',
        rating: 2,
        tag: 'image7'),
    Item(
        title: 'Shirts',
        desc: 'Lorem ipsum dolor sit amet...',
        amount: 40000,
        image: 'assets/images/image3.jpg',
        seller: 'Seller Eight',
        rating: 3,
        tag: 'image8'),
  ];
  final List<Tab> tabs = [
    const Tab(text: 'ALL'),
    const Tab(text: 'MEN'),
    const Tab(text: 'WOMEN'),
    const Tab(text: 'FURNISHINGS'),
    const Tab(text: 'KIDS'),
    // Add more tabs as needed
  ];
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
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width *
                    0.1, // Left padding (0% of screen width)
                MediaQuery.of(context).size.height *
                    0.0, // Top padding (0% of screen height)
                MediaQuery.of(context).size.width *
                    0.15, // Right padding (50% of screen width)
                MediaQuery.of(context).size.height *
                    0.0, // Bottom padding (10% of screen height)
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
          ],
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
          ),
        ),
        drawer: const DrawerActions(),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Center(
                child: GridView.custom(
                  padding: const EdgeInsets.only(
                    bottom: 0.0,
                    left: 4.0,
                    right: 0.0,
                  ),
                  gridDelegate: SliverWovenGridDelegate.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    // repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: const [
                      // QuiltedGridTile(2, 3),
                      WovenGridTile(2 / 3),
                      WovenGridTile(
                        2 / 3,
                        crossAxisRatio: 1.0,
                        alignment: AlignmentDirectional.center,
                      ),
                    ],
                  ),
                  childrenDelegate:
                      SliverChildBuilderDelegate((context, index) {
                    if (index < data.length) {
                      return GestureDetector(
                        onTap: () {
                          Item selected = data[index];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductView(item: selected),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                data[index].image,
                                height:
                                    MediaQuery.of(context).size.height * 0.28,
                                width: MediaQuery.of(context).size.width * 0.48,
                                fit: BoxFit.cover,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    data[index].desc,
                                    style: const TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 4.0, 0.0, 0.0),
                                        child: Text(
                                          '${data[index].amount}',
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return null;
                    }
                  }),
                ),
              ),
            ),
            const Center(child: Text('Content for Men')),
            const Center(child: Text('Content for Women')),
            const Center(child: Text('Content for Furnishings')),
            const Center(child: Text('Content for Kids')),
          ],
        ),
      ),
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
