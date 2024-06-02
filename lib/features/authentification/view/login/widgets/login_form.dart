import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/features/authentification/controller/login/login_controller.dart';
import 'package:pfe_1/features/authentification/view/password_configuration/forget_password.dart';
import 'package:pfe_1/features/authentification/view/signup/center/signup_center_view.dart';
import 'package:pfe_1/features/authentification/view/signup/client/singup_client_view.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';
import 'package:pfe_1/utils/validators/validation.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: AppSizes.spaceBtwSections),
        child: Column(
          children: [
            //Email
            TextFormField(
              controller: controller.email,
              validator: (value) => AppValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: AppTexts.email,
              ),
            ),
            const SizedBox(
              height: AppSizes.spaceBtwInputFields,
            ),
            //Password
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) => AppValidator.validatePassword(value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: AppTexts.password,
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: AppSizes.spaceBtwInputFields / 2,
            ),
            // Remebre me and forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remebre me
                Row(
                  children: [
                    Obx(() => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value),
                    ),
                    const Text(AppTexts.rememberMe),
                  ],
                ),
                // Forget Password
                TextButton(
                    onPressed: () => Get.to(() => const ForgetPasswordScreen()),
                    child: Text(
                      AppTexts.forgotPassword,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
              ],
            ),
            const SizedBox(
              height: AppSizes.spaceBtwSections,
            ),
            // Sign in Button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.emailAndPasswordSignIn(),
                    child: const Text(AppTexts.signIn),
                ),
            ),
            const SizedBox(
              height: AppSizes.spaceBtwItems,
            ),
            // Create account Button
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {
                      Get.to(() => const SingUpScreenClient());
                    },
                    child: const Text(AppTexts.createAccount))),
            const SizedBox(
              height: AppSizes.spaceBtwItems,
            ),
            // Create Account Centre Visit Button
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {
                      Get.to(() => const SingUpScreenCenter());
                    },
                    child: const Text(AppTexts.createAccountCenter))),
          ],
        ),
      ),
    );
  }
}
