import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfe_1/data/repositories/authentication/authentication_repository.dart';
import 'package:pfe_1/features/centre/model/center_model.dart';

class CenterRepository extends GetxController {
  static CenterRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // function to save client data to firestore
  Future<void> saveCenterRecord(CenterModel center) async {
    await _db.collection("Centers").doc(center.id).set(center.toJson());
  }

  // function to fetch client details based on user id
  Future<CenterModel> fetchCenterDetails() async {
    try {
      final documentSnapshot = await _db.collection("Centers").doc(AuthenticationRepository.instance.authUser?.uid).get();
      if (documentSnapshot.exists) {
        return CenterModel.fromSnapshot(documentSnapshot);
      } else {
        return CenterModel.empty();
      }
    } catch (e) {
      throw "Something is wrong please try again";
    }
  }

  // Function to update user data in Firestore
  Future<void> updateCenterDetails(CenterModel updatedCenter) async {
    try {
      await _db.collection("Centers").doc(updatedCenter.id).update(updatedCenter.toJson());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection("Centers").doc(AuthenticationRepository.instance.authUser?.uid).update(json);
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Function to remove user data from Firestore.
  Future<void> removeUserRecord(String centerId) async {
    try {
      await _db.collection("Centers").doc(centerId).delete();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Upload any Image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<CenterModel>> getAllCenters() async {
    try {
      final querySnapshot = await _db.collection("Centers").get();
      final List<CenterModel> centers = [];

      for (final doc in querySnapshot.docs) {
        final center = CenterModel.fromSnapshot(doc);
        centers.add(center);
      }

      return centers;
    } catch (e) {
      throw 'Something went wrong. Please try again';
      return []; // Retourne une liste vide en cas d'erreur
    }
  }
}
