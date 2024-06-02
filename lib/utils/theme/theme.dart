import 'package:flutter/material.dart';
import 'package:pfe_1/utils/theme/widget_theme/appBar_theme.dart';
import 'package:pfe_1/utils/theme/widget_theme/bottom_sheet_theme.dart';
import 'package:pfe_1/utils/theme/widget_theme/elevatedButton_theme.dart';
import 'package:pfe_1/utils/theme/widget_theme/icon_button_theme.dart';
import 'package:pfe_1/utils/theme/widget_theme/icon_theme.dart';
import 'package:pfe_1/utils/theme/widget_theme/outlined_button_theme.dart';
import 'package:pfe_1/utils/theme/widget_theme/text_feild_theme.dart';
import 'package:pfe_1/utils/theme/widget_theme/text_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    textTheme: AppTextTheme.lightTextTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: AppbarTheme.lightAppBarTheme,
    bottomSheetTheme: AppBottomSheetTheme.lightBottomSheetTheme,
    inputDecorationTheme: AppTextFieldTheme.lightInputDecorationTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.lightOutlinedButtonTheme,
    iconButtonTheme: AppIconButtonsTheme.lightIconButtonsTheme,
    iconTheme: AppIconsTheme.lightIconsTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    textTheme: AppTextTheme.darkTextTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: AppbarTheme.darkAppBarTheme,
    bottomSheetTheme: AppBottomSheetTheme.darkBottomSheetTheme,
    inputDecorationTheme: AppTextFieldTheme.darkInputDecorationTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.darkOutlinedButtonTheme,
    iconButtonTheme: AppIconButtonsTheme.darkIconButtonsTheme,
    iconTheme: AppIconsTheme.darkIconsTheme,
  );
}