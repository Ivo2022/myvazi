import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/models/models.dart';
import 'package:myvazi/src/models/products_model.dart';
import 'package:myvazi/src/services/product_services.dart';

class ProductUpload extends StatefulWidget {
  const ProductUpload({super.key});

  @override
  State<ProductUpload> createState() => _ProductUploadState();
}

class _ProductUploadState extends State<ProductUpload> {
  final _postCatUrl = MainConstants.baseUrl;
  final _postPhoneCatUrl = MainConstants.phoneUrl;
  final String _action = "getAllMainCategories";
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _textControllers = {
    'Product Description': TextEditingController(),
    'Category': TextEditingController(),
    'Amount': TextEditingController(),
    'Quantity': TextEditingController(),
    'Select Sizes': TextEditingController(),
    // 'Special Field': TextEditingController(),
    // Add more fields as needed
  };

  ValueNotifier pickMainCategory = ValueNotifier('none');
  ValueNotifier pickCategory = ValueNotifier('none');
  ValueNotifier pickSubCategory = ValueNotifier('none');
  ValueNotifier pickSize = ValueNotifier('none');

  List<Map<String, dynamic>> selectedCategories = [];
  List<Map<String, dynamic>> selectedSubCategories = [];

  List<dynamic> mainCategories = [];
  List<dynamic> categories = [];
  List<dynamic> subCategories = [];
  List<dynamic> sizes = [];

  List<dynamic>? pickedMainCats = [];
  List<dynamic>? pickedCats = [];
  List<dynamic>? pickedSubcats = [];
  List<dynamic>? pickedSizes = [];

  List<String> pickedMainCatString = [];
  List<String> pickedCatString = [];
  List<String> pickedSubcatString = [];
  List<String> pickedSizeString = [];

  List<dynamic> selectedMainCategoryIds = [];
  List<dynamic> selectedCategoryIds = [];
  List<dynamic> selectedSubCategoryIds = [];
  List<dynamic> selectedSizeIds = [];
  List? mainSubcats = [];

  String name = '';
  String sellerName = MainConstants.sellerName;
  String purpose = "For Sale";

  int quantity = 0;
  int activation = MainConstants.activation;

  double amount = 0.0;

// Create a variable to track the state of the checkbox
  bool isChecked = false;

// This function returns the main categories that show while uploading products
  Future<void> fetchAllMainCategories() async {
    String url = Platform.isAndroid
        ? '$_postPhoneCatUrl/get_maincategories_with_products.php?action=$_action'
        : '$_postCatUrl/get_maincategories_with_products.php?action=$_action';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List mainCategoriesList = json.decode(response.body);
      for (int i = 0; i < mainCategoriesList.length; i++) {
        Map mainCatdetails = mainCategoriesList.elementAt(i);
        String maincat = mainCatdetails.values.last;
        int maincatID = int.parse(mainCatdetails.values.first);
        setState(() {
          mainCategories.add({'name': maincat, 'id': maincatID});
        });
      }
    } else {
      throw Exception(
          'Failed to load main categories: ${response.body} = HTTP Status Code: ${response.statusCode}');
    }
  }

// This function returns the categories that show while uploading products
  Future<void> fetchCategories(dynamic mainCategory) async {
    String url = Platform.isAndroid
        ? '$_postPhoneCatUrl/get_categories.php'
        : '$_postCatUrl/get_categories.php';
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      // Add any additional headers if needed
    };
    final Map<String, dynamic> requestData = {
      'action': 'getAllCategories',
      'maincat': mainCategory
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(requestData),
    );
    try {
      if (response.statusCode == 200) {
        dynamic decodedResponse = json.decode(response.body);
        if (decodedResponse is List) {
          // If it's a list, iterate through it
          List categoriesList = decodedResponse;

          for (int i = 0; i < categoriesList.length; i++) {
            Map catDetails = categoriesList.elementAt(i);
            String cat = catDetails.values.first;
            int catID = int.parse(catDetails.values.last);
            setState(() {
              categories.add({'name': cat, 'id': catID});
            });
          }
        } else if (decodedResponse is String) {
          // If it's a single value, add it directly to the categories list
          setState(() {
            categories.add(decodedResponse);
          });
        } else {
          // Handle other types if necessary
          print('Unexpected response type: ${decodedResponse.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load categories: ${response.body} = HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      // Handle other exceptions if needed.
    }
  }

// This function returns the subcategories that show while uploading products
  Future<void> fetchSubCategories(dynamic category) async {
    String url = Platform.isAndroid
        ? '$_postPhoneCatUrl/get_subcategories_with_products.php'
        : '$_postCatUrl/get_subcategories_with_products.php';

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

    final Map<String, dynamic> requestData = {
      'action': 'getAllSubCategories',
      'category': category
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(requestData),
    );

    try {
      if (response.statusCode == 200) {
        dynamic decodedResponse = json.decode(response.body);
        if (decodedResponse is List) {
          // If it's a list, iterate through it
          List subcategoriesList = decodedResponse;
          for (int i = 0; i < subcategoriesList.length; i++) {
            Map subCatDetails = subcategoriesList.elementAt(i);
            String subcat = subCatDetails.values.first;
            int subcatID = int.parse(subCatDetails.values.last);

            setState(() {
              subCategories.add({'name': subcat, 'subcategory_id': subcatID});
            });
          }
        } else if (decodedResponse is String) {
          // If it's a single value, add it directly to the categories list
          setState(() {
            subCategories.add(decodedResponse);
          });
        } else {
          // Handle other types if necessary
          print('Unexpected response type: ${decodedResponse.runtimeType}');
        }
      } else {
        // You might want to handle this error more gracefully, depending on your use case.
        // For now, we throw an exception.
        throw Exception(
            'Failed to load subcategories: ${response.body} = HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      // Handle other exceptions if needed.
    }
  }

  // Future<void> fetchSizesAndSetData() async {
  //   try {
  //     List<Map<String, dynamic>> sizes = await SizesService.fetchAllSizes();
  //     setState(() {
  //       setSizesData(sizes); // Set sizes data to be used in the widget
  //     });
  //   } catch (e) {
  //     print('Error fetching sizes: $e');
  //     // Handle the error as needed
  //   }
  // }

  // This function returns the sizes that show while uploading products
  fetchSizesForProducts() async {
    String url = Platform.isAndroid
        ? '$_postPhoneCatUrl/get_all_sizes.php'
        : '$_postCatUrl/get_all_sizes.php';
    final Map<String, dynamic> requestData = {
      'action': 'getAllSizes',
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
      List sizesList = json.decode(response.body);
      for (int i = 0; i < sizesList.length; i++) {
        Map sizedetails = sizesList.elementAt(i);
        String size = sizedetails.values.last;
        int sizeID = int.parse(sizedetails.values.first);
        sizes.add({'name': size, 'size_id': sizeID});
      }

      //setSizesData(sizes); // Save sizes data to sizes_data.dart

      return sizes;
    } else {
      throw Exception('Failed to load sizes');
    }
  }

  late String selectedCategoryMessage;
  @override
  void initState() {
    super.initState();
    mainSubcats = uploadList.value;
    // Fetch initial Main Subcategories
    fetchAllMainCategories();
    //fetchMainSubcategories();
    //fetchSizesAndSetData();
    fetchSizesForProducts();
    // selectedCategoryMessage = 'Selected';
    pickCategory.addListener(() {
      if (pickCategory.value != 'none') {
        Timer(const Duration(seconds: 1), () {
          _categoryDialog(context);
          setState(() {
            pickCategory.value = 'none';
          });
        });
      }
    });
    pickSubCategory.addListener(() {
      if (pickSubCategory.value != 'none') {
        Timer(const Duration(seconds: 1), () {
          _subcatDialog(context);
          setState(() {
            pickSubCategory.value = 'none';
          });
        });
      }
    });

    // pickSize.addListener(() {
    //   if (pickSize.value != 'none') {
    //     setState(() {
    //       pickSize.value = 'none';
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final List<ImageFile>? selectedImages =
        ModalRoute.of(context)!.settings.arguments as List<ImageFile>?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell a product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Use a ListView.builder to create multiple text fields
              ListView.builder(
                shrinkWrap: true,
                itemCount: _textControllers.length,
                itemBuilder: (context, index) {
                  String key = _textControllers.keys.elementAt(index);
                  bool selectedCategory = key == 'Category';
                  bool selectedSize = key == 'Select Sizes';

                  List<Widget> widgets = [
                    TextFormField(
                      controller: _textControllers[key],
                      keyboardType: key == 'Amount' || key == 'Quantity'
                          ? TextInputType.number
                          : TextInputType.text,
                      decoration: InputDecoration(labelText: key),
                      onTap: () {
                        if (key == 'Category') {
                          _maincatDialog(context);
                        } else if (key == 'Select Sizes') {
                          _selectSizeDialog(context);
                        }
                      },
                      onChanged: (value) {},
                    ),
                  ];

                  // Conditionally add the selected category message if something is selected
                  if (selectedCategory &&
                      pickedMainCatString.isNotEmpty &&
                      pickedCatString.isNotEmpty &&
                      pickedSubcatString.isNotEmpty) {
                    final categoryText =
                        'Selected: ${pickedMainCatString.join(',')} >> ${pickedCatString.join(',')} >> ${pickedSubcatString.join(',')}';
                    widgets.add(
                      Text(
                        categoryText,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }

                  // Conditionally add the selected size message if something is selected
                  if (selectedSize && pickedSizeString.isNotEmpty) {
                    final sizeText = 'Selected: ${pickedSizeString.join(',')}';
                    widgets.add(
                      Text(
                        sizeText,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widgets,
                  );
                },
              ),

              const SizedBox(height: 8.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Available for:'),
                  Radio(
                    value: 'For Sale',
                    groupValue: purpose,
                    onChanged: (value) {
                      setState(() {
                        purpose = value.toString();
                      });
                    },
                  ),
                  const Text('Sale'),
                  Radio(
                    value: 'For Hire',
                    groupValue: purpose,
                    onChanged: (value) {
                      setState(() {
                        purpose = value.toString();
                      });
                    },
                  ),
                  const Text('Hire'),
                ],
              ),
              const SizedBox(height: 8.0),
              // ElevatedButton(
              //   onPressed: () async {
              //     // Call the method to create a Product from the form
              //     ProductService product = ProductService();

              //     // Save the product to the database or perform other actions
              //     saveProductToDatabase(product.createProductFromForm);
              //   },
              //   child: const Text('Submit'),
              // ),

              ElevatedButton(
                onPressed: () async {
                  try {
                    // Create an instance of ProductService
                    ProductService productService = ProductService();

                    // Create a Product instance using the ProductService instance
                    Products product = productService.createProductFromForm(
                      context,
                      selectedImages,
                      purpose,
                      pickedMainCats,
                      pickedCats,
                      pickedSubcats,
                      pickedSizes,
                      _textControllers,
                    );

                    // // Assign the relevant data to the Products instance
                    // //product.selectedImages = selectedImages;
                    // product.pickedMainCats = pickedMainCats;
                    // product.pickedCats = pickedCats;
                    // product.pickedSubCats = pickedSubcats;
                    // product.pickedSizes = pickedSizes;
                    // product.purpose = purpose;

                    // print(selectedImages);
                    // print(pickedMainCats);
                    // print(pickedCats);
                    // print(pickedSubcats);
                    // print(pickedSizes);
                    // print(purpose);

                    // print(_textControllers['Product Description']!.text);
                    // print(_textControllers['Amount']!.text);
                    // print(_textControllers['Quantity']!.text);

                    // // // Additional assignment of other variables
                    // product.productDescription =
                    //     _textControllers['Product Description']!.text;
                    // product.amount =
                    //     double.tryParse(_textControllers['Amount']!.text) ??
                    //         0.0;
                    // product.quantity =
                    //     int.tryParse(_textControllers['Quantity']!.text) ?? 0;

                    // Call the function to submit data to the API using the Product instance
                    await pushDataToAPI(context, product);
                  } catch (e) {
                    // Handle any errors that might occur during API submission
                    print('Error submitting data to API: $e');
                  }
                },
                child: const Text('Submit'),
              ),

              // ElevatedButton(
              //   onPressed: () async {
              //     // Validate the form before submitting
              //     if (_formKey.currentState!.validate()) {
              //       // Save the form state
              //       _formKey.currentState!.save();

              //       // Call the function to submit data to the API
              //       submitDataToAPI(
              //           context,
              //           name,
              //           selectedMainCategoryIds,
              //           selectedCategoryIds,
              //           selectedSubCategoryIds,
              //           amount,
              //           quantity,
              //           purpose,
              //           selectedSizeIds,
              //           selectedImages!,
              //           sellerName,
              //           activation);
              //     }
              //   },
              //   child: const Text('Submit'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom method to calculate total price based on quantity
  void _calculateTotalPrice() {
    if (_textControllers['Amount']!.text.isNotEmpty &&
        _textControllers['Quantity']!.text.isNotEmpty) {
      double price = double.parse(_textControllers['Amount']!.text);
      int quantity = int.parse(_textControllers['Quantity']!.text);

      double totalPrice = price * quantity;

      print('Total Amount: $totalPrice');
    }
  }

  void _maincatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<bool> selectedMainCategories =
            List.generate(mainCategories.length, (index) => false);

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Select the category of users',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: List.generate(mainCategories.length, (index) {
                  return ListTile(
                    title: Text(mainCategories[index]['name']),
                    trailing: Checkbox(
                      value: selectedMainCategories[index],
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() {
                            selectedMainCategories[index] = value;
                          });
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  for (int i = 0; i < mainCategories.length; i++) {
                    if (selectedMainCategories[i]) {
                      selectedCategories.add({
                        'name': mainCategories[i]['name'],
                        'id': mainCategories[i]['id'],
                      });
                    }
                  }

                  if (mainCategories.isNotEmpty) {
                    for (int j = 0; j < mainCategories.length; j++) {
                      if (selectedMainCategories[j]) {
                        pickedMainCats!.add(mainCategories[j]['id'] ?? 0);
                        pickedMainCatString
                            .add(mainCategories[j]['name'] ?? "");
                      }
                    }
                  }

                  setState(() {
                    pickCategory.value = "picked";
                  });

                  print('Picked MainCat IDs: $pickedMainCats');
                  // Call the API with the selected categories list
                  fetchCategories(jsonEncode(selectedCategories));

                  // Get the selected main categories

                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
      },
    );
  }

  void _categoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<bool> selectedCategories =
            List.generate(categories.length, (index) => false);
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Select the category of product',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: List.generate(categories.length, (index) {
                  return ListTile(
                    title: Text(categories[index]['name']),
                    trailing: Checkbox(
                      value: selectedCategories[index],
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() {
                            selectedCategories[index] = value;
                          });
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Get the selected main categories
                  for (int i = 0; i < categories.length; i++) {
                    if (selectedCategories[i]) {
                      selectedSubCategories.add({
                        'name': categories[i]['name'],
                        'id': categories[i]['id'],
                      });
                    }
                  }

                  if (categories.isNotEmpty) {
                    for (int j = 0; j < categories.length; j++) {
                      if (selectedCategories[j]) {
                        pickedCats!.add(categories[j]['id'] ?? 0);
                        pickedCatString.add(categories[j]['name'] ?? "");
                      }
                    }
                  }

                  print('Picked Cat IDs: $pickedCats');

                  setState(() {
                    pickSubCategory.value = "picked";
                  });

                  fetchSubCategories(jsonEncode(selectedSubCategories));

                  // Close the current dialog
                  Navigator.of(context).pop();
                },
                // onPressed: () {
                //   // Get the selected main categories
                //   List<Map<String, dynamic>> selectedSubCategories = [];
                //   for (int i = 0; i < categories.length; i++) {
                //     // print(categories);
                //     if (selectedCategories[i]) {
                //       selectedSubCategories.add({
                //         'name': categories[i]['name'],
                //         'id': categories[i]['id'],
                //       });
                //     }
                //   }

                //   // Call the API with the selected categories list
                //   fetchSubCategories(jsonEncode(selectedSubCategories));

                //   //Close the current dialog
                //   setState(() {
                //     pickSubCategory.value = selectedSubCategories;
                //   });

                //   Navigator.of(context).pop();
                // },
                child: const Text('OK'),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     setState(() {
              //       pickSubCategory.value = "picked";
              //     });
              //     Navigator.of(context).pop(); // Close the current dialog
              //   },
              //   child: const Text('OK'),
              // ),
            ],
          );
        });
      },
    );
  }

  void _subcatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<bool> selectedSubCategories =
            List.generate(subCategories.length, (index) => false);
        return StatefulBuilder(
          builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Select the subcategory of products',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: List.generate(subCategories.length, (index) {
                  return ListTile(
                    title: Text(subCategories[index]['name']),
                    trailing: Checkbox(
                      value: selectedSubCategories[index],
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() {
                            selectedSubCategories[index] = value;
                          });
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (subCategories.isNotEmpty) {
                    for (int i = 0; i < subCategories.length; i++) {
                      if (selectedSubCategories[i]) {
                        pickedSubcats!
                            .add(subCategories[i]['subcategory_id'] ?? 0);
                        pickedSubcatString.add(subCategories[i]['name'] ?? "");
                      }
                    }
                  }
                  print('Picked SubCat IDs: $pickedSubcats');
                  // setState(() {
                  //   pickSubCategory.value = "picked";
                  // });

                  // Close the current dialog
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
      },
    );
  }

  void _selectSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<bool> selectedSizes =
            List.generate(sizes.length, (index) => false);

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Select Sizes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: List.generate(sizes.length, (index) {
                  return ListTile(
                    title: Text(sizes[index]['name']),
                    trailing: Checkbox(
                      value: selectedSizes[index],
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() {
                            selectedSizes[index] = value;
                          });
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (sizes.isNotEmpty) {
                    for (int i = 0; i < sizes.length; i++) {
                      if (selectedSizes[i]) {
                        pickedSizes!.add(sizes[i]['size_id'] ?? 0);
                        pickedSizeString.add(sizes[i]['name'] ?? "");
                      }
                    }
                  }
                  print('Picked Size IDs: $pickedSizes');
                  setState(() {
                    pickSize.value = "picked";
                  });

                  // Close the current dialog
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
      },
    );
  }

  void saveProductToDatabase(Products product) {
    // Implement your logic to save the product to the database
    print('Product saved to database: $product');
  }
/*
List<int> listOfIds = [1, 2, 3, 4, 5];

// Convert the list of IDs to a comma-separated string
String idsAsString = listOfIds.join(',');

print('IDs as String: $idsAsString');

*/
}
