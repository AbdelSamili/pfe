import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/common/widgets/appbar/appbar.dart';
import 'package:pfe_1/features/centre/controller/change_name_controller_center.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';
import 'package:pfe_1/utils/validators/validation.dart';

class ChangeNameCenter extends StatelessWidget {
  const ChangeNameCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateCenterNameController());
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
              key: controller.updateCenterNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.centerName,
                    validator: (value) => AppValidator.validateEmptyText('Center Name', value),
                    expands: false,
                    decoration: const InputDecoration(labelText: AppTexts.firstName, prefixIcon: Icon(Iconsax.user)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateCenterName(),
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
