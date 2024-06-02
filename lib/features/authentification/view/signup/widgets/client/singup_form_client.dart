import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/features/authentification/controller/singup/client/singup_controller_client.dart';
import 'package:pfe_1/features/authentification/view/signup/widgets/client/terms_condition_checkbox_client.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';
import 'package:pfe_1/utils/validators/validation.dart';

class AppSingUpFormClient extends StatelessWidget {
  const AppSingUpFormClient({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SingUpControllerClient());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) => AppValidator.validateFirstName(value),
                  decoration: const InputDecoration(
                    labelText: AppTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  expands: false,
                ),
              ),
              const SizedBox(width: AppSizes.spaceBtwInputFields,),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) => AppValidator.validateLastName(value),
                  decoration: const InputDecoration(
                    labelText: AppTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  expands: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields,),
          // Username
          TextFormField(
            controller: controller.userName,
            validator: (value) => AppValidator.validateUsername(value),
            decoration: const InputDecoration(
              labelText: AppTexts.username,
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
          // Terms&Condition Check
          const AppTermAndConditionCheckBoxClient(),
          const SizedBox(height: AppSizes.spaceBtwSections,),
          // Sing Up Button
          SizedBox(width: double.infinity ,child: ElevatedButton(onPressed: () => controller.signup(), child: const Text(AppTexts.createAccount))),
        ],
      ),
    );
  }
}
