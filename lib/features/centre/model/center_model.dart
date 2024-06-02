import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfe_1/common/model/user_model.dart';

class CenterModel extends UserModel {
  String centerName;
  final String matricule;
  String description;
  String creationDate;
  final double rating;

  CenterModel({
    required String id,
    required this.centerName,
    required this.matricule,
    required String email,
    required String phoneNumber,
    required String password,
    required String profileImage,
    this.description = '',
    this.creationDate = '',
    this.rating = 0.0,
  }) : super(
    id: id,
    email: email,
    password: password,
    phoneNumber: phoneNumber,
    profileImage: profileImage,
  );

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      "CenterName": centerName,
      "Matricule": matricule,
      "Description": description,
      "CreationDate": creationDate,
    });
    return data;
  }

  factory CenterModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return CenterModel(
        id: document.id,
        centerName: data['CenterName'] ?? '',
        matricule: data['Matricule'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['Phone'] ?? '',
        password: data['Password'] ?? '',
        profileImage: data['ImageUrl'] ?? '',
        description: data['Description'] ?? '',
        creationDate: data['CreationDate'] ?? '',
      );
    } else {
      return CenterModel.empty(); // Return an empty CenterModel if document data is null
    }
  }

  static CenterModel empty() => CenterModel(id: '', centerName: '', matricule: '', email: '', phoneNumber: '', password: '', profileImage: '');
}
