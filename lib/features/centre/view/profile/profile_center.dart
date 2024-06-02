import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pfe_1/common/widgets/appbar/appbar.dart';
import 'package:pfe_1/common/widgets/image/circulat_image.dart';
import 'package:pfe_1/features/centre/controller/center_controller.dart';
import 'package:pfe_1/features/centre/view/profile/change_name_center.dart';
import 'package:pfe_1/features/centre/view/profile/widgets/profile_menu.dart';
import 'package:pfe_1/features/centre/view/settings/widgets/section_heading.dart';
import 'package:pfe_1/utils/constants/sizes.dart';

class AppProfileScreenCenter extends StatelessWidget {
  const AppProfileScreenCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CenterController.instance;
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController creationDateController = TextEditingController();

    return Scaffold(
      appBar: const CAppBar(showBackArrow: true, title: Text('Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              // Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.center.value.profileImage;
                      final image = networkImage.isNotEmpty ? networkImage : 'assets/images/users-icon.jpg';
                      return AppCircularImage(image: image, isNetworkImage: networkImage.isNotEmpty);
                    }),
                    TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),

              // Heading Profile Info
              const SizedBox(height: AppSizes.spaceBtwItems),
              const AppSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: AppSizes.spaceBtwItems),
              AppProfileMenu(title: 'Center Name', value: controller.center.value.centerName, onPressed: () => Get.to(() => const ChangeNameCenter())),
              AppProfileMenu(title: 'Matricule', value: controller.center.value.matricule, onPressed: () {}),
              const SizedBox(height: AppSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: AppSizes.spaceBtwItems),

              // Heading Personal Info
              const AppSectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height: AppSizes.spaceBtwItems),
              AppProfileMenu(title: 'Center ID', value: controller.center.value.id, icon: Iconsax.copy, onPressed: () {}),
              AppProfileMenu(title: 'E-mail', value: controller.center.value.email, onPressed: () {}),
              AppProfileMenu(title: 'Phone Number', value: controller.center.value.phoneNumber, onPressed: () {}),
              const Divider(),
              const SizedBox(height: AppSizes.spaceBtwItems),

              // Description
              const AppSectionHeading(title: 'Description', showActionButton: false),
              const SizedBox(height: AppSizes.spaceBtwItems),
              Obx(() {
                descriptionController.text = controller.center.value.description;
                return TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                );
              }),
              const SizedBox(height: AppSizes.spaceBtwSections),
              ElevatedButton(
                onPressed: () {
                  controller.updateCenterDescription(descriptionController.text);
                },
                child: const Text('Update Description'),
              ),
              const SizedBox(height: AppSizes.spaceBtwSections),

              // Creation Date
              const AppSectionHeading(title: 'Creation Date', showActionButton: false),
              const SizedBox(height: AppSizes.spaceBtwItems),
              Obx(() {
                creationDateController.text = controller.center.value.creationDate;
                return TextFormField(
                  controller: creationDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Creation Date',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(controller.center.value.creationDate),
                      firstDate: DateTime(1980),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      creationDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      controller.updateCenterCreationDate(creationDateController.text);
                    }
                  },
                );
              }),
              const SizedBox(height: AppSizes.spaceBtwSections),

              // Logout and Delete Account buttons
              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text('Close Account', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
