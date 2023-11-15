import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import '../views/shared/server_response.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final url = 'http://127.0.0.1:8000/myvazi/create/';
  final _formKey = GlobalKey<FormState>();
  String category = '';
  String subcategory = '';
  String name = '';
  double amount = 0.0;

  final _amountController = TextEditingController();
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<ApiResponse> sendDataToApi() async {
    final Map<String, dynamic> data = {
      'category': category,
      'subcategory': subcategory,
      'name': name,
      'amount': amount,
    };

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return ApiResponse.success(response.body);
    } else {
      return ApiResponse.error(response.statusCode.toString());
    }
  }




  // Future<void> sendDataToApi() async {
  //
  //   final Map<String, dynamic> data = {
  //     'category': category,
  //     'subcategory': subcategory,
  //     'name': name,
  //     'amount': amount,
  //   };
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     body: jsonEncode(data),
  //     headers: {"Content-Type": "application/json"},
  //   );
  //   if (response.statusCode == 200) {
  //     showApiResponseStatus(context, response.body);
  //     //print('Data sent successfully: ${response.body}');
  //   } else {
  //     showApiResponseStatus(context, response.statusCode as String);
  //     //print('Failed to send data. Status code: ${response.statusCode}');
  //   }
  // }

  // Future<void> showStatusDialog(BuildContext context, String status) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatusDialog(status);
  //     },
  //   );
  // }

  void _onSendDataPressed(context) async {
    ApiResponse response = await sendDataToApi();

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send data. Status code: ${response.message}"),
        ),
      );
    }
  }


  // Call this function where you receive the API response
  // void showApiResponseStatus(BuildContext context, String responseStatus) {
  //   showStatusDialog(context, responseStatus);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Edit Product'),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    child: Image.asset(
                      "assets/images/image1.jpg",
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 300.0,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      category = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Product category',
                  ),
                ),
              ),
              SizedBox(
                width: 300.0,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      subcategory = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Product subcategory',
                  ),
                ),
              ),
              SizedBox(
                width: 300.0,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                ),
              ),
              SizedBox(
                width: 300.0,
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    hintText: '0.00',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an amount';
                    }
                    onChanged: (value) {
                      setState(() {
                        amount = value;
                      });
                    };
                  },
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
                          onPressed: () {
                            _onSendDataPressed(context);
                          },
                          child: const Text('Edit'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class ApiResponse {
  final bool success;
  final String message;

  ApiResponse(this.success, this.message);

  factory ApiResponse.success(String message) {
    return ApiResponse(true, message);
  }

  factory ApiResponse.error(String message) {
    return ApiResponse(false, message);
  }
}