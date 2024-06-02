import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfe_1/common/model/user_model.dart';

class ClientModel extends UserModel {
  String firstName;
  String lastName;
  final String userName;

  ClientModel({
    required String id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required String email,
    required String phoneNumber,
    required String password,
    required String profileImage,
  }) : super(
    id: id,
    email: email,
    password: password,
    phoneNumber: phoneNumber,
    profileImage: profileImage,
  );

  String get fullName => '$firstName $lastName';

  static List<String> nameParts(String fullName) => fullName.split(" ");

  static String generateUsername(String fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";
    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = "cwt_$camelCaseUsername";
    return usernameWithPrefix;
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      "FirstName": firstName,
      "LastName": lastName,
      "UserName": userName,
    });
    return data;
  }

  factory ClientModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return ClientModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        userName: data['UserName'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['Phone'] ?? '',
        password: data['Password'] ?? '',
        profileImage: data['ImageUrl'] ?? '',
      );
    } else {
      return ClientModel.empty(); // Return an empty ClientModel if document data is null
    }
  }

  static ClientModel empty() => ClientModel(id: '', firstName: '', lastName: '', userName: '', email: '', phoneNumber: '', password: '', profileImage: '');
}
