// import 'dart:convert';

// UsersModel usersFromJson(String str) => UsersModel.fromJson(json.decode(str));
// String usersToJson(UsersModel data) => json.encode(data.toJson());

// class UsersModel {
//   String userName;
//   String userPhone;

//   UsersModel({required this.userName, required this.userPhone});

//   factory UsersModel.fromJson(Map<String, dynamic> json) {
//     return UsersModel(
//       userName:
//           json['name'] as String, // Provide a default value if 'name' is null
//       userPhone: json['phone_number']
//           as String, // Provide a default value if 'phone_number' is null
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': userName,
//       'phone_number': userPhone,
//     };
//   }
// }
