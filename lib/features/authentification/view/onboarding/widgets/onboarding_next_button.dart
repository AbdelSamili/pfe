import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/features/authentification/view/login/login_view.dart';
import 'package:pfe_1/utils/constants/colors.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/device/device_utility.dart';
import 'package:pfe_1/utils/helper/helper_function.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);
    return Positioned(
        bottom: AppDeviceUtils.getBottomNavigationBarHeight(),
        right: AppSizes.defaultSpace,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(shape: const CircleBorder(),backgroundColor: dark ? AppColors.primary : Colors.black),
          onPressed: (){
            Get.offAll( const LoginScreen());
          },
          child: const Icon(Iconsax.arrow_right_3),
        )
    );
  }
}


