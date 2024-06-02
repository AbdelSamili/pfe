import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/bindings/general_bindings.dart';
import 'package:pfe_1/features/authentification/view/onboarding/onboarding_view.dart';
import 'package:pfe_1/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme : AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: GeneralBindings(),
      home: const OnBoardingView(),
     
    );
  }
}
