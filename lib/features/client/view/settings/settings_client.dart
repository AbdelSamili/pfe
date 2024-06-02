import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/common/widgets/appbar/appbar.dart';
import 'package:pfe_1/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:pfe_1/common/widgets/image/circulat_image.dart';
import 'package:pfe_1/common/widgets/list_tile/user_profile_tile.dart';
import 'package:pfe_1/features/centre/view/settings/widgets/section_heading.dart';
import 'package:pfe_1/features/client/controller/client_controller.dart';
import 'package:pfe_1/features/client/view/profile/profile_client.dart';
import 'package:pfe_1/utils/constants/colors.dart';
import 'package:pfe_1/utils/constants/images_strings.dart';
import 'package:pfe_1/utils/constants/sizes.dart';

class AppSettingsClientScreen extends StatelessWidget {
  const AppSettingsClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClientController());
    return RefreshIndicator(
      onRefresh: () async {
        // Add the logic here to reload or refresh the user data
        await controller.fetchUserRecord(); // Example method to fetch updated user data
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppPrimaryHeaderContainer(
                child: Column(
                  children: [
                    CAppBar(title: Text('Account', style: Theme.of(context).textTheme.headlineMedium,),),

                    /// User Profile Card
                    Obx(
                          () => ListTile(
                        leading: Obx((){
                          final networkImage = controller.client.value.profileImage;
                          final image = networkImage.isNotEmpty ? networkImage : AppImages.userImage;
                          return AppCircularImage(image: image,isNetworkImage: networkImage.isNotEmpty,);
                        }),
                            title: Text(controller.client.value.fullName, style: Theme.of(context).textTheme.titleLarge!),
                            subtitle: Text(controller.client.value.email, style: Theme.of(context).textTheme.bodyMedium!),
                            trailing: IconButton(onPressed: () => Get.to(() => const AppProfileScreenClient()), icon: const Icon(Iconsax.edit, color: AppColors.white)))),

                    const SizedBox(height: AppSizes.spaceBtwSections),
                  ],
                ),
              ),

              Padding(
                  padding: const EdgeInsets.all(AppSizes.defaultSpace),
                  child: Column(
                    children: [
                      const AppSectionHeading(title: "Account Settings",showActionButton: false,),
                      const SizedBox(height: AppSizes.spaceBtwItems,),
                      AppSettingsMenuTile(
                          icon: Iconsax.safe_home,
                          title: "My Addresse",
                          subTitle: "Safi 20 cue de almane",
                          onTap: (){},
                      ),
                      const SizedBox(height: AppSizes.spaceBtwItems,),
                      AppSettingsMenuTile(
                        icon: Iconsax.bank,
                        title: 'Bank Account',
                        subTitle: 'Withdraw balance to registered bank account',
                        onTap: (){},
                      ),
                      const SizedBox(height: AppSizes.spaceBtwItems,),
                      AppSettingsMenuTile(
                        icon: Iconsax.security_card,
                        title: 'Account Privacy',
                        subTitle: 'Manage data usage and connected accounts',
                        onTap: (){},
                      ),

                      const SizedBox(height: AppSizes.spaceBtwSections),
                      const AppSectionHeading(title: 'App Settings', showActionButton: false),
                      const SizedBox(height: AppSizes.spaceBtwItems),
                      const AppSettingsMenuTile(
                        icon: Iconsax.document_upload,
                        title: 'Load Data',
                        subTitle: 'Upload Data to your Cloud Firebase',
                      ),
                      AppSettingsMenuTile(
                        icon: Iconsax.location,
                        title: 'Geolocation',
                        subTitle: 'Set recommendation based on location',
                        trailing: Switch(value: true, onChanged: (value) {}),
                      ),

                      const SizedBox(height: AppSizes.spaceBtwSections),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => controller.logOutAccountWarningPopup(),
                          child: const Text('Logout'),
                        ),
                      ), // SizedBox
                      const SizedBox(height: AppSizes.spaceBtwSections * 2.5),

                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

