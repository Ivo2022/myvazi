import 'dart:io';

import 'package:flutter/material.dart';

//import 'package:myvazi/models/data.dart';

class ProductUpload extends StatefulWidget {
  const ProductUpload({super.key});

  @override
  State<ProductUpload> createState() => _ProductUploadState();
}

class _ProductUploadState extends State<ProductUpload> {
  // Receive the selected image from the arguments

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

  @override
  Widget build(BuildContext context) {
    final File? selectedImage =
        ModalRoute.of(context)!.settings.arguments as File?;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Upload Product'),
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
                child: selectedImage != null
                    ? Image.file(selectedImage)
                    : Text('No image selected'),
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    hintText: '0.00',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an amount';
                    }
                    onChanged:
                    (value) {
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
                          onPressed: () {},
                          child: const Text('Upload'),
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
