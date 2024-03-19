import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/models/models.dart';
import 'package:myvazi/src/providers/user_provider.dart';
import 'package:myvazi/src/providers/sellers_provider.dart';

import 'package:myvazi/src/services/rating.dart';
import 'package:myvazi/src/models/data.dart';
import 'package:provider/provider.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  //final Map<String, dynamic> arguments;

  @override
  State<Testing> createState() => _ProductViewState();
}

class _ProductViewState extends State<Testing> {
  late List<dynamic> products;
  // Declare variables at the class level
  // late Map selectedProduct;
  // late List allProducts;
  // late String subcatName;

  late String subcatName;
  late int price;
  late String image;
  late String productName;
  late int productId;

  @override
  void initState() {
    super.initState();
    final sellerProvider =
        Provider.of<SellerDataProvider>(context, listen: false);
    //sellerProvider.fetchSellersData();
    final usersProvider = Provider.of<UserDataProvider>(context, listen: false);
    usersProvider.fetchUsersData();
    fetchSizesAndSetData();
    // products = widget.arguments['products'];
  }

  Future<void> fetchSizesAndSetData() async {
    try {
      List<Map<String, dynamic>> sizes = await SizesService.fetchAllSizes();
      setState(() {
        setSizesData(sizes); // Set sizes data to be used in the widget
      });
    } catch (e) {
      print('Error fetching sizes: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final sellerProvider = Provider.of<SellerDataProvider>(context);
    final usersProvider = Provider.of<UserDataProvider>(context);

    // Retrieve arguments in the build method
    Map<String, dynamic>? arguments =
        (ModalRoute.of(context)!.settings.arguments ?? {})
            as Map<String, dynamic>?;

    if (arguments == null) {
      return Container();
    } else {
      // selectedProduct = arguments['selectedProduct'] ?? {};
      // allProducts = arguments['allProducts'] ?? [];
      // subcatName = arguments['name'] ?? "";
      subcatName = arguments['name'] ?? "";
      price = arguments['price'] ?? "";
      image = arguments['image'] ?? "";
      productName = arguments['productName'] ?? "";
      productId = arguments['productId'] ?? "";

      // Use the selectedProduct and allProducts as needed

      var name = usersProvider.users?.name;
      var phone = usersProvider.users?.phone;
      var location = usersProvider.users?.location;
      var town = usersProvider.users?.town;
      //var price = widget.arguments['price'];

      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(subcatName),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Center(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle onTap for the selected product
                  },
                  child: Container(
                    height: screenHeight * 0.7,
                    margin:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: image.isNotEmpty
                        ? CachedNetworkImage(
                            height: screenHeight * 0.7,
                            width: screenWidth * 0.9,
                            fit: BoxFit.cover,
                            imageUrl: image,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/default_image.png',
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/default_image.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.04,
                          screenHeight * 0.01,
                          screenWidth * 0.0,
                          screenHeight * 0.0,
                        ),
                        child: Text(
                          productName,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              screenWidth * 0.04,
                              screenHeight * 0.01,
                              screenWidth * 0.0,
                              screenHeight * 0.0,
                            ),
                            child: Text(
                              price.toString(),
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite_border_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.shopping_basket_outlined),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Select the size",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: getSizesData().length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              try {
                                                Map<String, dynamic> sizes =
                                                    getSizesData()
                                                        .elementAt(index);
                                                String size =
                                                    sizes.values.elementAt(0);
                                                return ListTile(
                                                  leading: Text(
                                                    size,
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/billing-information',
                                                      arguments: {
                                                        'username': name,
                                                        'phoneNo': phone,
                                                        'location': location,
                                                        'town': town,
                                                        'selectedSize':
                                                            size, // Pass the selected size to the next screen
                                                        'price': price,
                                                      },
                                                    );
                                                  },
                                                );
                                              } catch (e) {
                                                // Handle the case where the index is out of range
                                                return null;
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Select the size",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: getSizesData().length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Map<String, dynamic> sizes =
                                                  getSizesData()
                                                      .elementAt(index);
                                              String size =
                                                  sizes.values.elementAt(0);
                                              int size_id =
                                                  sizes.values.elementAt(1);
                                              return ListTile(
                                                leading: Text(
                                                  size,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/billing-information',
                                                    arguments: {
                                                      'username': name,
                                                      'phoneNo': phone,
                                                      'location': location,
                                                      'town': town,
                                                      'selectedSize':
                                                          size, // Pass the selected size to the next screen
                                                      'size_id': size_id,
                                                      'price': price,
                                                      'productId': productId
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.yellow[700]!),
                              // You can customize other button properties here, like text color, padding, etc.
                            ),
                            child: const Text(
                              'Buy Now',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12, // Font size of the text
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
