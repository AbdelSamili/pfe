import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfe_1/data/repositories/authentication/authentication_repository.dart';
import 'package:pfe_1/data/repositories/center/center_repository.dart';
import 'package:pfe_1/features/authentification/view/login/login_view.dart';
import 'package:pfe_1/features/centre/model/center_model.dart';
import 'package:pfe_1/features/centre/view/profile/widgets/re_authenticate_login_form_center.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/network/network.dart';
import 'package:pfe_1/utils/popups/loaders.dart';

class CenterController extends GetxController {
  static CenterController get instance => Get.find();

  Rx<CenterModel> center = CenterModel.empty().obs;
  final centerRepository = Get.put(CenterRepository());
  List<CenterModel> centers = [];

  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchClientRecord();
  }

  Future<void> fetchClientRecord() async {
    try {
      final center = await centerRepository.fetchCenterDetails();
      this.center(center);
    } catch (e) {
      center(CenterModel.empty());
    }
  }

  Future<void> updateCenterDescription(String description) async {
    try {
      await centerRepository.updateSingleField({'Description': description});
      center.update((val) {
        val?.description = description;
      });
      AppLoaders.successSnackBar(title: 'Success', message: 'Description updated successfully.');
    } catch (e) {
      AppLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> updateCenterCreationDate(String creationDate) async {
    try {
      await centerRepository.updateSingleField({'CreationDate': creationDate});
      center.update((val) {
        val?.creationDate = creationDate;
      });
      AppLoaders.successSnackBar(title: 'Success', message: 'Creation date updated successfully.');
    } catch (e) {
      AppLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  void logOutAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(AppSizes.md),
      title: 'Logout Account',
      middleText: 'Are you sure you want to logout your account permanently?',
      confirm: ElevatedButton(
        onPressed: () async => AuthenticationRepository.instance.logOut(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          side: const BorderSide(color: Colors.blue),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Text('LogOut'),
        ),
      ), // ElevatedButton
      cancel: OutlinedButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
      ), // OutlinedButton
    );
  }

  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(AppSizes.md),
      title: 'Delete Account',
      middleText:
      'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () async => deleteClientAccount(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Text('Delete'),
        ),
      ), // ElevatedButton
      cancel: OutlinedButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
      ), // OutlinedButton
    );
  }

  void deleteClientAccount() async {
    try {
      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          Get.to(() => const ReAuthLoginFormCenter());
        }
      }
    } catch (e) {
      AppLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      if (!reAuthFormKey.currentState!.validate()) return;

      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
          verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      AppLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Upload Profile Image
  Future<void> uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        // Upload Image
        final imageUrl = await centerRepository.uploadImage(
            'Centers/Images/Profile/', image);

        // Update User Image Record
        Map<String, dynamic> json = {'ImageUrl': imageUrl};
        await centerRepository.updateSingleField(json);

        center.value.profileImage = imageUrl;

        // Show success message
        AppLoaders.successSnackBar(
            title: 'Congratulations',
            message: 'Your Profile Image has been updated!');
      }
    } catch (e) {
      // Show error message
      AppLoaders.errorSnackBar(
          title: 'Oh Snap', message: 'Something went wrong: $e');
    }
  }

  Future<void> fetchAllCenters() async {
    try {
      final List<CenterModel> allCenters =
      await centerRepository.getAllCenters();
      centers.assignAll(allCenters);
    } catch (e) {
      // Handle error
      print('Error fetching centers: $e');
    }
  }
}
