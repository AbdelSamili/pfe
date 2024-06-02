import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/data/repositories/authentication/authentication_repository.dart';
import 'package:pfe_1/features/authentification/controller/singup/center/verifyemail_controller_center.dart';
import 'package:pfe_1/utils/constants/images_strings.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';
import 'package:pfe_1/utils/helper/helper_function.dart';

class VerifyEmailCenterScreen extends StatelessWidget {
  const VerifyEmailCenterScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailControllerCenter());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => AuthenticationRepository.instance.logOut(),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              // image
              Image(image: const AssetImage(AppImages.sendEmailVerification),width: AppHelperFunctions.screenWidth() * 0.6,),
              const SizedBox(height: AppSizes.spaceBtwSections,),
              // Title && Subtitle
              Text(AppTexts.confirmEmail,style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
              const SizedBox(height: AppSizes.spaceBtwItems,),
              Text(email ?? '',style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,),
              const SizedBox(height: AppSizes.spaceBtwItems,),
              Text(AppTexts.confirmEmailSubTitle,style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,),
              const SizedBox(height: AppSizes.spaceBtwSections,),
              // Buttons
              SizedBox(width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.checkEmailVerificationStatus(),
                    child: const Text(AppTexts.tContinue),
                ),
              ),
              const SizedBox(height: AppSizes.spaceBtwItems,),
              SizedBox(width: double.infinity,child: TextButton(onPressed: () => controller.sendEmailVerification(), child: const Text(AppTexts.resendEmail))),
            ],
          ),
        ),
      ),
    );
  }
}