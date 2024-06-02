import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id; // L'ID du rendez-vous
  final String date;
  final String day;
  final String time; // Date et heure du rendez-vous
  final String userId;
  final String centreId;
  late final String etat;
  final String? employeeId;

  Appointment({
    required this.id, // L'ID est requis dans le constructeur
    required this.date,
    required this.day,
    required this.time,
    required this.userId,
    required this.centreId,
    required this.etat,
    this.employeeId,
  });

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "day": day,
      "time": time,
      "etat": etat,
      "userId": userId,
      "centreId": centreId,
      "employeeId": employeeId,
    };
  }


  static Appointment empty() =>  Appointment(id: '', date: '', day: '', time: '', etat: '', userId: '',centreId: '',employeeId: null,);

  /// Factory method to create a UserModel from a Firestore document snapshot.
  factory Appointment.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return Appointment(
        id: document.id,
        date: data['date'] ?? '',
        time: data['time'] ?? '',
        day: data['day'] ?? '',
        userId: data['userId'] ?? '',
        etat: data['etat'] ?? '',
        centreId:  data['centreId'] ?? '',
        employeeId: data['employeeId'], // Initialize it from snapshot
      );
    } else {
      return Appointment
      .empty(); // Return an empty UserModel if document data is null
    }
  }

  /// Factory method to create an Appointment from a Map.
  factory Appointment.fromMap(Map<String, dynamic> data) {
    return Appointment(
      id: data['id'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      day: data['day'] ?? '',
      userId: data['userId'] ?? '',
      etat: data['etat'] ?? '',
      centreId: data['centreId'] ?? '',
      employeeId: data['employeeId'], // Initialize it from map
    );
  }
}
