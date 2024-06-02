import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/data/repositories/center/center_repository.dart';
import 'package:pfe_1/features/centre/controller/center_controller.dart';
import 'package:pfe_1/features/centre/view/profile/profile_center.dart';
import 'package:pfe_1/utils/network/network.dart';
import 'package:pfe_1/utils/popups/loaders.dart';

class UpdateCenterNameController extends GetxController {
  static UpdateCenterNameController get instance => Get.find();

  final centerName = TextEditingController();
  final centerController = CenterController.instance;
  final centerRepository = Get.put(CenterRepository());
  GlobalKey<FormState> updateCenterNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async {
    centerName.text = centerController.center.value.centerName;
  }

  Future<void> updateCenterName() async {
    try {

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;


      if (!updateCenterNameFormKey.currentState!.validate()) return;


      Map<String, dynamic> name = {'CenterName': centerName.text.trim()};
      await centerRepository.updateSingleField(name);

      centerController.center.value.centerName = centerName.text.trim();


      AppLoaders.successSnackBar(title: 'Congratulations', message: 'Your Name has been updated.');

      Get.off(() => const AppProfileScreenCenter());
    } catch (e) {
      // Handle error
      AppLoaders.errorSnackBar(title: "Oh Snap!",message: e.toString());
    }
  }

}
