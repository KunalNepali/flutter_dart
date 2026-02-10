import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // ✅ ADD THIS

class DesignCourseAppTheme {
  DesignCourseAppTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFFFFFF);
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);

  static final TextTheme textTheme = TextTheme(
    headlineMedium: display1,
    headlineSmall: headline,
    titleLarge: title,
    titleSmall: subtitle,
    bodyLarge: body2,
    bodyMedium: body1,
    bodySmall: caption,
  );

  static final TextStyle display1 = GoogleFonts.workSans(
    // ✅ CHANGED
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static final TextStyle headline = GoogleFonts.workSans(
    // ✅ CHANGED
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static final TextStyle title = GoogleFonts.workSans(
    // ✅ CHANGED
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static final TextStyle subtitle = GoogleFonts.workSans(
    // ✅ CHANGED
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static final TextStyle body2 = GoogleFonts.workSans(
    // ✅ CHANGED
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static final TextStyle body1 = GoogleFonts.workSans(
    // ✅ CHANGED
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static final TextStyle caption = GoogleFonts.workSans(
    // ✅ CHANGED
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText,
  );
}
