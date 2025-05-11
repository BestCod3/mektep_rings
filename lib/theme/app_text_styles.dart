import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyle {
  static TextStyle size16W600 = GoogleFonts.lora(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static TextStyle size16W600red = GoogleFonts.lora(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.red,
  );
  static TextStyle size16W600white = GoogleFonts.lora(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle size40 = GoogleFonts.lora(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );
  static TextStyle size16bold = GoogleFonts.lora(
    color: Colors.pink,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  static TextStyle size20bold = GoogleFonts.lora(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.pink,
  );
  static TextStyle size20boldgreen = GoogleFonts.lora(
    fontWeight: FontWeight.bold,
    color: Colors.green,
    fontSize: 20,
  );
}
