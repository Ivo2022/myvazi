import 'package:flutter/material.dart';
import 'package:myvazi/src/widgets/revenue.dart';
import 'package:myvazi/src/widgets/reviews.dart';
import 'package:myvazi/src/widgets/store.dart';
import 'package:myvazi/src/services/rating.dart';
import 'package:provider/provider.dart';
import 'package:myvazi/src/utils/providers.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> userData = {};

  String defaultImage = 'assets/images/default_image.jpg';

  @override
  void initState() {
    super.initState();
    final sellerProvider =
        Provider.of<SellerDataProvider>(context, listen: false);
    sellerProvider.fetchSellersData();
    final sellerRatingProvider =
        Provider.of<SellerRatingsProvider>(context, listen: false);
    sellerRatingProvider.fetchSellerRatingsData();
  }

  @override
  Widget build(BuildContext context) {
    // Access the User Data Provider using Provider.of
    final sellerProvider = Provider.of<SellerDataProvider>(context);
    final sellerRatingProvider = Provider.of<SellerRatingsProvider>(context);
    var username = sellerProvider.sellers?.userName;
    var phoneNo = sellerProvider.sellers?.userPhone;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double sizeWidth =
        screenWidth < 400 ? screenWidth * 0.1 : screenWidth * 0.04;
    double spacingBetween =
        screenWidth < 400 ? screenWidth * 0.01 : screenWidth * 0.3;

    return DefaultTabController(
      length: 3, // Set the number of tabs
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            // Adjust the height as needed
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: spacingBetween),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: sizeWidth, // Default radius for larger screens
                        backgroundImage:
                            const AssetImage('assets/images/default_image.png'),
                      ),
                    ],
                  ),
                ),
                if (username != null && phoneNo != null)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: spacingBetween),
                        child: Row(
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                fontSize: screenHeight * 0.02,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: spacingBetween),
                        child: Row(
                          children: [
                            Text(phoneNo),
                          ],
                        ),
                      ),
                      if (sellerRatingProvider.sellerRatings != null)
                        Padding(
                          padding: EdgeInsets.only(left: spacingBetween),
                          child: Row(
                            children: [
                              StarRating(
                                  rating: sellerRatingProvider
                                      .sellerRatings!.sellerStars),
                              Text(
                                  '(${sellerRatingProvider.sellerRatings!.sellerStars.toString()})')
                            ],
                          ),
                        )
                      else
                        const Center(
                          child: Text("No Reviews"),
                        ),
                    ],
                  )
                else
                  const Center(
                    child: Text("No Users"),
                  ),
                SizedBox(width: screenWidth * 0.03),
                TextButton.icon(
                  onPressed: () {
                    // Add your onPressed action here
                    Navigator.pushNamed(
                      context,
                      '/account-edit',
                      arguments: {
                        'defaultImage': defaultImage,
                        'username': username,
                        'phoneNo': phoneNo,
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                )
              ],
            ),
          ),
        ),
        body: const Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'REVIEWS'),
                Tab(text: 'STORE'),
                Tab(text: 'REVENUE'),
              ],
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 14.0), // Adjust label style
              // labelPadding: EdgeInsets.zero, // Remove label padding
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SupplierReview(),
                  Store(),
                  Revenue(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
