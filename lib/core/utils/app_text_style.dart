import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTextStyle {
  static const String titleFontFamily = 'Poppins';
  static const String subtitleFontFamily = 'Inter_Regular';
  static const String subtitleMediumFontFamily = 'Inter_Medium';

  //onboarding
  static const double titleFontSize = 24;
  static const double subtitleFontSize = 14;
  static const double subtitleMediumFontSize = 14;
  static const double loginTitleFontSize = 16;

  static const TextStyle titleStyle = TextStyle(
    fontFamily: titleFontFamily,
    fontSize: titleFontSize,
    fontWeight: FontWeight.bold,
    color: AppColor.titleColor,
  );

  static const TextStyle subTitleStyle = TextStyle(
    fontFamily: subtitleFontFamily,
    fontSize: subtitleFontSize,
    fontWeight: FontWeight.normal,
    color: AppColor.subTitleColor,
  );

  static const TextStyle landingTitleStyle = TextStyle(
    fontFamily: subtitleFontFamily,
    fontSize: subtitleFontSize,
    fontWeight: FontWeight.normal,
    color: AppColor.landingTitleColor,
  );
  static const TextStyle landingLoginStyle = TextStyle(
    fontFamily: subtitleMediumFontFamily,
    fontSize: subtitleMediumFontSize,
    fontWeight: FontWeight.w500,
    color: AppColor.landingAccountColor,
  );

  static const TextStyle loginTitleStyle = TextStyle(
    fontFamily: subtitleFontFamily,
    fontSize: loginTitleFontSize,
    fontWeight: FontWeight.w600,
    color: AppColor.loginTitleColor,
  );

  static const TextStyle loginSubTitleStyle = TextStyle(
    fontFamily: subtitleFontFamily,
    fontSize: subtitleFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.loginSubTitleColor,
  );

  static const TextStyle loginButtonStyle = TextStyle(
    fontFamily: subtitleFontFamily,
    fontSize: subtitleFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.loginButtonColor,
  );
}