import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  AppTextTheme._();


  static TextTheme lightTextTheme = TextTheme(
    labelMedium: GoogleFonts.gabriela(
      color: Colors.black,
    ),
    displayLarge: GoogleFonts.aboreto(
      color: Colors.black,
      fontSize: 33.0,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.montserrat(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.montserrat(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.montserrat(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    titleLarge: GoogleFonts.aBeeZee(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: GoogleFonts.k2d(
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.k2d(
      color: Colors.black,
    ),
    bodySmall: GoogleFonts.k2d(
      color: Colors.black,
    ),

    titleSmall: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 10.0
    ),
  );
  static TextTheme darkTextTheme = TextTheme(
    labelMedium: GoogleFonts.gabriela(
      color: Colors.white,
    ),
    displayLarge: GoogleFonts.aboreto(
      color: Colors.white,
      fontSize: 33.0,
      fontWeight: FontWeight.bold,

    ),
    displayMedium: GoogleFonts.k2d(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.montserrat(
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.montserrat(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    titleLarge: GoogleFonts.aBeeZee(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: GoogleFonts.k2d(
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.k2d(
      color: Colors.white,
    ),
    bodySmall: GoogleFonts.k2d(
      color: Colors.white,
    ),
    titleSmall: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 10.0,
    ),
  );
}