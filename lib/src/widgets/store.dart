import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/utils/confirm_delete.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String ipAddress = "192.168.43.65";
  int seller = 152;
  late Future<Map<String, dynamic>> data;
  Map? ourStoreMap;
  Map? yo;
  int positionedTab = 0;
  int? hoverPosition;
  List productsShown = [];

  @override
  void initState() {
    super.initState();
    storeMap.addListener(() {
      if (storeMap.value.isNotEmpty) {
        setState(() {
          ourStoreMap = storeMap.value;
          yo = ourStoreMap!.values.last;
        });
        Map tabMap = yo!.values.elementAt(0);
        List prodList = ourStoreMap!.values.first;
        List singleCategory = tabMap.values.last.split(',').toList();
        print(prodList);
        for (var i = 0; i < singleCategory.length; i++) {
          for (var j = 0; j < prodList.length; j++) {
            Map prodInput = prodList[j];
            List prodInptValue = prodInput.values.first;
            Map productInputDdetail = prodInptValue.elementAt(0);

            print(productInputDdetail);
            print('----------------------');
            print(singleCategory);
            if (productInputDdetail.values.elementAt(0).toString() ==
                singleCategory[i].toString()) {
              setState(() {
                productsShown.add(prodInput);
              });
            }
          }
        }
      }
    });
    parseSubcategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(MediaQuery.sizeOf(context).width * .1,
                0, MediaQuery.sizeOf(context).width * .1, 0),
            child: yo == null
                ? Container()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: yo!.values.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map tabMap = yo!.values.elementAt(index);
                      String tabName = tabMap.values.elementAt(1);

                      return InkWell(
                        onTap: () {
                          setState(() {
                            productsShown = [];
                            positionedTab = index;
                          });
                          List prodList = ourStoreMap!.values.first;
                          // print(prodList);

                          List singleCategory =
                              tabMap.values.last.split(',').toList();
                          // print(singleCategory);

                          for (var i = 0; i < singleCategory.length; i++) {
                            // print('object');
                            for (var j = 0; j < prodList.length; j++) {
                              Map prodInput = prodList[j];
                              List prodInptValue = prodInput.values.first;
                              Map productInputDdetail =
                                  prodInptValue.elementAt(0);

                              // print(productInputDdetail.values.elementAt(0));
                              if (productInputDdetail.values
                                      .elementAt(0)
                                      .toString() ==
                                  singleCategory[i].toString()) {
                                setState(() {
                                  productsShown.add(prodInput);
                                });
                                //print(productsShown);
                              }
                              // if(prodInptValue.v)
                            }
                            // Map firstProductMap = prodList.first;
                            // List firstInput = firstProductMap.values.first;
                            // Map prodDetailsMap = firstInput.elementAt(0);
                            // // if(singleCategory[index] == )
                            // print(prodDetailsMap);
                            // var prodId = prodDetailsMap.values.first;

                            //print(prodId);
                            // if(prodList.)
                          }

                          //print(singleCategory);
                        },
                        onHover: (s) {
                          setState(() {
                            hoverPosition = index;
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
                                  tabName.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
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
          productsShown == []
              ? const SizedBox()
              : SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.9,
                  child: ListView.builder(
                      itemCount: productsShown == [] ? 0 : productsShown.length,
                      itemBuilder: (BuildContext context, int index) {
                        List prodInptValue = productsShown[index].values.last;
                        String price = '';
                        String name = "";
                        String purpose = '';

                        List detailsList = productsShown[index].values.first;
                        Map detailsMap = detailsList.first;
                        price = detailsMap.values.elementAt(4).toString();
                        name = detailsMap.values.elementAt(2).toString();
                        purpose = detailsMap.values.elementAt(3).toString();
                        // print(detailsMap.values.elementAt(0));

                        Map image = prodInptValue.first;
                        List ImageList = image.values.toList();

                        for (var i = 2; i > -1; i--) {
                          if (!ImageList.elementAt(i)
                              .toString()
                              .contains('http')) {
                            ImageList.removeAt(i);
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 10.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      21.0, 0.0, 21.0, 0.0),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: CarouselSlider(
                                      options: CarouselOptions(height: 400.0),
                                      items: ImageList.map((i) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 1.0),
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                child: i.isNotEmpty
                                                    ? CachedNetworkImage(
                                                        fit: BoxFit.fitHeight,
                                                        imageUrl: i)
                                                    : CachedNetworkImage(
                                                        fit: BoxFit.fitHeight,
                                                        imageUrl: "",
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircularProgressIndicator()));
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          21.0, 0.0, 21.0, 2.0),
                                      child: Text(
                                        name,
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          21.0, 0.0, 21.0, 0.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            purpose,
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          21.0, 0.0, 21.0, 2.0),
                                      child: Text(
                                        price,
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          MediaQuery.sizeOf(context).width *
                                              0.3,
                                          MediaQuery.sizeOf(context).width *
                                              0.0,
                                          MediaQuery.sizeOf(context).width *
                                              0.0,
                                          MediaQuery.sizeOf(context).width *
                                              0.04),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _showConfirmDelete(context);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red[700]!),
                                          // You can customize other button properties here, like text color, padding, etc.
                                        ),
                                        child: const Text(
                                          'Remove',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  12, // Font size of the text
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
        ],
      ),
    );
  }
}

void _showConfirmDelete(BuildContext context) {
  showConfirmDelete(
    context,
    'Delete Item',
    'Are you sure you want to delete this item?',
    () {
      // Perform deletion logic here
      // TODO: Implement deletion action
      print('Item deleted!');
    },
  );
}
