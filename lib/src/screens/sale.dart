import 'package:flutter/material.dart';
import 'package:myvazi/src/models/data.dart';
import 'package:myvazi/src/services/rating.dart';

class Sale extends StatefulWidget {
  const Sale({super.key});

  @override
  State<Sale> createState() => _SaleState();
}

class _SaleState extends State<Sale> {
  final List<Item> data = [
    Item(
        title: 'Shoes',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 50000,
        image: 'assets/images/image1.jpg',
        seller: 'Seller One',
        rating: 4.1,
        tag: 'image1'),
    Item(
        title: 'Bags',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 20000,
        image: 'assets/images/image2.jpg',
        seller: 'Seller Two',
        rating: 5.0,
        tag: 'image2'),
    Item(
        title: 'Shirts',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 40000,
        image: 'assets/images/image3.jpg',
        seller: 'Seller Three',
        rating: 2.5,
        tag: 'image3'),
    Item(
        title: 'Wallets',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 15000,
        image: 'assets/images/image4.jpg',
        seller: 'Seller Four',
        rating: 1.8,
        tag: 'image4'),
    Item(
        title: 'Shorts',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 17000,
        image: 'assets/images/image5.jpg',
        seller: 'Seller Five',
        rating: 4.4,
        tag: 'image5'),
    Item(
        title: 'Bags',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 20000,
        image: 'assets/images/image2.jpg',
        seller: 'Seller Six',
        rating: 3.5,
        tag: 'image6'),
    Item(
        title: 'Wallets',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 15000,
        image: 'assets/images/image4.jpg',
        seller: 'Seller Seven',
        rating: 2.7,
        tag: 'image7'),
    Item(
        title: 'Shirts',
        desc:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        amount: 40000,
        image: 'assets/images/image3.jpg',
        seller: 'Seller Eight',
        rating: 3.8,
        tag: 'image8'),
  ];
  final List<Tab> maintabs = [
    const Tab(text: 'ALL'),
    const Tab(text: 'MEN'),
    const Tab(text: 'WOMEN'),
    const Tab(text: 'FURNISHINGS'),
    const Tab(text: 'KIDS'),
    // Add more tabs as needed
  ];
  final List<Tab> alltabs = [
    const Tab(text: 'FORMAL TROUSERS'),
    const Tab(text: 'JEANS'),
    const Tab(text: 'SWEAT PANTS'),
    const Tab(text: 'CARGO PANTS'),
    const Tab(text: 'SHORTS'),
    const Tab(text: 'PANTS OFFER'),
    const Tab(text: 'KHAKI TROUSERS')
    // Add more tabs as needed
  ];
  final List<Tab> mentabs = [
    const Tab(text: 'FORMAL TROUSERS'),
    const Tab(text: 'JEANS'),
    const Tab(text: 'SWEAT PANTS'),
    const Tab(text: 'CARGO PANTS'),
    const Tab(text: 'SHORTS'),
    const Tab(text: 'PANTS OFFER'),
    // Add more tabs as needed
  ];
  final List<Tab> womentabs = [
    const Tab(text: 'FORMAL TROUSERS'),
    const Tab(text: 'JEANS'),
    const Tab(text: 'SWEAT PANTS'),
    const Tab(text: 'CARGO PANTS'),
    const Tab(text: 'SHORTS'),
    // Add more tabs as needed
  ];
  final List<Tab> furntabs = [
    const Tab(text: 'FORMAL TROUSERS'),
    const Tab(text: 'JEANS'),
    const Tab(text: 'SWEAT PANTS'),
    // Add more tabs as needed
  ];
  final List<Tab> kidtabs = [
    const Tab(text: 'FORMAL TROUSERS'),
    const Tab(text: 'JEANS'),
    const Tab(text: 'SWEAT PANTS'),
    const Tab(text: 'CARGO PANTS'),
    // Add more tabs as needed
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
                  Navigator.pushNamed(context, '/buy-now');
                },
              ),
              ListTile(
                leading: const Text('M', style: TextStyle(fontSize: 14.0)),
                onTap: () {
                  Navigator.pushNamed(context, '/buy-now');
                },
              ),
              ListTile(
                leading: const Text('XL', style: TextStyle(fontSize: 14.0)),
                onTap: () {
                  Navigator.pushNamed(context, '/buy-now');
                },
              ),
              ListTile(
                leading: const Text('XXL', style: TextStyle(fontSize: 14.0)),
                onTap: () {
                  Navigator.pushNamed(context, '/buy-now');
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
    // final cart = context.read<CartProvider>();
    // Provider.of<CartProvider>(context, listen: false).addToCart(product, 1, "");

    return DefaultTabController(
      length: maintabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: TabBar(
                  tabs: maintabs,
                  isScrollable: true,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  DefaultTabController(
                    length: alltabs
                        .length, // Number of tabs in the first DefaultTabController
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(56.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: AppBar(
                              bottom: TabBar(
                                tabs: alltabs,
                                isScrollable: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          // Add your tab content for the first DefaultTabController here
                          Center(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                double element = data[index].rating;
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 4.0),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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
                                                height: 320.0,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          21.0, 0.0, 21.0, 0.0),
                                                  child: Text(
                                                    data[index].desc,
                                                    style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          21.0, 0.0, 21.0, 2.0),
                                                      child: Text(
                                                        'By ${data[index].seller}',
                                                        style: const TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                    ),
                                                    StarRating(rating: element)
                                                  ],
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          21.0, 0.0, 21.0, 2.0),
                                                      child: Text(
                                                        '${data[index].amount}',
                                                        style: const TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons
                                                          .favorite_border_outlined),
                                                      onPressed: () {},
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons
                                                          .shopping_basket_outlined),
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
                                                            MaterialStateProperty
                                                                .all<
                                                                    Color>(Colors
                                                                        .yellow[
                                                                    700]!),
                                                        // You can customize other button properties here, like text color, padding, etc.
                                                      ),
                                                      child: const Text(
                                                        'Buy Now',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                12, // Font size of the text
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                          const Center(child: Text('Tab 3 Content')),
                          const Center(
                              child: Text('Sweat Pants content comes here!')),
                          // Content for Tab 4
                          const Center(
                              child: Text('Cargo Pants content comes here!')),
                          // Content for Tab 5
                          const Center(
                              child: Text('Shorts content comes here!')),
                          // Content for Tab 6
                          const Center(
                              child: Text('Pants Offer content comes here!')),
                          // Content for Tab 7
                          const Center(
                              child: Text(
                                  'Khaki Trousers Offer content comes here!')),
                        ],
                      ),
                    ),
                  ),
                  DefaultTabController(
                    length: mentabs
                        .length, // Number of tabs in the first DefaultTabController
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(56.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: AppBar(
                              bottom: TabBar(
                                tabs: mentabs,
                                isScrollable: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          // Add your tab content for the first DefaultTabController here
                          Center(
                            child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 4.0),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            data[index].image,
                                            height: 320.0,
                                            width: 270.0,
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data[index].desc,
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${data[index].amount}',
                                                      style: const TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 70.0),
                                                      child: IconButton(
                                                        icon: const Icon(Icons
                                                            .favorite_border_outlined),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons
                                                          .shopping_basket_outlined),
                                                      onPressed: () {},
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      child:
                                                          const Text('Buy Now'),
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
                          const Center(child: Text('Tab 2 Content')),
                          const Center(child: Text('Tab 3 Content')),
                          const Center(
                              child: Text('Sweat Pants content comes here!')),
                          // Content for Tab 4
                          const Center(
                              child: Text('Cargo Pants content comes here!')),
                          // Content for Tab 5
                          const Center(
                              child: Text('Shorts content comes here!')),
                        ],
                      ),
                    ),
                  ),
                  DefaultTabController(
                    length: womentabs
                        .length, // Number of tabs in the first DefaultTabController
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(56.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: AppBar(
                              bottom: TabBar(
                                tabs: womentabs,
                                isScrollable: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          // Add your tab content for the first DefaultTabController here
                          Center(
                            child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 4.0),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            data[index].image,
                                            height: 320.0,
                                            width: 270.0,
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data[index].desc,
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${data[index].amount}',
                                                      style: const TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 70.0),
                                                      child: IconButton(
                                                        icon: const Icon(Icons
                                                            .favorite_border_outlined),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons
                                                          .shopping_basket_outlined),
                                                      onPressed: () {},
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        _onTabTapped(context);
                                                      },
                                                      child:
                                                          const Text('Buy Now'),
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
                          const Center(child: Text('Tab 2 Content')),
                          const Center(child: Text('Tab 3 Content')),
                          const Center(
                              child: Text('Sweat Pants content comes here!')),
                          // Content for Tab 4
                          const Center(
                              child: Text('Cargo Pants content comes here!')),
                        ],
                      ),
                    ),
                  ),
                  DefaultTabController(
                    length: furntabs
                        .length, // Number of tabs in the first DefaultTabController
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(56.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: AppBar(
                              bottom: TabBar(
                                tabs: furntabs,
                                isScrollable: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          // Add your tab content for the first DefaultTabController here
                          Center(
                            child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 4.0),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            data[index].image,
                                            height: 320.0,
                                            width: 270.0,
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data[index].desc,
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${data[index].amount}',
                                                      style: const TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 70.0),
                                                      child: IconButton(
                                                        icon: const Icon(Icons
                                                            .favorite_border_outlined),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons
                                                          .shopping_basket_outlined),
                                                      onPressed: () {},
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        _onTabTapped(context);
                                                      },
                                                      child:
                                                          const Text('Buy Now'),
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
                          const Center(child: Text('Tab 2 Content')),
                          const Center(child: Text('Tab 3 Content')),
                        ],
                      ),
                    ),
                  ),
                  DefaultTabController(
                    length: kidtabs
                        .length, // Number of tabs in the first DefaultTabController
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(56.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: AppBar(
                              bottom: TabBar(
                                tabs: kidtabs,
                                isScrollable: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView( 
                        children: [
                          // Add your tab content for the first DefaultTabController here
                          Center(
                            child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 4.0),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            data[index].image,
                                            height: 320.0,
                                            width: 270.0,
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data[index].desc,
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${data[index].amount}',
                                                      style: const TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 70.0),
                                                      child: IconButton(
                                                        icon: const Icon(Icons
                                                            .favorite_border_outlined),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons
                                                          .shopping_basket_outlined),
                                                      onPressed: () {},
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        _onTabTapped(context);
                                                      },
                                                      child:
                                                          const Text('Buy Now'),
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
                          const Center(child: Text('Tab 2 Content')),
                          const Center(child: Text('Tab 3 Content')),
                          const Center(
                              child: Text('Sweat Pants content comes here!')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
