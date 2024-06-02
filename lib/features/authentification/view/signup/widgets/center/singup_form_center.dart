import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/features/authentification/controller/singup/center/singup_controller_center.dart';
import 'package:pfe_1/features/authentification/view/signup/widgets/center/terms_condition_checkbox_center.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';
import 'package:pfe_1/utils/validators/validation.dart';

class SingUpFormCenter extends StatelessWidget {
  const SingUpFormCenter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SingUpControllerCenter());
    return Form(
      key: controller.signupFormKeyCenter,
      child: Column(
        children: [
          TextFormField(
            controller: controller.centerName,
            validator: (value) => AppValidator.validateEmptyText("Name of visite Center", value),
            decoration: const InputDecoration(
              labelText: 'Name of visite Center',
              prefixIcon: Icon(Iconsax.user),
            ),
            expands: false,
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields,),
          // Username
          TextFormField(
            controller: controller.matricule,
            validator: (value) => AppValidator.validateEmptyText("Matricule", value),
            decoration: const InputDecoration(
              labelText: 'Matricule',
              prefixIcon: Icon(Iconsax.user_edit),
            ),
            expands: false,
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields,),
          // Email
          TextFormField(
            controller: controller.email,
            validator: (value) => AppValidator.validateEmail(value),
            decoration: const InputDecoration(
              labelText: AppTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
            expands: false,
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields,),
          // Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => AppValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
              labelText: AppTexts.phoneNumber,
              prefixIcon: Icon(Iconsax.call),
            ),
            expands: false,
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields,),
          // Password
          Obx(
                () => TextFormField(
              controller: controller.password,
              validator: (value) => AppValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: AppTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
              ),
              expands: false,
            ),
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields,),
          // Image Upload Button
          TextFormField(
            controller: controller.imageUrl,
            validator: (value) => AppValidator.validateEmptyText("Image URL", value),
            decoration: const InputDecoration(
              labelText: 'Image URL',
              prefixIcon: Icon(Iconsax.image),
            ),
            readOnly: true,
            onTap: () => controller.pickImage(), // Call the pickImage method
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields,),
          // Terms&Condition Check
          const AppTermAndConditionCheckBoxCenter(),
          const SizedBox(height: AppSizes.spaceBtwSections,),
          // Sign Up Button
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.signup(), child: const Text(AppTexts.createAccount))),
        ],
      ),
    );
  }
}
