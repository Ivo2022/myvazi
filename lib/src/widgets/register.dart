import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myvazi/src/utility/signup.dart';
import 'package:myvazi/src/utils/send_sms.dart';

//import 'package:myvazi/models/data.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController bizNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Map<String, dynamic>? result;
  bool? userStatus;
  String? statusMessage;

  @override
  void dispose() {
    phoneController.dispose();
    fullNameController.dispose();
    bizNameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void registerUser(
    BuildContext context,
    TextEditingController fullNameController,
    TextEditingController phoneController,
    TextEditingController bizNameController,
    TextEditingController addressController,
  ) async {
    try {
      result = await SellerSignUpUtil.postUserDetails(context, phoneController,
          fullNameController, bizNameController, addressController);
      // Check if result is not null and handle accordingly
      if (result != null) {
        // Access result data here
        userStatus = result!['success'];
        statusMessage = result!['message'];
      } else {
        // Handle error case
      }
    } catch (error) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              // Check if all input fields are filled
              if (phoneController.text.isEmpty ||
                  fullNameController.text.isEmpty ||
                  bizNameController.text.isEmpty ||
                  addressController.text.isEmpty) {
                // Show an error dialog if any field is empty
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please fill in all the fields.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                // All fields are filled, proceed to the next step
                registerUser(context, phoneController, fullNameController,
                    bizNameController, addressController);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    if (statusMessage != null && userStatus != null) {
                      return SendSMS(
                        phoneNo: phoneController.text,
                        username: fullNameController.text,
                        bizName: bizNameController.text,
                        address: addressController.text,
                        statusMessage: statusMessage!,
                        userStatus: userStatus!,
                      );
                    } else {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'Status message or user status is null.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    }
                  },
                );
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("NEXT"),
            ),
          ),

          // GestureDetector(
          //   onTap: () {
          //     registerUser(context, phoneController, fullNameController,
          //         bizNameController, addressController);
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         // Check if statusMessage and userStatus are not null before using the null check operator
          //         if (statusMessage != null && userStatus != null) {
          //           return SendSMS(
          //             phoneNo: phoneController.text,
          //             username: fullNameController.text,
          //             bizName: bizNameController.text,
          //             address: addressController.text,
          //             statusMessage: statusMessage!,
          //             userStatus: userStatus!,
          //           );
          //         } else {
          //           // Handle the case where statusMessage or userStatus is null
          //           return AlertDialog(
          //             title: const Text('Error'),
          //             content:
          //                 const Text('Status message or user status is null.'),
          //             actions: [
          //               TextButton(
          //                 onPressed: () {
          //                   Navigator.of(context).pop();
          //                 },
          //                 child: const Text('OK'),
          //               ),
          //             ],
          //           );
          //         }
          //       },
          //     );

          //     // showDialog(
          //     //   context: context,
          //     //   builder: (BuildContext context) {
          //     //     return SendSMS(
          //     //         username: fullNameController.text,
          //     //         phoneNo: phoneController.text,
          //     //         bizName: bizNameController.text,
          //     //         address: addressController.text,
          //     //         statusMessage: statusMessage!,
          //     //         userStatus: userStatus!);
          //     //   },
          //     // );
          //   },
          //   child: const Padding(
          //     padding: EdgeInsets.all(16.0),
          //     child: Text("NEXT"),
          //   ),
          // ),
        ],
        title: const Text('Register'),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Form(
          // key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: '256...',
                      labelText: 'Phone Number',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      hintText: 'MyVazi...',
                      labelText: 'Full Name',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  TextField(
                    controller: bizNameController,
                    decoration: const InputDecoration(
                      hintText: 'MyVazi...',
                      labelText: 'Business Name',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      hintText: 'Kampala',
                      labelText: 'Address',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: "Go back ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Adjust the font size as needed
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Home',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Phone Number: ${phoneController.text}');
                              print('Full Name: ${fullNameController.text}');
                              print('Business Name: ${bizNameController.text}');
                              print('Address: ${addressController.text}');
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
