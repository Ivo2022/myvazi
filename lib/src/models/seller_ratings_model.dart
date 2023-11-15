// import 'dart:convert';

// SellerRatingsModel sellerratingsFromJson(String str) =>
//     SellerRatingsModel.fromJson(json.decode(str));
// String sellerratingsToJson(SellerRatingsModel data) =>
//     json.encode(data.toJson());

// class SellerRatingsModel {
//   int? sellersRating;
//   double? sellerStars;

//   SellerRatingsModel({required this.sellersRating, required this.sellerStars});

//   factory SellerRatingsModel.fromJson(Map<String, dynamic> json) {
//     return SellerRatingsModel(
//       sellersRating: json[
//           'countratings'], // Provide a default value if 'count ratings' is null
//       sellerStars: json[
//           'averageratings'], // Provide a default value if 'average ratings' is null
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'countratings': sellersRating,
//       'averageratings': sellerStars,
//     };
//   }
// }
