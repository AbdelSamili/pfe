import 'package:flutter/material.dart';

class AppCustomCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Initialize a new Path
    var path = Path();

    // Move the starting point of the path to the bottom-left corner
    path.lineTo(0, size.height);

    // Define the control points for the first quadratic bezier curve
    final firstCurveStart = Offset(0, size.height - 20); // Start point of the curve
    final firstCurveEnd = Offset(30, size.height - 20); // End point of the curve
    // Add the first quadratic bezier curve to the path
    path.quadraticBezierTo(firstCurveStart.dx, firstCurveStart.dy, firstCurveEnd.dx, firstCurveEnd.dy);

    // Define the control points for the second quadratic bezier curve
    final secondCurveStart = Offset(0, size.height - 20); // Start point of the curve
    final secondCurveEnd = Offset(size.width - 30, size.height - 20); // End point of the curve
    // Add the second quadratic bezier curve to the path
    path.quadraticBezierTo(secondCurveStart.dx, secondCurveStart.dy, secondCurveEnd.dx, secondCurveEnd.dy);

    // Define the control points for the third quadratic bezier curve
    final thirdCurveStart = Offset(size.width, size.height - 20); // Start point of the curve
    final thirdCurveEnd = Offset(size.width, size.height); // End point of the curve
    // Add the third quadratic bezier curve to the path
    path.quadraticBezierTo(thirdCurveStart.dx, thirdCurveStart.dy, thirdCurveEnd.dx, thirdCurveEnd.dy);

    // Draw a straight line to the top-right corner
    path.lineTo(size.width, 0);

    // Close the path to create a closed shape
    path.close();

    // Return the completed path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // Indicate whether the clipper should reclip whenever its parameters change
    return true;
  }
}
