import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_1/utils/constants/colors.dart';
import 'package:pfe_1/utils/constants/sizes.dart'; // Assuming you're using Lottie for animations

class AppAnimationLoaderWidget extends StatelessWidget {
  // Default constructor for the AppAnimationLoaderWidget.
  const AppAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  });

  final String text; // The text to be displayed below the animation.
  final String animation; // The path to the Lottie animation file.
  final bool showAction; // Whether to show an action button below the text.
  final String? actionText; // The text to be displayed on the action button.
  final VoidCallback? onActionPressed; // Callback function to be executed when the action button is pressed.

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              animation,
              width: MediaQuery.of(context).size.width * 0.8,
            ), // Display Lottie animation
            const SizedBox(height: AppSizes.defaultSpace), // Adjust the spacing as needed
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.defaultSpace),
            showAction
                ? SizedBox(
                    width: 250,
                    child: OutlinedButton(
                      onPressed: onActionPressed,
                      style: OutlinedButton.styleFrom(backgroundColor: AppColors.dark),
                      child: Text(
                        actionText!,
                        style: Theme.of(context).textTheme.bodyMedium!,
                  ), // Text
                ), // OutlinedButton
              ) : const SizedBox(),
          ], // Children
        ),
      ), // Column
    ); // Center
  }
}
