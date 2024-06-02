
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/features/authentification/controller/singup/center/singup_controller_center.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';

class AppTermAndConditionCheckBoxCenter extends StatelessWidget {
  const AppTermAndConditionCheckBoxCenter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SingUpControllerCenter.instance;
    return Row(
      children: [
        SizedBox(width: 24,height: 24,child: Obx(() => Checkbox(value: controller.privacyPolicy.value, onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value))),
        const SizedBox(width: AppSizes.spaceBtwItems,),
        Text.rich(TextSpan(
          children: [
            TextSpan(text: '${AppTexts.iAgreeTo} ',style: Theme.of(context).textTheme.bodySmall),
            TextSpan(text: '${AppTexts.privacyPolicy} ',style: Theme.of(context).textTheme.bodyMedium),
            TextSpan(text:  'and ',style: Theme.of(context).textTheme.bodySmall),
            TextSpan(text: AppTexts.termsOfUse,style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        ),
      ],
    );
  }
}
