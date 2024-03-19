import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';

//import 'package:myvazi/models/data.dart';

class AccountEdit extends StatefulWidget {
  const AccountEdit({super.key});

  @override
  State<AccountEdit> createState() => _AccountEditState();
}

class _AccountEditState extends State<AccountEdit> {
  final url = 'http://127.0.0.1:8000/myvazi/create/';
  final _formKey = GlobalKey<FormState>();
  String category = '';
  String subcategory = '';
  String name = '';
  double amount = 0.0;
  String defaultImage = 'assets/images/default_image.png';
  String initialCountry = 'KE'; // Set the initial country code as desired.
  final TextEditingController controller = TextEditingController();

  // Declare variables at the class level
  late String username;
  late String selectedImage;
  late String phoneNo;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments in the build method
    Map<String, dynamic>? arguments =
        (ModalRoute.of(context)!.settings.arguments ?? {})
            as Map<String, dynamic>?;

    // Initialize variables in the build method
    selectedImage = arguments?['selectedImage'] ?? defaultImage;
    username = arguments?['username'] ?? '';
    phoneNo = arguments?['phoneNo'] ?? '';

    TextEditingController usernameController =
        TextEditingController(text: username);
    TextEditingController phoneController =
        TextEditingController(text: phoneNo);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("UPDATE"),
            ),
          ),
        ],
        title: const Text('Edit Account'),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // Text widget
                SizedBox(
                  // Image.asset(selectedImage)
                  height: MediaQuery.of(context).size.height * 0.5,
                  // ignore: unnecessary_null_comparison
                  child: selectedImage != null
                      ? CachedNetworkImage(
                          imageUrl: selectedImage.isNotEmpty
                              ? selectedImage
                              : ServerConfig.defaultImageSquare,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        )
                      : Image.network(ServerConfig.defaultProfileImage),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: '+256...',
                    labelText: 'Phone Number',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
