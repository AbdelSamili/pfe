import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/common/widgets/appbar/appbar.dart';
import 'package:pfe_1/common/widgets/image/circulat_image.dart';
import 'package:pfe_1/features/centre/view/profile/widgets/profile_menu.dart';
import 'package:pfe_1/features/centre/view/settings/widgets/section_heading.dart';
import 'package:pfe_1/features/client/controller/client_controller.dart';
import 'package:pfe_1/features/client/view/profile/change_name.dart';
import 'package:pfe_1/utils/constants/images_strings.dart';
import 'package:pfe_1/utils/constants/sizes.dart';

class AppProfileScreenClient extends StatelessWidget {
  const AppProfileScreenClient({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ClientController.instance;
    return Scaffold(
      appBar: const CAppBar(showBackArrow: true, title: Text('Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              /// Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx((){
                      final networkImage = controller.client.value.profileImage;
                      final image = networkImage.isNotEmpty ? networkImage : AppImages.userImage;
                      return AppCircularImage(image: image,isNetworkImage: networkImage.isNotEmpty,);
                    }),
                    TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),

              /// Heading Profile Info
              const SizedBox(height: AppSizes.spaceBtwItems),
              const AppSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: AppSizes.spaceBtwItems),
              AppProfileMenu(title: 'Name', value: controller.client.value.fullName, onPressed: () => Get.to(() => const ChangeNameClient())),
              AppProfileMenu(title: 'Username', value: controller.client.value.userName, onPressed: () {}),
              const SizedBox(height: AppSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: AppSizes.spaceBtwItems),

              /// Heading Personal Info
              const AppSectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height: AppSizes.spaceBtwItems),
              AppProfileMenu(title: 'User ID', value: controller.client.value.id, icon: Iconsax.copy, onPressed: () {}),
              AppProfileMenu(title: 'E-mail', value: controller.client.value.email, onPressed: () {}),
              AppProfileMenu(title: 'Phone Number', value: controller.client.value.phoneNumber, onPressed: () {}),
              const Divider(),
              const SizedBox(height: AppSizes.spaceBtwItems),

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
