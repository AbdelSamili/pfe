import 'package:flutter/material.dart';

class AppIconButtonsTheme {
  // Private constructor to prevent instantiation
  AppIconButtonsTheme._();

  // Define a static property for light icon button theme
  static final lightIconButtonsTheme = IconButtonThemeData(
    // Set the default style for icon buttons in light mode
    style: ButtonStyle(
      // Set the default foreground color for the icon button
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      // You can add more styles here as needed
    ),
  );

  // Define a static property for dark icon button theme
  static final darkIconButtonsTheme = IconButtonThemeData(
    // Set the default style for icon buttons in dark mode
    style: ButtonStyle(
      // Set the default foreground color for the icon button
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      // You can add more styles here as needed
    ),
  );
}
