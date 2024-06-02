import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/common/widgets/image/circulat_image.dart';
import 'package:pfe_1/features/client/controller/client_controller.dart';
import 'package:pfe_1/utils/constants/colors.dart';
import 'package:pfe_1/utils/constants/images_strings.dart';


class AppClientProfileTile extends StatelessWidget {
  const AppClientProfileTile({
    super.key, required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = ClientController.instance;
    return Obx(
      () => ListTile(
        leading: Obx((){
          final networkImage = controller.client.value.profileImage;
          final image = networkImage.isNotEmpty ? networkImage : AppImages.userImage;
          return AppCircularImage(image: image,isNetworkImage: networkImage.isNotEmpty,);
        }),
        title: Text(controller.client.value.fullName, style: Theme.of(context).textTheme.titleLarge!),
        subtitle: Text(controller.client.value.email, style: Theme.of(context).textTheme.bodyMedium!),
        trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit, color: AppColors.white)),
      ),
    );
  }
}