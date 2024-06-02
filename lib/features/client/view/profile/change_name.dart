import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/common/widgets/appbar/appbar.dart';
import 'package:pfe_1/features/client/controller/change_name_controller_client.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';
import 'package:pfe_1/utils/validators/validation.dart';

class ChangeNameClient extends StatelessWidget {
  const ChangeNameClient({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateClientNameController());
    return Scaffold(
      /// Custom Appbar
      appBar: CAppBar(
        showBackArrow: true,
        title: Text('Change Name', style: Theme.of(context).textTheme.headlineMedium),
      ), // TAppBar

      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(
              'Use real name for easy verification. This name will appear on several pages.',
              style: Theme.of(context).textTheme.labelMedium,
            ), // Text
            const SizedBox(height: AppSizes.spaceBtwSections),

            /// Text field and Button
            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.firstName,
                    validator: (value) => AppValidator.validateEmptyText('First name', value),
                    expands: false,
                    decoration: const InputDecoration(labelText: AppTexts.firstName, prefixIcon: Icon(Iconsax.user)),
                  ), // TextFormField
                  const SizedBox(height: AppSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.lastName,
                    validator: (value) => AppValidator.validateEmptyText('Last name', value),
                    expands: false,
                    decoration: const InputDecoration(labelText: AppTexts.lastName, prefixIcon: Icon(Iconsax.user)),
                  ), // TextFormField
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateUserName(),
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
