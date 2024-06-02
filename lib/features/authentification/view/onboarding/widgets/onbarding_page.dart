import 'package:flutter/material.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:pfe_1/utils/helper/helper_function.dart';
class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key, required this.img, required this.title, required this.subTitle,
  });

  final String img,title,subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.defaultSpace),
      child: Column(
        children: [
          Image(
            width: AppHelperFunctions.screenWidth() * 0.8,
            height: AppHelperFunctions.screenHeight() * 0.6,
            image: AssetImage(img),
          ),
          const SizedBox(height: AppSizes.spaceBtwItems,),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceBtwItems,),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}