import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/common/widgets/loaders/animation_loader.dart';
import 'package:pfe_1/utils/constants/colors.dart';
import 'package:pfe_1/utils/helper/helper_function.dart'; // Import Get for access to overlayContext

/// A utility class for managing a full-screen loading dialog.
class AppFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  /// This method doesn't return anything.
  ///
  /// Parameters:
  /// - text: The text to be displayed in the loading dialog.
  /// - animation: The Lottie animation to be shown.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!, // Use Get.overlayContext for overlay dialogs
      barrierDismissible: false, // The dialog can't be dismissed by tapping outside it
      builder: (_) => PopScope(
        canPop: false, // Disable popping with the back button
        child: Container(
          color: AppHelperFunctions.isDarkMode(Get.context!) ? AppColors.dark : AppColors.white,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 250),
                AppAnimationLoaderWidget(text: text,animation:animation),
              ],
            ),
          ), // Column
        ), // Container
      ), // WillPopScope
    ); // showDialog
  }

  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }
}
