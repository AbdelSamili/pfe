import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:firebase_storage/firebase_storage.dart';


import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfe_1/data/repositories/authentication/authentication_repository.dart';
import 'package:pfe_1/features/client/model/client_model.dart';

class ClientRepository extends GetxController {
  static ClientRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // function to save client data to firestore
  Future<void> saveClientRecord(ClientModel client) async {
    await _db.collection("Clients").doc(client.id).set(client.toJson());
  }


  // Oussama methode function to get client data from firestore
  Future<ClientModel> getClientData(String clientId) async {
    DocumentSnapshot<Map<String, dynamic>> clientSnapshot =
    await _db.collection('Clients').doc(clientId).get();

    return ClientModel.fromSnapshot(clientSnapshot);
  }

  /// function to fetch client details based on user id
  Future<ClientModel> fetchClientDetails() async {
    try{
      final documentSnapshot = await _db.collection("Clients").doc(AuthenticationRepository.instance.authUser?.uid).get();
      if(documentSnapshot.exists){
        return ClientModel.fromSnapshot(documentSnapshot);
      }else {
        return ClientModel.empty();
      }
    }catch (e){
      throw "Something is wrong please try again";
    }
  }

  /// Function to update user data in Firestore
  Future<void> updateClientDetails(ClientModel updatedClient) async {
    try {
      await _db.collection("Clients").doc(updatedClient.id).update(updatedClient.toJson());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  ///Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection("Clients").doc(AuthenticationRepository.instance.authUser?.uid).update(json);
    }catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to remove user data from Firestore.
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Clients").doc(userId).delete();
    }catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  /// Upload any Image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    }catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


}