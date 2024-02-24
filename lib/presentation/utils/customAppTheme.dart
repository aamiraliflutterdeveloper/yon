import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppTheme{
  Color backgroundColor = const Color(0xffffffff);
  Color primaryColor = const Color(0xff03AA7F);
  Color lightGreenColor = const Color(0xffdeffe3);
  Color blackColor = const Color(0xff000000);
  Color secondaryColor = const Color(0xFFFF9800);
  Color redColor = const Color(0xfffe2e2e);
  Color greyColor = const Color(0xffa3a8b6);
  Color darkGreyColor = const Color(0xff555555);
  Color lightGreyColor = const Color(0xfff9f9fd);

  TextStyle headingText = GoogleFonts.inter(
    textStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 24
    ),
  );

  TextStyle normalGreyText = GoogleFonts.inter(
    textStyle: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w400,
        fontSize: 16
    ),
  );

  TextStyle normalText = GoogleFonts.inter(
    textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 14
    ),
  );

  TextStyle boldNormalText = GoogleFonts.inter(
    textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 12
    ),
  );


  TextStyle textFieldHeading = GoogleFonts.inter(
    textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14
    ),
  );

}