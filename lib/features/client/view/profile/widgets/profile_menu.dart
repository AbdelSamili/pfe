import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/utils/constants/sizes.dart';

class AppProfileMenu extends StatelessWidget {
  // Defining properties of the class
  const AppProfileMenu({
    super.key, // Key is used for widget identification and manipulation
    required this.onPressed, // Function to execute when tapped
    required this.title, // Title text displayed
    required this.value, // Value text displayed
    this.icon = Iconsax.arrow_right_34, // Icon displayed (default is arrow right)
  });

  final IconData icon; // Icon data for the icon widget
  final VoidCallback onPressed; // Callback function for tap event
  final String title, value; // Title and value strings

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Executing onPressed function when tapped
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceBtwItems /1.5), // Padding around the content
        child: Row( // Row layout to display title, value, and icon
          children: [
            Expanded( // Expanded widget to occupy available space (3/8)
              flex: 3,
              child: Text( // Displaying title text
                title,
                style: Theme.of(context).textTheme.bodyLarge, // Text style
                overflow: TextOverflow.ellipsis, // Overflow handling
              ),
            ),
            Expanded( // Expanded widget to occupy available space (5/8)
              flex: 5,
              child: Text( // Displaying value text
                value,
                style: Theme.of(context).textTheme.bodyMedium, // Text style
                overflow: TextOverflow.ellipsis, // Overflow handling
              ),
            ),
            Expanded( // Expanded widget to occupy available space (1/8)
              child: Icon( // Displaying icon
                icon,
                size: 18, // Size of the icon
              ),
            ),
          ], // Children widgets of the Row
        ),
      ),
    );
  }
}
