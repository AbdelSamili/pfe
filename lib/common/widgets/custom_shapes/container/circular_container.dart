import 'package:flutter/material.dart';
import 'package:pfe_1/utils/constants/colors.dart';

class AppCircularContainer extends StatelessWidget {
  const AppCircularContainer({
    super.key,
    this.child,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.backgroundColor = AppColors.white,
  });

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Property: Width of the container
      height: height, // Property: Height of the container
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius), // Property: Border radius to make the container round
        color: backgroundColor, // Property: Color of the container with opacity
      ),
      child: child,
    );
  }
} // HomeScreen
