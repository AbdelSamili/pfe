import 'package:flutter/material.dart';
import 'package:pfe_1/features/authentification/view/onboarding/widgets/onbarding_page.dart';
import 'package:pfe_1/features/authentification/view/onboarding/widgets/onboarding_next_button.dart';
import 'package:pfe_1/utils/constants/images_strings.dart';
import 'package:pfe_1/utils/constants/text_strings.dart';



class OnBoardingView extends StatelessWidget {
  
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: const [
               OnBoardingPage(
                img: AppImages.onBoardingImage1,
                title: AppTexts.onBoardingTitle1,
                subTitle: AppTexts.onBoardingSubTitle1,
              ),
            ],
          ),
          
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}