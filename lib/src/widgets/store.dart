import 'package:flutter/material.dart';
import 'package:myvazi/src/utils/confirm_delete.dart';
import 'package:myvazi/src/utils/providers.dart';
import 'package:provider/provider.dart';

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
  TabController? _tabController;
  List<Widget> _tabViews = [];

  @override
  void initState() {
    super.initState();

    // Get the existing instance of SellerSubcatsProvider from the widget tree
    final sellerSubcatsProvider =
        Provider.of<SellerSubcatsProvider>(context, listen: false);

    // Call the fetchSubcategoriesData method on the existing instance
    sellerSubcatsProvider.fetchSubcategoriesData();
  }

  // Future<Map<String, dynamic>> fetchSubcategories() async {
  //   String url = Platform.isAndroid
  //       ? 'http://$ipAddress/twambale/api/testing.php'
  //       : 'http://localhost/twambale/api/testing.php';

  //   final Map<String, dynamic> requestData = {
  //     'action': 'getSellerSubCats',
  //     'arg1': seller,
  //   };
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Accept': "*/*",
  //       'connection': 'keep-alive',
  //     },
  //     body: jsonEncode(requestData),
  //   );

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to load data: ${response.statusCode}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sellerSubcatsProvider = Provider.of<SellerSubcatsProvider>(context);
    print("We are here: $sellerSubcatsProvider");
    return Container();
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
