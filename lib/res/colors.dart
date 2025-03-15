import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class AppColors {
  static const Color buttonColor = Color.fromARGB(255, 249, 190, 50); //ffb400
  static const GFTypographyType deviceOnMapSligePanelHeading =
      GFTypographyType.typo5;
  static BorderRadius popupmenuborder = BorderRadius.circular(30);
  static RoundedRectangleBorder cardBorderShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));
  static TextStyle appTitleTextStyle = const TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );
  static TextStyle settingPageButtonTextStyle = const TextStyle(
      fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold);
  static TextStyle settingTextstyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
  static BorderRadius StatusDshboardBarborderRadius =
      BorderRadius.circular(8.0);
  static const BoxDecoration appScreenBackgroundImage = BoxDecoration(
    image: DecorationImage(
        image: AssetImage("assets/images/login-page-background-3.jpg"),
        fit: BoxFit.fill),
  );
  static const String errorMessage =
      'trying to load data.Please check internet connection';
  static const String logoPath = 'assets/images/splashsceen.png';
}
