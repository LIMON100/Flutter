import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData ? _mediaQueryData;
  static double ? screenWidth;
  static double ? screenHeight;
  static double ? defaultSize;
  static Orientation ? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double? screenHeight = SizeConfig.screenHeight;
  // If screenHeight is null, return a default value or handle it accordingly
  return screenHeight != null ? (inputHeight / 896.0) * screenHeight : 0.0;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double? screenWidth = SizeConfig.screenWidth;
  // If screenWidth is null, return a default value or handle it accordingly
  return screenWidth != null ? (inputWidth / 414.0) * screenWidth : 0.0;
}

// For add free space vertically
class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing({
    required Key key,
    this.of = 25,
  }) : super(key: key);

  final double of;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(of),
    );
  }
}
