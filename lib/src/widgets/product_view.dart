import 'package:flutter/material.dart';
import 'package:myvazi/src/services/rating.dart';
import 'package:myvazi/src/models/data.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key, required this.item});

  final Item item;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final List<Item> data = [
    Item(
        title: 'Shoes',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 50000,
        image: 'assets/images/image1.jpg',
        seller: 'Seller One',
        rating: 4.2,
        tag: 'image1'),
    Item(
        title: 'Bags',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 20000,
        image: 'assets/images/image2.jpg',
        seller: 'Seller Two',
        rating: 4.8,
        tag: 'image2'),
    Item(
        title: 'Shirts',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 40000,
        image: 'assets/images/image3.jpg',
        seller: 'Seller Three',
        rating: 2.6,
        tag: 'image3'),
    Item(
        title: 'Wallets',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 15000,
        image: 'assets/images/image4.jpg',
        seller: 'Seller Four',
        rating: 1.6,
        tag: 'image4'),
    Item(
        title: 'Shorts',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 17000,
        image: 'assets/images/image5.jpg',
        seller: 'Seller Five',
        rating: 4.9,
        tag: 'image5'),
    Item(
        title: 'Bags',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 20000,
        image: 'assets/images/image2.jpg',
        seller: 'Seller Six',
        rating: 5.0,
        tag: 'image6'),
    Item(
        title: 'Wallets',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 15000,
        image: 'assets/images/image4.jpg',
        seller: 'Seller Seven',
        rating: 2.2,
        tag: 'image7'),
    Item(
        title: 'Shirts',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 40000,
        image: 'assets/images/image3.jpg',
        seller: 'Seller Eight',
        rating: 3.6,
        tag: 'image8'),
  ];

  void _onTabTapped(BuildContext context) {
    // Open the bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Select the size",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              ListTile(
                leading: const Text('L', style: TextStyle(fontSize: 14.0)),
                onTap: () {
                  Navigator.pushNamed(context, '/my-cart');
                },
              ),
              ListTile(
                leading: const Text('M', style: TextStyle(fontSize: 14.0)),
                onTap: () {
                  Navigator.pushNamed(context, '/my-cart');
                },
              ),
              ListTile(
                leading: const Text('XL', style: TextStyle(fontSize: 14.0)),
                onTap: () {
                  Navigator.pushNamed(context, '/my-cart');
                },
              ),
              ListTile(
                leading: const Text('XXL', style: TextStyle(fontSize: 14.0)),
                onTap: () {
                  Navigator.pushNamed(context, '/my-cart');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImage(BuildContext context, index) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: data[index].tag,
              child: Image.asset(
                data[index].image,
                fit: BoxFit
                    .cover, // Adjust this to control the image's appearance
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Jean Trousers'),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            double element = data[index].rating;
            return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showImage(context, index);
                        },
                        child: Hero(
                          tag: data[index].tag,
                          child: Image.asset(
                            data[index].image,
                            width: 270.0,
                            height: 400.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  21.0, 0.0, 21.0, 0.0),
                              child: Text(
                                data[index].desc,
                                style: const TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      21.0, 0.0, 21.0, 2.0),
                                  child: Text(
                                    'By ${data[index].seller}',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                StarRating(rating: element)
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      21.0, 0.0, 21.0, 2.0),
                                  child: Text(
                                    '${data[index].amount}',
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      Icons.favorite_border_outlined),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.shopping_basket_outlined),
                                  onPressed: () {
                                    _onTabTapped(context);
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _onTabTapped(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.yellow[700]!),
                                    // You can customize other button properties here, like text color, padding, etc.
                                  ),
                                  child: const Text(
                                    'Buy Now',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12, // Font size of the text
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }
}
