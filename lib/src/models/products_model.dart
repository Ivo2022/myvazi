// class Products {
//   final int id;
//   final String description;
//   final int price;

//   Products({required this.id, required this.description, required this.price});

//   Products.fromMap(Map<String, dynamic> item)
//       : id = item["id"],
//         description = item["description"],
//         price = item["price"];

//   Map<String, Object> toMap() {
//     return {'id': id, 'description': description, 'price': price};
//   }
// }

import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class Products {
  late String productDescription;
  late double amount;
  late String purpose;
  String sellerName;
  late int quantity;
  late List<ImageFile>? selectedImages;
  late List<dynamic>? pickedMainCats;
  late List<dynamic>? pickedCats;
  late List<dynamic>? pickedSubCats;
  late List<dynamic>? pickedSizes;
  int activation;

  Products({
    required this.productDescription,
    required this.amount,
    required this.purpose,
    required this.sellerName,
    required this.quantity,
    List<ImageFile>? selectedImages,
    List<dynamic>? pickedMainCats,
    List<dynamic>? pickedCats,
    List<dynamic>? pickedSubCats,
    List<dynamic>? pickedSizes,
    required this.activation,
  })  : selectedImages = selectedImages ?? [],
        pickedMainCats = pickedMainCats ?? [],
        pickedCats = pickedCats ?? [],
        pickedSubCats = pickedSubCats ?? [],
        pickedSizes = pickedSizes ?? [];

  @override
  String toString() {
    return 'Products(productDescription: $productDescription, amount: $amount, purpose: $purpose, sellerName: $sellerName, quantity: $quantity, pickedMainCats: $pickedMainCats, pickedCats: $pickedCats, pickedSubCats: $pickedSubCats, pickedSizes: $pickedSizes, activation: $activation,)';
  }
}
