import 'package:flutter/material.dart';
import 'package:pfe_1/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:pfe_1/common/widgets/custom_shapes/cuvers_edge/cureved_edge_widget.dart';
import 'package:pfe_1/utils/constants/colors.dart';

class AppPrimaryHeaderContainer extends StatelessWidget {
  const AppPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCurvedEdgeWidget(
      child: Container(
        color: AppColors.primary, // Property: Color of the container

        child: Stack(
          children: [
            Positioned(top: -150,right: -250,child: AppCircularContainer(backgroundColor: AppColors.textWhite.withOpacity(0.1),)),
            Positioned(top: 100,right: -300,child: AppCircularContainer(backgroundColor: AppColors.textWhite.withOpacity(0.1),)),
            child,
            ], // Stack children
          ),
        ),
    );
  }
}


