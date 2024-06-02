import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/features/centre/controller/employe_controller.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/validators/validation.dart';

class EmployeeForm extends StatelessWidget {
  const EmployeeForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeeController());
    return Form(
      key: controller.employeeFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.fullName,
            validator: (value) => AppValidator.validateFullName(value),
            decoration: const InputDecoration(
              labelText: "Full Name",
              prefixIcon: Icon(Iconsax.user),
            ),
            expands: false,
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.dateOfBirth,
            validator: (value) => AppValidator.validateDateOfBirth(value),
            readOnly: true,
            onTap: () => controller.pickDateOfBirth(context),
            decoration: const InputDecoration(
              labelText: "Date of Birth",
              prefixIcon: Icon(Iconsax.calendar),
            ),
            expands: false,
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.identification,
            validator: (value) => AppValidator.validateIdentification(value),
            decoration: const InputDecoration(
              labelText: "Identification Number",
              prefixIcon: Icon(Iconsax.key),
            ),
            expands: false,
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.imageUrl,
            validator: (value) => AppValidator.validateImageUrl(value),
            readOnly: true,
            onTap: () => controller.pickImage(),
            decoration: const InputDecoration(
              labelText: "Image URL",
              prefixIcon: Icon(Iconsax.image),
              suffixIcon: Icon(Icons.upload),
            ),
            expands: false,
          ),
          const SizedBox(height: AppSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => AppValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
              labelText: "Phone Number",
              prefixIcon: Icon(Iconsax.call),
            ),
            expands: false,
          ),
        ],
      ),
    );
  }
}
