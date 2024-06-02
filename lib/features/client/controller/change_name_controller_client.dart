import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/data/repositories/client/client_repository.dart';
import 'package:pfe_1/features/client/controller/client_controller.dart';
import 'package:pfe_1/features/client/view/profile/profile_client.dart';
import 'package:pfe_1/utils/network/network.dart';
import 'package:pfe_1/utils/popups/loaders.dart';

class UpdateClientNameController extends GetxController {
  static UpdateClientNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final clientController = ClientController.instance;
  final clientRepository = Get.put(ClientRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async {
    firstName.text = clientController.client.value.firstName;
    lastName.text = clientController.client.value.lastName;
  }

  Future<void> updateUserName() async {
    try {

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;


      if (!updateUserNameFormKey.currentState!.validate()) return;


      Map<String, dynamic> name = {'FirstName': firstName.text.trim(), 'LastName': lastName.text.trim()};
      await clientRepository.updateSingleField(name);

      clientController.client.value.firstName = firstName.text.trim();
      clientController.client.value.lastName = lastName.text.trim();


      AppLoaders.successSnackBar(title: 'Congratulations', message: 'Your Name has been updated.');

      Get.off(() => const AppProfileScreenClient());
    } catch (e) {
      // Handle error
      AppLoaders.errorSnackBar(title: "Oh Snap!",message: e.toString());
    }
  }

}
