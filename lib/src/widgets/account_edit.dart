import 'package:flutter/material.dart';

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
  String defaultImage = 'assets/images/image2.jpg';
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
    selectedImage = arguments?['defaultImage'] ?? '';
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
                  width: 300.0,
                  // ignore: unnecessary_null_comparison
                  child: selectedImage != null
                      ? Image.asset(selectedImage)
                      : Image.asset(defaultImage),
                ),
                SizedBox(
                  width: 300.0,
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                    ),
                  ),
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.32,
                  child: SizedBox(
                    width: 200.0,
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: '+256...',
                        labelText: 'Phone Number',
                      ),
                    ),
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
