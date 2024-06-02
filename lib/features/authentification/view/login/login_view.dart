import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/common/styles/spacing_style.dart';
import 'package:pfe_1/common/widgets/login_signup/form_devider.dart';
import 'package:pfe_1/common/widgets/login_signup/social_button.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';

import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            /// logo, title ,subtitle
            children: [
              const LoginHeader(),

              const LoginForm(),
              //Divider
              FormDivider(dividerText: AppTexts.orSignInWith.capitalize!),
              const SizedBox(height: AppSizes.spaceBtwSections,),
              //Footer
              const SocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}