import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey[500],
  );
}
