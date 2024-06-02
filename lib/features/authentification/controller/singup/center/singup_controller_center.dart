import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pfe_1/data/repositories/authentication/authentication_repository.dart';
import 'package:pfe_1/data/repositories/center/center_repository.dart';
import 'package:pfe_1/features/authentification/view/signup/client/verifyemail_client_view.dart';
import 'package:pfe_1/features/centre/model/center_model.dart';
import 'package:pfe_1/utils/network/network.dart';
import 'package:pfe_1/utils/popups/loaders.dart';
import 'package:image_picker/image_picker.dart';

class SingUpControllerCenter extends GetxController {
  static SingUpControllerCenter get instance => Get.find();

  // Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final centerName = TextEditingController();
  final matricule = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final imageUrl = TextEditingController(); // Controller for image URL
  GlobalKey<FormState> signupFormKeyCenter = GlobalKey<FormState>(); // For form validation

  // Method to pick an image
  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        final uploadedImageUrl = await CenterRepository().uploadImage(
            'Centers/Images/Profile/', image);

        imageUrl.text = uploadedImageUrl;

        AppLoaders.successSnackBar(
            title: 'Success',
            message: 'Center Image has been uploaded!');
      }
    } catch (e) {
      AppLoaders.errorSnackBar(
          title: 'Error', message: 'Something went wrong: $e');
    }
  }

  // SignUp method
  void signup() async {
    // Check internet connectivity
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) return;

    // Validate form fields
    if (!signupFormKeyCenter.currentState!.validate()) return;

    // Ensure privacy policy acceptance
    if (!privacyPolicy.value) {
      AppLoaders.warningSnackBar(
        title: "Accept Privacy Policy",
        message: "In order to create an account, you must accept the privacy policy & terms of use",
      );
      return;
    }

    // Register Center in Firebase Authentication & Save user data in Firebase
    final centerCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());
    // Save additional Center data in Firebase Firestore
    final newCenter = CenterModel(
      id: centerCredential.user!.uid,
      centerName: centerName.text.trim(),
      matricule: matricule.text.trim(),
      email: email.text.trim(),
      phoneNumber: phoneNumber.text.trim(),
      password: password.text.trim(),
      profileImage: imageUrl.text, // Use the uploaded image URL
      description: '', // Initialize description as an empty string
      creationDate: DateFormat('yyyy-MM-dd').format(DateTime.now()), // Initialize creation date with the current date in yyyy-MM-dd format
    );

    final centerRepository = Get.put(CenterRepository());
    await centerRepository.saveCenterRecord(newCenter);

    // Show success message
    AppLoaders.successSnackBar(title: "Congratulation!", message: "Your Account Has been Created! Verify email to continue");
    // Move to Verify Email Screen
    Get.to(() => VerifyEmailClientScreen(email: email.text.trim()));
  }
}
