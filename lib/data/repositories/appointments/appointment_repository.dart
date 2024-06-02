import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pfe_1/features/appointment/models/appointment.dart';
import 'package:pfe_1/features/centre/model/center_model.dart';
// Importez le modèle Centre


class AppointmentRepository extends GetxController {
  static AppointmentRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

     Future<void> saveAppointment(Appointment appointment) async {
    await _db.collection("Appointements").add(appointment.toJson());
  }

  Future<void> modifyAppointment({required Appointment appointment, required String initialState,}) async {
    // Add the initial state to the appointment data
    appointment.etat = initialState;

    // Save the appointment to Firestore
    await _db.collection("Appointments").add(appointment.toJson());
  }
   // function to get client data from firestore
  Future<Appointment> getAppointmentData(String appointmentId) async {
    DocumentSnapshot<Map<String, dynamic>> appointmentSnapshot =
        await _db.collection('Appointements').doc(appointmentId).get();
    return Appointment.fromSnapshot(appointmentSnapshot);
  }

  // Méthode pour récupérer tous les rendez-vous d'un client spécifique
  Future<List<Appointment>> getAppointmentsForUser(String userId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('Appointements')
        .where('userId', isEqualTo: userId)
        .get();
    
    return querySnapshot.docs.map((doc) => Appointment.fromSnapshot(doc)).toList();
  }

  // Méthode pour récupérer tous les rendez-vous d'un centre spécifique
  Future<List<Appointment>> getAppointmentsForCentre(String centreId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('Appointements')
        .where('centreId', isEqualTo: centreId)
        .get();
    
    return querySnapshot.docs.map((doc) => Appointment.fromSnapshot(doc)).toList();
  }
   // Méthode pour récupérer tous les rendez-vous pour une date spécifique
  Future<List<Appointment>> getAppointmentsForDate(String date) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('Appointements')
        .where('date', isEqualTo: date.toString()) // Adapter selon votre modèle de données
        .get();
    
    return querySnapshot.docs.map((doc) => Appointment.fromSnapshot(doc)).toList();
  }

  Future<CenterModel> getCentreData(String centreId) async {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _db
          .collection('Centers')
          .doc(centreId) // Utilisez l'ID de document pour obtenir un document spécifique
          .get();

      if (docSnapshot.exists) {
          // Si le document existe, convertissez-le en un objet CenterModel
          return CenterModel.fromSnapshot(docSnapshot);
      } else {
          // Si le document n'existe pas, renvoyez null ou lancez une erreur selon votre logique
          return CenterModel.empty();
      }
}

}


