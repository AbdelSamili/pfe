import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pfe_1/data/repositories/authentication/authentication_repository.dart';
import 'package:pfe_1/features/client/controller/client_controller.dart';
import 'package:pfe_1/utils/network/network.dart';
import 'package:pfe_1/utils/popups/loaders.dart';

class LoginController extends GetxController{
  static LoginController get instance => Get.find();

  //Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final clientController = Get.put(ClientController());

  /// Email and Password SignIn
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start Loading


      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;


      // Form Validation
      if (!loginFormKey.currentState!.validate()) return;


      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login user using Email & Password Authentication
      final userCredential = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());


      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      AppLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
 // Store the authentication token in shared preferences
  
  Future<void> googleSignIn() async {
    try{
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      final userCredential = await AuthenticationRepository.instance.signInWithGoogle();

      await clientController.saveUserRecord(userCredential);

      AuthenticationRepository.instance.screenRedirect();
    }catch(e){
      AppLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
  

}