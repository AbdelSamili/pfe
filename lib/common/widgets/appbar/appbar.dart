import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/device/device_utility.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = false,
  });

  final Widget? title; // Property: Widget displayed as the title of the app bar
  final bool showBackArrow; // Property: Determines whether to show the back arrow
  final IconData? leadingIcon; // Property: Icon to be displayed on the leading side of the app bar
  final List<Widget>? actions; // Property: List of action widgets to be displayed on the trailing side of the app bar
  final VoidCallback? leadingOnPressed; // Property: Callback function for the leading icon's onPressed event

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      // Property: Padding around the app bar
      child: AppBar(
        automaticallyImplyLeading: false,
        // Property: Determines whether to automatically show the leading widget
        leading: showBackArrow
            ? IconButton(
                onPressed: () => Get.back(), // Event: Go back to the previous screen
                icon: const Icon(Iconsax.arrow_left), // Icon: Back arrow icon
              ) : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnPressed,
                    // Event: Execute leading icon's onPressed callback
                    icon: Icon(leadingIcon), // Icon: Leading icon
                  ) : null,
        title: title, // Property: Widget displayed as the title of the app bar
        actions: actions, // Property: List of action widgets to be displayed on the trailing side of the app bar
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppDeviceUtils.getAppBarHeight()); // Property: Preferred size of the app bar
}
