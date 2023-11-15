import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class BuyNow extends StatefulWidget {
  const BuyNow({super.key});

  @override
  State<BuyNow> createState() => _BuyNowState();
}

class _BuyNowState extends State<BuyNow> {
  //Map data = {};
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  String location = '';
  String town = '';
  final TextEditingController _phoneNumberController = TextEditingController();
  String initialCountry = 'UG'; // Set the initial country code as desired.


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text('Billing Information'),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Text widget
              SizedBox(
                width: 300.0,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  decoration: const InputDecoration(
                    label: Text('Name')
                  ),
                ),
              ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber); // Print the phone number with country code.
                  },
                  onInputValidated: (bool value) {
                    // Validation callback (optional).
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: PhoneNumber(isoCode: initialCountry),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 300.0,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        location = value;
                      });
                    },
                    decoration: const InputDecoration(
                      label: Text('Location'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300.0,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        town = value;
                      });
                    },
                    decoration: const InputDecoration(
                      label: Text('Town'),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Padding(
                  padding: EdgeInsets.fromLTRB(50.0, 8.0, 16.0, 8.0),
                  child: Row(
                    children: [
                      Text('Total Amount:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10.0),
                      Text('UGX 50,000', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
               // Button widget
                SizedBox(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () { Navigator.pushNamed(context, '/order'); },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow[700]!),
                              // You can customize other button properties here, like text color, padding, etc.
                            ),
                            child: const Text(
                              'ORDER',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12, // Font size of the text
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ]
        ),
      ),
      ),
    );
  }
}