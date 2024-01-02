import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double screenWidth = _mediaQueryData!.size.width;
  static double screenHeight = _mediaQueryData!.size.height;
  static double blockSizeHorizontalv = screenWidth / 100;
  static double blockSizeVertical = screenHeight / 100;

  SizeConfig(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
  }
}
