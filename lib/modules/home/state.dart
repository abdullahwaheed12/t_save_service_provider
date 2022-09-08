import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class HomeState {
  TextStyle? drawerTitleTextStyle;
  TextStyle? homeHeadingTextStyle;
  TextStyle? homeSubHeadingTextStyle;
  TextStyle? listTileTitleTextStyle;
  TextStyle? listTileSubTitleTextStyle;
  TextStyle? nameTextStyle;
  TextStyle? priceTextStyle;
  TextStyle? otpTextStyle;
  HomeState() {
    ///Initialize variables
    drawerTitleTextStyle = const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: Colors.white);
    homeHeadingTextStyle = const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w800,
        fontSize: 34,
        color: customTextColor);
    homeSubHeadingTextStyle = const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        fontSize: 17,
        color: customThemeColor);
    listTileTitleTextStyle = const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: customTextColor);
    listTileSubTitleTextStyle = const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        fontSize: 13,
        color: customTextColor);
    nameTextStyle = const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: customTextColor);
    priceTextStyle = TextStyle(
      fontFamily: 'Poppins',
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
    otpTextStyle = const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: customTextColor);
  }
}
