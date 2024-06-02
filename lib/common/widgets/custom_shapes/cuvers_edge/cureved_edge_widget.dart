import 'package:flutter/material.dart';
import 'package:pfe_1/common/widgets/custom_shapes/cuvers_edge/cuvred_edges.dart';


class AppCurvedEdgeWidget extends StatelessWidget {
  const AppCurvedEdgeWidget({
    super.key, this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AppCustomCurvedEdges(),
      child: child,
    );
  }
}