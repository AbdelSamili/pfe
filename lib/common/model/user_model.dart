import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  String password;
  String phoneNumber;
  String profileImage;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      "Email": email,
      "Phone": phoneNumber,
      "Password": password,
      "ImageUrl": profileImage,
    };
  }
}
