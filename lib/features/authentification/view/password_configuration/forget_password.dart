import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/features/authentification/controller/forget_password/forget_password_controller.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';
import 'package:pfe_1/utils/validators/validation.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(AppTexts.forgotPasswordTitle,style: Theme.of(context).textTheme.headlineMedium,),
            const SizedBox(height: AppSizes.spaceBtwItems,),
            Text(AppTexts.forgotPasswordSubTitle,style: Theme.of(context).textTheme.bodyMedium,),
            const SizedBox(height: AppSizes.spaceBtwSections * 2,),
            // Text Feild
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: (value) => AppValidator.validateEmail(value),
                decoration: const InputDecoration(
                  labelText: AppTexts.email,
                  prefixIcon: Icon(Iconsax.direct_right),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwSections,),
            // Submit button
            SizedBox(width: double.infinity,child: ElevatedButton(onPressed: () => controller.sendPasswordResetEmail(), child: const Text("Submit")))
          ],
        ),
      ),
    );
  }
}
