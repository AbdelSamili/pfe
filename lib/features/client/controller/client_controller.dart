import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfe_1/data/repositories/authentication/authentication_repository.dart';
import 'package:pfe_1/data/repositories/client/client_repository.dart';
import 'package:pfe_1/features/authentification/view/login/login_view.dart';
import 'package:pfe_1/features/client/model/client_model.dart';
import 'package:pfe_1/features/client/view/profile/widgets/re_authenticate_login_form.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/network/network.dart';
import 'package:pfe_1/utils/popups/loaders.dart';

class ClientController extends GetxController {
  static ClientController get instance => Get.find();

  Rx<ClientModel> client = ClientModel.empty().obs;
  final clientRepository = Get.put(ClientRepository());

  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      final client = await clientRepository.fetchClientDetails();
      this.client(client);
    } catch (e) {
      client(ClientModel.empty());
    }
  }


  /// save user record for any registration provided
  Future<void> saveUserRecord(UserCredential? userCredential) async{
    try {

      await fetchUserRecord();

      if(client.value.id.isEmpty){
        if(userCredential != null){
          final nameParts = ClientModel.nameParts(userCredential.user!.displayName ?? '');
          final userName = ClientModel.generateUsername(userCredential.user!.displayName ?? '');

          final client = ClientModel(
            id: userCredential.user!.uid,
            firstName: nameParts[0],
            lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            userName: userName,
            email: userCredential.user!.email ?? '',
            phoneNumber: userCredential.user!.phoneNumber ?? '',
            password: '',
            profileImage: userCredential.user!.photoURL ?? '',
          );

          await clientRepository.saveClientRecord(client);
        }
      }

    } catch (e) {
      AppLoaders.warningSnackBar(
        title: 'Data not saved',
        message: 'Something went wrong while saving your information. You can re-save your data in your Profile.',
      );
    }
  }

  // Oussama methode
  Future<ClientModel> getClientInformation(String clientId) async {

    try {
      return await clientRepository.getClientData(clientId);
    } catch (e) {
      // Gérer les erreurs ici
      print('Error fetching client information: $e');
      rethrow; // Renvoyer l'erreur pour qu'elle puisse être gérée ailleurs si nécessaire
    }
  }


  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(AppSizes.md),
      title: 'Delete Account',
      middleText:
      'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
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

  void deleteUserAccount() async {
    try {

      final auth = AuthenticationRepository.instance;
      final provider = auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          Get.to(() => const ReAuthLoginFormClient());
        }
      }
    } catch (e) {
      AppLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void logOutAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(AppSizes.md),
      title: 'Logout Account',
      middleText:
      'Are you sure you want to logout your account permanently?',
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

  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      if (!reAuthFormKey.currentState!.validate()) return;


      await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(), verifyPassword.text.trim());
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
        final imageUrl = await clientRepository.uploadImage('Users/Images/Profile/', image);

        // Update User Image Record
        Map<String, dynamic> json = {'ImageUrl': imageUrl};
        await clientRepository.updateSingleField(json);

        client.value.profileImage = imageUrl;

        // Generate a unique query parameter
        final uniqueQueryParameter = DateTime.now().millisecondsSinceEpoch.toString();

        // Append the unique query parameter to the image URL
        final newImageUrl = '${client.value.profileImage}?v=$uniqueQueryParameter';

        // Update the profile image URL in your controller
        client.update((val) {
          val!.profileImage = newImageUrl;
        });

        // Show success message
        AppLoaders.successSnackBar(title: 'Congratulations', message: 'Your Profile Image has been updated!');
      }
    } catch (e) {
      // Show error message
      AppLoaders.errorSnackBar(title: 'Oh Snap', message: 'Something went wrong: $e');
    }
  }

// Future<void> fetchUserRecord() async{
  //   try{
  //
  //   }catch(e){
  //
  //   }
  // }
}