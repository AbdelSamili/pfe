import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pfe_1/data/repositories/authentication/authentication_repository.dart';
import 'package:pfe_1/data/repositories/client/client_repository.dart';
import 'package:pfe_1/features/authentification/view/signup/client/verifyemail_client_view.dart';
import 'package:pfe_1/features/client/model/client_model.dart';
import 'package:pfe_1/utils/network/network.dart';
import 'package:pfe_1/utils/popups/loaders.dart';

class SingUpControllerClient extends GetxController {
  static SingUpControllerClient get instance => Get.find();

  // variable
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>(); //for form validation

  // SignUp
  void signup() async {
      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) return;


      // Validate form fields
      if(!signupFormKey.currentState!.validate()) return;

      // Ensure privacy policy acceptance
      if(!privacyPolicy.value){
        AppLoaders.warningSnackBar(
          title: "Accept Privacy Policy",
          message: "In order to create account,you must have to accepte the privacy policy && terms of use",
        );
        return;
      }

      // Register user in Firebase Authentication & Save user data in Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());
      // Save additional user data in Firebase Firestore
      final newClient = ClientModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        userName: userName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        password: password.text.trim(),
        profileImage: '',
      );

      final clientRepository = Get.put(ClientRepository());
      await clientRepository.saveClientRecord(newClient);

      // Show success message
      AppLoaders.successSnackBar(title: "Congratulation!",message: "Your Account Has been Created! Verify email to continue");
      // Move to Verify Email Screen
      Get.to(() => VerifyEmailClientScreen(email: email.text.trim(),));

  }

}