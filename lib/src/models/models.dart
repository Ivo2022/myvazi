import 'dart:convert';
//import 'package:hive/hive.dart';
//part 'models.g.dart';

// sizes_data.dart

List<Map<String, dynamic>> sizesData = [];

void setSizesData(List<Map<String, dynamic>> data) {
  sizesData = data;
}

List<Map<String, dynamic>> getSizesData() {
  return sizesData;
}

SellersModel sellersFromJson(String str) =>
    SellersModel.fromJson(json.decode(str));
String sellersToJson(SellersModel data) => json.encode(data.toJson());

class SellersModel {
  String userName;
  String userPhone;
//
  SellersModel({required this.userName, required this.userPhone});

  factory SellersModel.fromJson(Map<String, dynamic> json) {
    return SellersModel(
      userName:
          json['name'] as String, // Provide a default value if 'name' is null
      userPhone: json['phone_number']
          as String, // Provide a default value if 'phone_number' is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': userName,
      'phone_number': userPhone,
    };
  }
}

UsersModel usersFromJson(String str) => UsersModel.fromJson(json.decode(str));
String usersToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  String? name;
  String? phone;
  String? location;
  String? town;

  UsersModel(
      {required this.name,
      required this.phone,
      required this.location,
      this.town});

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
        name: json['name'],
        phone: json['phone_number'],
        location: json['location'],
        town: json['town']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phone,
      'location': location,
      'town': town
    };
  }
}

SellerRatingsModel sellerratingsFromJson(String str) =>
    SellerRatingsModel.fromJson(json.decode(str));
String sellerratingsToJson(SellerRatingsModel data) =>
    json.encode(data.toJson());

class SellerRatingsModel {
  int sellersRating;
  double sellerStars;

  SellerRatingsModel({required this.sellersRating, required this.sellerStars});

  factory SellerRatingsModel.fromJson(Map<String, dynamic> json) {
    return SellerRatingsModel(
      sellersRating: json[
          'countratings'], // Provide a default value if 'count ratings' is null
      sellerStars: json[
          'averageratings'], // Provide a default value if 'average ratings' is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countratings': sellersRating,
      'averageratings': sellerStars,
    };
  }
}

ProductDetailsModel productdetailsFromJson(String str) =>
    ProductDetailsModel.fromJson(json.decode(str));
String productdetailsToJson(ProductDetailsModel data) =>
    json.encode(data.toJson());

class ProductDetailsModel {
  final int productId;
  final int supplierUserId;
  final String name;
  final String purpose;
  final int price;
  final int quantity;
  final String dateOfUpload;
  final int visibility;

  ProductDetailsModel({
    required this.productId,
    required this.supplierUserId,
    required this.name,
    required this.purpose,
    required this.price,
    required this.quantity,
    required this.dateOfUpload,
    required this.visibility,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      productId: json[
          'product_id'], // Provide a default value if 'count ratings' is null
      supplierUserId: json[
          'supplier_user_id'], // Provide a default value if 'average ratings' is null
      name: json[
          'product_title'], // Provide a default value if 'count ratings' is null
      purpose: json[
          'purpose'], // Provide a default value if 'average ratings' is null
      price:
          json['price'], // Provide a default value if 'count ratings' is null
      quantity: json[
          'quantity'], // Provide a default value if 'average ratings' is null
      dateOfUpload: json[
          'date_of_upload'], // Provide a default value if 'count ratings' is null
      visibility: json[
          'visibility'], // Provide a default value if 'average ratings' is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'supplier_user_id': supplierUserId,
      'product_title': name,
      'purpose': purpose,
      'price': price,
      'quantity': quantity,
      'date_of_upload': dateOfUpload,
      'visibility': visibility,
    };
  }

  // Add any other methods or properties you may need
}

ProductSizeModel productdsizeFromJson(String str) =>
    ProductSizeModel.fromJson(json.decode(str));
String productdsizeToJson(ProductSizeModel data) => json.encode(data.toJson());

class ProductSizeModel {
  final int sizeId;

  ProductSizeModel({required this.sizeId});

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      sizeId: json['size_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size_id': sizeId,
    };
  }
}

class SubcategoryModel {
  final int subcategoryId;
  final String subcategoryName;
  final List<int> productIDs;
  final List<Product> products;

  SubcategoryModel({
    required this.subcategoryId,
    required this.subcategoryName,
    required this.productIDs,
    required this.products,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    print('Calling fromJson');
    print('Received JSON: $json');
    try {
      List<int> productID =
          json['productID'].split(',').map((id) => int.parse(id)).toList();

      List<Product> products = (json['productsdetails'] as List<dynamic>?)
              ?.map((productJson) => Product.fromJson(productJson))
              .toList() ??
          [];

      // Parse the key as an integer
      int subcategoryId = int.tryParse(json.keys.first) ?? 0;

      print('Parsing successful. Creating SubcategoryModel...');
      return SubcategoryModel(
        subcategoryId: subcategoryId,
        subcategoryName: json['subcategoryName'] as String? ?? '',
        productIDs: productID,
        products: products,
      );
    } catch (e) {
      print('Error in fromJson: $e');
      // Handle the error gracefully, maybe return a default value or rethrow the exception.
      return SubcategoryModel(
        subcategoryId: 0,
        subcategoryName: 'Error',
        productIDs: [],
        products: [],
      );
    }
  }
}

class ProductDetails {
  final List<Product> productDetails;

  ProductDetails({required this.productDetails});

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    List<Product> products = (json['product_details'] as List<dynamic>?)
            ?.map((productJson) => Product.fromJson(productJson))
            .toList() ??
        [];

    return ProductDetails(productDetails: products);
  }
}

class Product {
  final int productId;
  final String name;
  final String purpose;
  final int price;
  final int quantity;
  final String dateOfUpload;
  final int visibility;
  final int quantityAvailable;
  final List<ProductSize> productSizes;
  final List<ProductImage> productImages;

  Product({
    required this.productId,
    required this.name,
    required this.purpose,
    required this.price,
    required this.quantity,
    required this.dateOfUpload,
    required this.visibility,
    required this.quantityAvailable,
    required this.productSizes,
    required this.productImages,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ProductSize> productSizes = (json['product_sizes'] as List<dynamic>?)
            ?.map((sizeJson) => ProductSize.fromJson(sizeJson))
            .toList() ??
        [];

    List<ProductImage> productImages =
        (json['product_images'] as List<dynamic>?)
                ?.map((imageJson) => ProductImage.fromJson(imageJson))
                .toList() ??
            [];

    return Product(
      productId: json['product_id'],
      name: json['product_title'],
      purpose: json['purpose'],
      price: json['price'],
      quantity: json['quantity'],
      dateOfUpload: json['date_of_upload'],
      visibility: json['visibility'],
      quantityAvailable: json['quantity_available'],
      productSizes: productSizes,
      productImages: productImages,
    );
  }
}

class ProductSize {
  final int sizeId;

  ProductSize({required this.sizeId});

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      sizeId: json['size_id'],
    );
  }
}

class ProductImage {
  final String imageNameOne;
  final String? imageNameTwo;
  final String? imageNameThree;

  ProductImage({
    required this.imageNameOne,
    this.imageNameTwo,
    this.imageNameThree,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      imageNameOne: json['image_name_one'],
      imageNameTwo: json['image_name_two'],
      imageNameThree: json['image_name_three'],
    );
  }
}

// ProductsModel productsFromJson(String str) => ProductsModel.fromJson(json.decode(str));
// String productsToJson(ProductsModel data) => json.encode(data.toJson());

// class ProductsModel {
//   String? name;
//   String? phone;
//   String? location;
//   String? town;

//   UsersModel(
//       {required this.name,
//       required this.phone,
//       required this.location,
//       this.town});

//   factory UsersModel.fromJson(Map<String, dynamic> json) {
//     return UsersModel(
//         name: json['name'],
//         phone: json['phone_number'],
//         location: json['location'],
//         town: json['town']);
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'phone_number': phone,
//       'location': location,
//       'town': town
//     };
//   }
// }