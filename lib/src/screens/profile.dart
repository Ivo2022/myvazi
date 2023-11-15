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

  String defaultImage = 'assets/images/image2.jpg';

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserDataProvider>(context, listen: false);
    userProvider.fetchUsersData();
    final sellerRatingProvider =
        Provider.of<SellerRatingsProvider>(context, listen: false);
    sellerRatingProvider.fetchSellerRatingsData();
  }

  @override
  Widget build(BuildContext context) {
    // Access the User Data Provider using Provider.of
    final userProvider = Provider.of<UserDataProvider>(context);
    final sellerRatingProvider = Provider.of<SellerRatingsProvider>(context);
    var username = userProvider.users?.userName;
    var phoneNo = userProvider.users?.userPhone;

    return DefaultTabController(
      length: 3, // Set the number of tabs
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.width * 0.12),
            // Adjust the height as needed
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: const Column(
                    children: [
                      CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              AssetImage('assets/images/image2.jpg')),
                    ],
                  ),
                ),
                if (username != null && phoneNo != null)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.04),
                        child: Row(
                          children: [
                            Text(username),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.03),
                        child: Row(
                          children: [
                            Text(phoneNo),
                          ],
                        ),
                      ),
                      if (sellerRatingProvider.sellerRatings != null)
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.04),
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
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    ),
                  ],
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
