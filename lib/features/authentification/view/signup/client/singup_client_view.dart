import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/common/widgets/login_signup/form_devider.dart';
import 'package:pfe_1/common/widgets/login_signup/social_button.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';
import 'package:pfe_1/utils/helper/helper_function.dart';
import '../widgets/client/singup_form_client.dart';

class SingUpScreenClient extends StatelessWidget {
  const SingUpScreenClient({super.key});

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
              const AppSingUpFormClient(),
              const SizedBox(height: AppSizes.spaceBtwSections,),
              //Divider
              FormDivider(dividerText: AppTexts.orSignUpWith.capitalize!),
              const SizedBox(height: AppSizes.spaceBtwSections,),

              // Social Button
              const SocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}