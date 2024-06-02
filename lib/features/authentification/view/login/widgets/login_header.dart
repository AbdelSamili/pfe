import 'package:flutter/material.dart';
import 'package:pfe_1/utils/constants/images_strings.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Image(
          height: 150,
          image: AssetImage(AppImages.logo),
        ),
        Text(AppTexts.loginTitle,style: Theme.of(context).textTheme.headlineMedium,),
        const SizedBox(height: AppSizes.sm),
        Text(AppTexts.loginSubTitle,style: Theme.of(context).textTheme.bodyMedium,),
      ],
    );
  }
}
