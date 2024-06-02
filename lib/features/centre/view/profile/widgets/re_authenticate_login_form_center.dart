import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/features/centre/controller/center_controller.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';
import 'package:pfe_1/utils/validators/validation.dart';

class ReAuthLoginFormCenter extends StatelessWidget {
  const ReAuthLoginFormCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CenterController.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Re-Authenticate User')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller.verifyEmail,
                  validator: AppValidator.validateEmail,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.email), labelText: AppTexts.email),
                ),
                const SizedBox(height: AppSizes.spaceBtwInputFields),
                Obx(
                      () => TextFormField(
                    obscureText: controller.hidePassword.value,
                    controller: controller.verifyPassword,
                    validator: (value) => AppValidator.validateEmptyText('Password', value),
                    decoration: InputDecoration(
                      labelText: AppTexts.password,
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                        icon: Icon(controller.hidePassword.value ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceBtwSections),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.reAuthenticateEmailAndPasswordUser(),
                    child: const Text("Verify"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
