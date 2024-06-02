import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pfe_1/data/repositories/appointments/appointment_repository.dart';
import 'package:pfe_1/data/repositories/center/center_repository.dart';

import 'package:pfe_1/features/appointment/models/appointment.dart';
import 'package:pfe_1/features/centre/model/center_model.dart';

class AppointmentController extends GetxController {
  static AppointmentController get instance => Get.find();

  final appointmentRepository = Get.put(AppointmentRepository());
  final centreRepository = Get.put(CenterRepository());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Existing code ...

  @override
  void onInit() {
    super.onInit();
    Timer.periodic(Duration(minutes: 1), (timer) => _updateAppointmentStatuses());
  }

  Future<void> _updateAppointmentStatuses() async {
    try {
      final now = DateTime.now();
      final appointmentsSnapshot = await _firestore.collection('Appointements')
          .where('etat', isEqualTo: 'upcoming')
          .get();

      for (var doc in appointmentsSnapshot.docs) {
        final appointmentData = doc.data();
        final appointmentDate = DateTime.parse('${appointmentData['date']} ${appointmentData['time']}');
        if (now.isAfter(appointmentDate.add(Duration(hours: 1)))) {
          await doc.reference.update({'etat': 'complete'});
        }
      }
    } catch (e) {
      print('Error updating appointment statuses: $e');
    }
  }

  // Méthode pour récupérer les informations sur un rendez-vous
  Future<Appointment> getAppointmentInformation(String appointmentId) async {
    try {
      return await appointmentRepository.getAppointmentData(appointmentId);
    } catch (e) {
      // Gérer les erreurs ici
      print('Error fetching appointment information: $e');
      rethrow; // Renvoyer l'erreur pour qu'elle puisse être gérée ailleurs si nécessaire
    }
  }

  Future<List<Appointment>> getAppointmentsforCentre(String centreId) async {
    try {
      return await appointmentRepository.getAppointmentsForCentre(centreId);
    } catch (e) {
      // Gérer les erreurs ici
      print('Error fetching appointment information: $e');
      rethrow; // Renvoyer l'erreur pour qu'elle puisse être gérée ailleurs si nécessaire
    }
  }

  Future<void> modifyAppointmentEtat({
    required Appointment appointment,
    required String initialState, // Initial state of the appointment
  }) async {
    try {
      // Add the appointment with the specified initial state
      await appointmentRepository.modifyAppointment(
        appointment: appointment,
        initialState: initialState,
      );
    } catch (e) {
      // Handle errors
      print('Error creating appointment: $e');
      rethrow;
    }
  }


  // Méthode pour ajouter un nouveau rendez-vous
  Future<void> addAppointment(Appointment appointment) async {
    try {
      await appointmentRepository.saveAppointment(appointment);
    } catch (e) {
      // Gérer les erreurs ici
      print('Error adding appointment: $e');
      rethrow; // Renvoyer l'erreur pour qu'elle puisse être gérée ailleurs si nécessaire
    }
  }



  Future<List<Map<String, dynamic>>> getAppointmentsForUserWithCentreDetails(String userId) async {
    try {
      // Récupérer les rendez-vous de l'utilisateur
      List<Appointment> appointments = await appointmentRepository.getAppointmentsForUser(userId);
      // Initialiser une liste pour stocker les rendez-vous avec les détails du centre
      List<Map<String, dynamic>> appointmentsWithCentreDetails = [];
      // Parcourir chaque rendez-vous
      for (Appointment appointment in appointments) {
        // Convertir l'objet Appointment en Map<String, dynamic>
        Map<String, dynamic> appointmentData = appointment.toJson();
        print(appointment.centreId);

        // Include the document ID in appointmentData
        appointmentData['id'] = appointment.id;

        // Récupérer les détails du centre pour chaque rendez-vous
        if (appointment.centreId != "") {
          CenterModel centreDetails = await appointmentRepository.getCentreData(appointment.centreId);
          // Vérifier si les détails du centre sont disponibles
          // Convertir les détails du centre en Map<String, dynamic>
          Map<String, dynamic> centreData = centreDetails.toJson();
          // Ajouter les détails du centre à l'objet appointmentData
          appointmentData['centreDetails'] = centreData;
          // Ajouter l'objet appointmentData à la liste des rendez-vous avec les détails du centre
          appointmentsWithCentreDetails.add(appointmentData);
        }
      }
      // Retourner la liste des rendez-vous avec les détails du centre
      return appointmentsWithCentreDetails;
    } catch (e) {
      // Gérer les erreurs lors de la récupération des rendez-vous
      print('Error fetching appointments for user ici le probleme: $e');
      // Propager l'exception pour qu'elle soit traitée par l'appelant
      rethrow;
    }
  }

  Future<List<Appointment>> getAppointmentsForTodayWithUpcomingStatus(String centreId) async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final querySnapshot = await _firestore.collection('Appointements')
          .where('centreId', isEqualTo: centreId)
          .where('etat', isEqualTo: 'upcoming')
          .get();

      return querySnapshot.docs.map((doc) => Appointment.fromSnapshot(doc)).toList();
    } catch (e) {
      // Handle errors here
      print('Error fetching appointments for today: $e');
      rethrow; // Re-throw the error to be handled elsewhere if necessary
    }
  }


  Future<List<Map<String, dynamic>>> getAppointmentsForCenterWithCentreDetails(String centerId) async {
    try {
      // Récupérer les rendez-vous de l'center
      List<Appointment> appointments = await appointmentRepository.getAppointmentsForCentre(centerId);
      // Initialiser une liste pour stocker les rendez-vous avec les détails du centre
      List<Map<String, dynamic>> appointmentsWithCentreDetails = [];
      // Parcourir chaque rendez-vous
      for (Appointment appointment in appointments) {
        // Convertir l'objet Appointment en Map<String, dynamic>
        Map<String, dynamic> appointmentData = appointment.toJson();
        print(appointment.centreId);
        // Récupérer les détails du centre pour chaque rendez-vous
        if (appointment.centreId != "") {
          CenterModel centreDetails =
          await appointmentRepository.getCentreData(appointment.centreId);
          // Vérifier si les détails du centre sont disponibles
          // Convertir les détails du centre en Map<String, dynamic>
          Map<String, dynamic> centreData = centreDetails.toJson();
          // Ajouter les détails du centre à l'objet appointmentData
          appointmentData['centreDetails'] = centreData;
          // Ajouter l'objet appointmentData à la liste des rendez-vous avec les détails du centre
          appointmentsWithCentreDetails.add(appointmentData);
        }
      }
      // Retourner la liste des rendez-vous avec les détails du centre
      return appointmentsWithCentreDetails;
    } catch (e) {
      // Gérer les erreurs lors de la récupération des rendez-vous
      print('Error fetching appointments for user ici le probleme: $e');
      // Propager l'exception pour qu'elle soit traitée par l'appelant
      rethrow;
    }
  }

  // Méthode pour récupérer tous les rendez-vous pour une date spécifique
  Future<List<Appointment>> getAppointmentsForDate(String date,
      String uid) async {
    try {
      return await appointmentRepository.getAppointmentsForDate(date);
    } catch (e) {
      // Gérer les erreurs ici
      print('Error fetching appointments for date: $e');
      rethrow; // Renvoyer l'erreur pour qu'elle puisse être gérée ailleurs si nécessaire
    }
  }

  // Method to fetch upcoming appointments not associated with any employee
  Future<List<Appointment>> getAvailableUpcomingAppointments(String centreId) async {
    try {
      final querySnapshot = await _firestore.collection('Appointements')
          .where('centreId', isEqualTo: centreId)
          .where('etat', isEqualTo: 'upcoming')
          .where('employeeId', isEqualTo: 'null') // Ensure it's null
          .get();

      return querySnapshot.docs.map((doc) => Appointment.fromSnapshot(doc)).toList();
    } catch (e) {
      // Handle errors here
      print('Error fetching available upcoming appointments: $e');
      rethrow; // Re-throw the error to be handled elsewhere if necessary
    }
  }


  Future<List<Map<String, dynamic>>> getAppointmentsWithEmployees(String centreId) async {
    try {
      final querySnapshot = await _firestore.collection('Appointements')
          .where('centreId', isEqualTo: centreId)
          .where('etat', isEqualTo: 'upcoming')
          .where('employeeId', isNotEqualTo: 'null') // Ensure it has an associated employee
          .get();

      List<Map<String, dynamic>> appointmentsWithEmployees = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();

        if (data['employeeId'] != null && data['employeeId'] != "null") {
          DocumentSnapshot employeeDoc = await _firestore.collection('Centers').doc(centreId).collection('Employees').doc(data['employeeId']).get();
          if (employeeDoc.exists) {
            data['employee'] = employeeDoc.data();
          }
        }

        if (data['userId'] != null && data['userId'] != "null") {
          DocumentSnapshot clientDoc = await _firestore.collection('Clients').doc(data['userId']).get();
          if (clientDoc.exists) {
            data['client'] = clientDoc.data();
          }
        }

        appointmentsWithEmployees.add(data);
      }

      return appointmentsWithEmployees;
    } catch (e) {
      print('Error fetching appointments with employees: $e');
      rethrow;
    }
  }

  // Method to associate an employee with an appointment
  Future<void> associateEmployeeWithAppointment(String employeeId, String appointmentId) async {
    try {
      await _firestore.collection('Appointements').doc(appointmentId).update({
        'employeeId': employeeId,
      });
    } catch (e) {
      print('Error associating employee with appointment: $e');
    }
  }
}