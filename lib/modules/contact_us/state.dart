import 'package:flutter/material.dart';
import 'package:t_save_sp/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpState {
  TextStyle? appBarTextStyle;
  TextStyle? contentTextStyle;
  HelpState() {
    ///Initialize variables
    appBarTextStyle = GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: customTextColor);
    contentTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w700, color: customTextColor);
  }
}
