import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String fullName;
  final String dateOfBirth;
  final String identification;
  final String imageUrl;
  final String phoneNumber;

  Employee({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.identification,
    required this.imageUrl,
    required this.phoneNumber,
  });

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Employee(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      identification: data['identification'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'identification': identification,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
    };
  }
}
