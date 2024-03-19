import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:intl/intl.dart';

//import 'package:myvazi/models/data.dart';

class BillingInformation extends StatefulWidget {
  const BillingInformation({super.key});

  @override
  State<BillingInformation> createState() => _BillingInformationState();
}

class _BillingInformationState extends State<BillingInformation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController productNameController = TextEditingController();

  String sizeName = '';
  String? location;
  String? phoneNo;
  String? town;

  int quantity = 1;
  int totalAmount = 0;
  //int userId = MainConstants.userId;
  int userId = userID.value;

  late String username;
  late String productName;
  late int price;
  late String size;
  late int productId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    usernameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    townController.dispose();
    sizeController.dispose();
    productNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments passed from the previous screen
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Map<String, dynamic>? selectedSize =
        arguments['selectedSize'] as Map<String, dynamic>?;

    // Now you can access the individual fields of the selectedSize map
    final String sizeNames = selectedSize?['name'] ?? '';

    // Initialize variables in the build method
    usernameController.text = arguments['username'] ?? '';
    phoneController.text = arguments['phoneNo'] ?? '';
    phoneNo = phoneController.text;
    locationController.text = arguments['location'] ?? '';
    location = locationController.text;
    townController.text = arguments['town'] ?? '';
    town = townController.text;
    price = arguments['price'] ?? '';
    // sizeController.text = arguments?['selectedSize'] ?? '';
    productId = arguments['productId'] ?? 0;
    sizeName = sizeNames;
    productNameController.text = arguments['productName'] ?? '';
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Billing Information'),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: productNameController,
                    readOnly: true, // Set this property to true
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                    ),
                  ),
                ),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Text(
                //       "Product Name: ",
                //       style: TextStyle(fontSize: 14.0),
                //     ),
                //     SizedBox(width: MediaQuery.of(context).size.width * 0.09),
                //     Text(
                //       productNameController.text,
                //       style: const TextStyle(fontSize: 14.0),
                //     ),
                //   ],
                // ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        quantity = value.isNotEmpty ? int.parse(value) : 1;
                        totalAmount = (price * quantity);
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter Quantity',
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: usernameController,
                    readOnly: true, // Set this property to true
                    decoration: const InputDecoration(
                      labelText: 'Buyer Name',
                    ),
                  ),
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   child: TextField(
                //     controller: phoneController,
                //     readOnly: true, // Set this property to true
                //     keyboardType: TextInputType.number,
                //     decoration: InputDecoration(
                //       hintText: '+256...',
                //       labelText: 'Phone Number',
                //     ),
                //   ),
                // ),
                // QuantityInput(
                //   price: price,
                //   quantity: quantity,
                //   onTotalAmountChanged: (amount) {
                //     setState(() {
                //       totalAmount = amount;
                //     });
                //   },
                // ),

                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: phoneController,
                    onChanged: (text) {
                      phoneNo = text.isNotEmpty ? text : "";
                    },
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                  ),
                  // Display the entered phone number for debugging
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: locationController,
                    onChanged: (text) {
                      location = text.isNotEmpty ? text : "";
                    },
                    decoration: const InputDecoration(
                      labelText: 'Location',
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: townController,
                    onChanged: (text) {
                      town = text.isNotEmpty ? text : "";
                    },
                    decoration: const InputDecoration(
                      labelText: 'Town',
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Price per Item: ",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.09),
                    Text(
                      'UGX ${NumberFormat('#,###').format(price)}',
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Total Amount: ",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    Text(
                      (quantity == 1)
                          ? 'UGX ${NumberFormat('#,###').format(price)}'
                          : 'UGX ${NumberFormat('#,###').format(totalAmount)}',
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ElevatedButton(
                  onPressed: () {
                    // Validate the form before submitting
                    if (_formKey.currentState!.validate()) {
                      // Save the form state
                      _formKey.currentState!.save();
                      submitBillInfoToAPI(
                          context,
                          phoneNo!,
                          location!,
                          town!,
                          price,
                          userId,
                          sizeName,
                          productId,
                          quantity,
                          totalAmount);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.yellow[700]!),
                    // You can customize other button properties here, like text color, padding, etc.
                  ),
                  child: const Text(
                    'Order Now',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Font size of the text
                        fontWeight: FontWeight.bold),
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

class QuantityInput extends StatefulWidget {
  final int price;
  int quantity;
  final Function(String totalAmount) onTotalAmountChanged;

  QuantityInput({
    super.key,
    required this.price,
    required this.quantity,
    required this.onTotalAmountChanged,
  });

  @override
  State<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextField(
        onChanged: (text) {
          widget.quantity = text.isNotEmpty ? int.parse(text) : 1;
          // Compute total amount and pass it back to the parent widget
          String totalAmount = (widget.price * widget.quantity).toString();
          widget.onTotalAmountChanged(totalAmount);
        },
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Enter Quantity',
        ),
      ),
    );
  }
}
