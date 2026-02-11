import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTextStyle {
  static const String poppinsBold = 'Poppins_Bold';
  static const String poppinsSemiBold = 'Poppins_Semi_Bold';
  static const String poppinsRegular = 'Poppins_Regular';
  static const String interRegular = 'Inter_Regular';
  static const String interMedium = 'Inter_Medium';
  static const String interSemiBold = 'Inter_Semi_Bold';

  //onboarding
  static const double titleFontSize = 24;
  static const double subtitleFontSize = 14;
  static const double subtitleMediumFontSize = 14;
  static const double loginTitleFontSize = 16;
  static const double signUpTitleFontSize = 20;
  static const double signUpTitleInformationCompanyFontSize = 20;
  static const double searchTitleCompanyFontSize = 18;

  static const TextStyle titleStyle = TextStyle(
    fontFamily: poppinsBold,
    fontSize: titleFontSize,
    fontWeight: FontWeight.bold,
    color: AppColor.titleColor,
  );

  static const TextStyle subTitleStyle = TextStyle(
    fontFamily: interRegular,
    fontSize: subtitleFontSize,
    fontWeight: FontWeight.normal,
    color: AppColor.subTitleColor,
  );

  static const TextStyle landingTitleStyle = TextStyle(
    fontFamily: interRegular,
    fontSize: subtitleFontSize,
    fontWeight: FontWeight.normal,
    color: AppColor.landingTitleColor,
  );
  static const TextStyle landingLoginStyle = TextStyle(
    fontFamily: interMedium,
    fontSize: subtitleMediumFontSize,
    fontWeight: FontWeight.w500,
    color: AppColor.landingAccountColor,
  );

  static const TextStyle loginTitleStyle = TextStyle(
    fontFamily: interRegular,
    fontSize: loginTitleFontSize,
    fontWeight: FontWeight.w600,
    color: AppColor.loginTitleColor,
  );

  static const TextStyle loginSubTitleStyle = TextStyle(
    fontFamily: interRegular,
    fontSize: subtitleFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.loginSubTitleColor,
  );

  static const TextStyle loginButtonStyle = TextStyle(
    fontFamily: interRegular,
    fontSize: subtitleFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.loginButtonColor,
  );

  static const TextStyle signUpTitleStyle = TextStyle(
    fontFamily: poppinsRegular,
    fontSize: signUpTitleFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.signUpTitleColor,
  );

  static const TextStyle fieldTitleStyle = TextStyle(
    fontFamily: interRegular,
    fontSize: subtitleMediumFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.signUpFieldColor,
  );

  static const TextStyle signUpConditionStyle = TextStyle(
    fontFamily: interRegular,
    fontSize: subtitleMediumFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.signUpConditionColor1,
  );

  static const TextStyle signUpTitleInformationCompanyStyle = TextStyle(
    fontFamily: interSemiBold,
    fontSize: signUpTitleInformationCompanyFontSize,
    color: AppColor.signUpTitleInformationCompanyColor,
  );

  static const TextStyle signUpDropDownCompanyStyle = TextStyle(
    fontFamily: interRegular,
    fontSize: loginTitleFontSize,
    color: AppColor.signUpFieldColor,
  );

  static const TextStyle hintTextStyle = TextStyle(
    fontFamily: interRegular,
    fontSize: loginTitleFontSize,
    color: AppColor.hintColor,
  );

  static const TextStyle searchTitleStyle = TextStyle(
    fontFamily: poppinsSemiBold,
    fontSize: searchTitleCompanyFontSize,
    color: AppColor.searchTitleColor,
  );
}