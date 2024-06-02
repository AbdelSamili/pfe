import 'package:flutter/material.dart';
import 'package:pfe_1/features/authentification/view/signup/widgets/center/singup_form_center.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';
import 'package:pfe_1/utils/helper/helper_function.dart';

class SingUpScreenCenter extends StatelessWidget {
  const SingUpScreenCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              // Title
              Text(AppTexts.signupTitle,style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: AppSizes.spaceBtwSections,),
              //Form
              const SingUpFormCenter(),
            ],
          ),
        ),
      ),
    );
  }
}