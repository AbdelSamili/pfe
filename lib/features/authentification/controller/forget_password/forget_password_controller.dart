import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/data/repositories/authentication/authentication_repository.dart';
import 'package:pfe_1/features/authentification/view/password_configuration/reset_password.dart';
import 'package:pfe_1/utils/network/network.dart';
import 'package:pfe_1/utils/popups/loaders.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send Reset Password Email
  sendPasswordResetEmail() async {
    try {
      // Implement your logic for sending password reset email

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      if (!forgetPasswordFormKey.currentState!.validate()) return;

      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      AppLoaders.successSnackBar(title: 'Email Sent',message: "Email link Sent to reset your password");

      Get.to(() => ResetPasswordScreen(email: email.text.trim(),));
    } catch (e) {
      AppLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      // Implement your logic for sending password reset email

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      if (!forgetPasswordFormKey.currentState!.validate()) return;

      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      AppLoaders.successSnackBar(title: 'Email Sent',message: "Email link Sent to reset your password".tr);

    } catch (e) {
      AppLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
