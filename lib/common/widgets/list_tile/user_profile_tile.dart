import 'package:flutter/material.dart';
import 'package:pfe_1/utils/constants/colors.dart';

class AppSettingsMenuTile extends StatelessWidget {
  const AppSettingsMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon; // Property: Icon data for the leading icon
  final String title; // Property: Title text
  final String subTitle; // Property: Subtitle text
  final Widget? trailing;// Property: Widget to be displayed at the end of the tile
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: AppColors.primary), // Property: Leading icon
      title: Text(title, style: Theme.of(context).textTheme.titleMedium), // Property: Title text
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.titleSmall), // Property: Subtitle text
      trailing: trailing, // Property: Widget to be displayed at the end of the tile
      onTap: onTap,
    );
  }
}
