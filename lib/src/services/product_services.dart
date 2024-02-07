import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/models/products_model.dart';

class ProductService {
// Assuming _textControllers is declared in the same class or widget state
  // final Map<String, TextEditingController> _textControllers = {
  //   'Product Description': TextEditingController(),
  //   'Amount': TextEditingController(),
  //   'Quantity': TextEditingController(),
  //   // Add more fields as needed
  // };

// Create a map of validators for your text fields
  final Map<String, String? Function(String)> _validators = {
    'Product Description': (value) =>
        value.isEmpty ? 'Please enter a product description' : null,
    'Amount': (value) {
      if (value.isEmpty) {
        return 'Please enter price';
      } else if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
        return 'Please enter a valid price';
      }
      return null;
    },
    'Quantity': (value) {
      if (value.isEmpty) {
        return 'Please enter quantity';
      } else if (!RegExp(r'^\d+$').hasMatch(value)) {
        return 'Please enter a valid quantity';
      }
      return null;
    },
    // Add more validators as needed
  };

  Products createProductFromForm(
    BuildContext context,
    List<ImageFile>? selectedImages,
    String purpose,
    List<dynamic>? pickedMainCats,
    List<dynamic>? pickedCats,
    List<dynamic>? pickedSubCats,
    List<dynamic>? pickedSizes,
    Map<String, TextEditingController> textControllers,
  ) {
    // Validate each TextField
    bool isValid = true;
    textControllers.forEach((key, controller) {
      final validator = _validators[key];
      if (validator != null && validator(controller.text) != null) {
        isValid = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validator(controller.text)!)),
        );
      }
    });

    // If all fields are valid, proceed with further actions
    if (isValid) {
      // Access and use the data entered in specific TextField
      String productDescription = textControllers['Product Description']!.text;
      double amount = double.tryParse(textControllers['Amount']!.text) ?? 0.0;
      String sellerName = MainConstants.sellerName;
      int activation = MainConstants.activation;
      String purpose = "For Sale";
      int quantity = int.tryParse(textControllers['Quantity']!.text) ?? 0;

      Products product = Products(
          productDescription: productDescription,
          amount: amount,
          purpose: purpose,
          sellerName: sellerName,
          quantity: quantity,
          activation: activation,

          // Populate other fields as needed
          pickedMainCats: pickedMainCats,
          pickedCats: pickedCats,
          pickedSubCats: pickedSubCats,
          pickedSizes: pickedSizes,
          selectedImages: selectedImages);

      return product;
    } else {
      // Handle the case where the function doesn't return a Product
      throw Exception('Validation failed, no Product created');
    }
  }
}
