import 'dart:convert';
import 'dart:io';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/models/category_model.dart';
import 'package:myvazi/src/models/maincategory_model.dart';
import 'package:myvazi/src/models/subcategory_model.dart';

class Tested extends StatefulWidget {
  const Tested({super.key});

  @override
  State<Tested> createState() => _TestedState();
}

class _TestedState extends State<Tested> {
  final TextEditingController descriptionController = TextEditingController();
  List<MainCategory> selectedMainCategories = [];
  List<Category> selectedCategories = [];
  List<SubCategory> selectedSubCategories = [];

  List<MainCategory> mainCategories = []; // Populate with data from API
  List<Category> availableCategories = [];
  List<SubCategory> availableSubCategories = [];
  String ipAddress = MainConstants.ipAddress; //172.16.0.207 & 192.168.43.65
  //int sellerId = MainConstants.sellerId;
  int sellerId = sellerID.value;

  @override
  void initState() {
    super.initState();
    fetchAllMainCategories();
  }

  @override
  Widget build(BuildContext context) {
    //print(mainCategories);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Product Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomSearchableDropDown(
                showLabelInMenu: false,
                hideSearch: true,
                menuHeight: 30.0,
                items: mainCategories,
                label: 'Select Main Categories',
                multiSelectTag: 'MainCategory',
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                multiSelect: true,
                dropDownMenuItems: mainCategories.map((item) {
                  return item.name;
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedMainCategories = value;
                      availableCategories =
                          []; // Clear subcategories when main category changes
                    });
                    // Fetch categories based on selected main category
                    fetchCategories(value);
                  }
                },
              ),
              DropdownButtonFormField<MainCategory>(
                // value should be null initially or omitted
                hint: const Text('Select Main Categories'),
                items: mainCategories.map((mainCategory) {
                  return DropdownMenuItem<MainCategory>(
                    value: mainCategory,
                    child: Text(mainCategory.name),
                  );
                }).toList(),
                onChanged: (mainCategory) {
                  setState(() {
                    if (mainCategory != null &&
                        !selectedMainCategories.contains(mainCategory)) {
                      selectedMainCategories.add(mainCategory);
                    }
                    // Fetch and update categories based on the selected main categories
                    fetchCategories(
                            selectedMainCategories.map((e) => e.id).toList())
                        .then((categories) {
                      setState(() {
                        availableCategories = categories;
                      });
                    });
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                value: null,
                hint: const Text('Select Categories'),
                items: availableCategories.map((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (category) {
                  setState(() {
                    if (category != null &&
                        !selectedCategories.contains(category)) {
                      selectedCategories.add(category);
                    }
                    // Fetch and update subcategories based on the selected categories
                    fetchSubCategories(
                            selectedCategories.map((e) => e.id).toList())
                        .then((subCategories) {
                      setState(() {
                        availableSubCategories = subCategories;
                      });
                    });
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<SubCategory>(
                value: null,
                hint: const Text('Select Subcategories'),
                items: availableSubCategories.map((subCategory) {
                  return DropdownMenuItem<SubCategory>(
                    value: subCategory,
                    child: Text(subCategory.name),
                  );
                }).toList(),
                onChanged: (subCategory) {
                  setState(() {
                    if (subCategory != null &&
                        !selectedSubCategories.contains(subCategory)) {
                      selectedSubCategories.add(subCategory);
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (Form.of(context).validate()) {
                    // Perform form submission
                    submitForm();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Your fetchCategories and fetchSubCategories methods go here

  Future<List<MainCategory>> fetchAllMainCategories() async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_maincategories_with_products.php'
        : 'http://localhost/twambale/api/get_maincategories_with_products.php';

    final Map<String, dynamic> requestData = {
      'action': 'getAllMainCategories',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
      },
      body: jsonEncode(requestData),
    );
    if (response.statusCode == 200) {
      List mainCategoriesList = json.decode(response.body);
      List<MainCategory> mainCategories = [];
      for (int i = 0; i < mainCategoriesList.length; i++) {
        Map mainCatDetails = mainCategoriesList.elementAt(i);

        // Check if 'id' is not null before attempting to cast
        int? maincatID = mainCatDetails['main_category_id'] as int?;
        String maincatName = mainCatDetails['name'] as String;

        // Ensure that 'id' is not null before adding to the list
        if (maincatID != null) {
          MainCategory mainCategory =
              MainCategory(id: maincatID, name: maincatName);
          mainCategories.add(mainCategory);
        }
      }
      return mainCategories;
    } else {
      throw Exception('Failed to load main categories');
    }
  }

  Future<List<Category>> fetchCategories(List<int> mainCategory) async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_categories.php'
        : 'http://localhost/twambale/api/get_categories.php';

    final Map<String, dynamic> requestData = {
      'action': 'getAllCategories',
      'maincat': mainCategory
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      List categoriesList = json.decode(response.body);
      List<Category> categories = [];
      for (int i = 0; i < categoriesList.length; i++) {
        Map catDetails = categoriesList.elementAt(i);

        // Check if 'id' is not null before attempting to cast
        int? catID = catDetails['category_id'] as int?;
        String catName = catDetails['name'] as String;

        // Ensure that 'id' is not null before adding to the list
        if (catID != null) {
          Category category = Category(id: catID, name: catName);
          //print(category);

          categories.add(category);
        }
      }

      return categories;
    } else {
      throw Exception('Failed to load main categories');
    }
  }

  Future<List<SubCategory>> fetchSubCategories(List<int> category) async {
    String url = Platform.isAndroid
        ? 'http://$ipAddress/twambale/api/get_subcategories_with_products.php'
        : 'http://localhost/twambale/api/get_subcategories_with_products.php';

    final Map<String, dynamic> requestData = {
      'action': 'getAllSubCategories',
      'category': category
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      List subcategoriesList = json.decode(response.body);
      List<SubCategory> subcategories = [];
      for (int i = 0; i < subcategoriesList.length; i++) {
        Map subcatDetails = subcategoriesList.elementAt(i);

        // Check if 'id' is not null before attempting to cast
        int? subcatID = subcatDetails['subcategory_id'] as int?;
        String subcatName = subcatDetails['name'] as String;

        // Ensure that 'id' is not null before adding to the list
        if (subcatID != null) {
          SubCategory subcategory = SubCategory(id: subcatID, name: subcatName);
          //print(subcategory);

          subcategories.add(subcategory);
        }
      }

      return subcategories;
    } else {
      throw Exception('Failed to load main categories');
    }
  }

  void submitForm() {
    // Perform your form submission logic here
    // You can access the entered values from controllers and selected values
    print('Description: ${descriptionController.text}');
    print('Main Categories: ${selectedMainCategories.map((e) => e.name)}');
    print('Categories: ${selectedCategories.map((e) => e.name)}');
    print('Subcategories: ${selectedSubCategories.map((e) => e.name)}');
    // Add logic to send data to your server or database
  }
}
