import 'package:flutter/material.dart';

const Color customBlack = Color(0xff333333);
const Color customWhite = Color(0xfff1f1f1);
const Color customGray = Color(0xffcccccc);
const Color customGreen = Color(0xFF66BB6A);

final ThemeData appTheme = ThemeData(
  appBarTheme: const AppBarTheme(color: customBlack),
  brightness: Brightness.light,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: customWhite,
    modalBackgroundColor: customWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
    ),
  ),
  buttonTheme: const ButtonThemeData(buttonColor: customBlack),
  primaryColor: customBlack,
  fontFamily: 'Roboto',
  textTheme: const TextTheme(),
  iconTheme: const IconThemeData(size: 24, color: customBlack),
  indicatorColor: customBlack,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    },
  ),
);
