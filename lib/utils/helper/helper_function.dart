import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppHelperFunctions{
  static void showSnackBar(String message) {
    // Shows a snackbar with the provided message
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message) {
    // Shows an alert dialog with the provided title and message
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Handles the "OK" button press
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    // Navigates to the provided screen using MaterialPageRoute
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    // Truncates the given text if its length exceeds maxLength
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)} ... ';
    }
  }

  static bool isDarkMode(BuildContext context) {
    // Checks if the current theme is dark mode
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    // Retrieves the size of the screen
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    // Returns the height of the screen
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    // Returns the width of the screen
    return MediaQuery.of(Get.context!).size.width;
  }

  // static String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}) {
  //   // Formats the given date according to the specified format
  //   return DateFormat(format).format(date);
  // }

  static List<T> removeDuplicates<T>(List<T> list) {
    // Removes duplicates from the given list
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
      return wrappedList;
  }



}