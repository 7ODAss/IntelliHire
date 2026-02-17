import 'package:flutter/material.dart';
import 'app_color.dart';
import 'app_font.dart';

class AppTextStyle {
  static const TextStyle titleStyle = TextStyle(
    fontFamily: AppFont.poppinsBold,
    fontSize: AppFont.titleFontSize,
    fontWeight: FontWeight.bold,
    color: AppColor.titleColor,
  );

  static const TextStyle subTitleStyle = TextStyle(
    fontFamily: AppFont.interRegular,
    fontSize: AppFont.subtitleFontSize,
    fontWeight: FontWeight.normal,
    color: AppColor.subTitleColor,
  );

  static const TextStyle landingTitleStyle = TextStyle(
    fontFamily: AppFont.interRegular,
    fontSize: AppFont.subtitleFontSize,
    fontWeight: FontWeight.normal,
    color: AppColor.landingTitleColor,
  );
  static const TextStyle landingLoginStyle = TextStyle(
    fontFamily: AppFont.interMedium,
    fontSize: AppFont.subtitleMediumFontSize,
    fontWeight: FontWeight.w500,
    color: AppColor.landingAccountColor,
  );

  static const TextStyle loginTitleStyle = TextStyle(
    fontFamily: AppFont.interRegular,
    fontSize: AppFont.loginTitleFontSize,
    fontWeight: FontWeight.w600,
    color: AppColor.loginTitleColor,
  );

  static const TextStyle loginSubTitleStyle = TextStyle(
    fontFamily: AppFont.interRegular,
    fontSize: AppFont.subtitleFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.loginSubTitleColor,
  );

  static const TextStyle loginButtonStyle = TextStyle(
    fontFamily: AppFont.interRegular,
    fontSize: AppFont.subtitleFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.loginButtonColor,
  );

  static const TextStyle signUpTitleStyle = TextStyle(
    fontFamily: AppFont.poppinsRegular,
    fontSize: AppFont.signUpTitleFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.signUpTitleColor,
  );

  static const TextStyle fieldTitleStyle = TextStyle(
    fontFamily: AppFont.interRegular,
    fontSize: AppFont.subtitleMediumFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.signUpFieldColor,
  );

  static const TextStyle signUpConditionStyle = TextStyle(
    fontFamily: AppFont.interRegular,
    fontSize: AppFont.subtitleMediumFontSize,
    fontWeight: FontWeight.w400,
    color: AppColor.signUpConditionColor1,
  );

  static const TextStyle signUpTitleInformationCompanyStyle = TextStyle(
    fontFamily: AppFont.interSemiBold,
    fontSize: AppFont.signUpTitleInformationCompanyFontSize,
    color: AppColor.signUpTitleInformationCompanyColor,
  );

  static const TextStyle signUpDropDownCompanyStyle = TextStyle(
    fontFamily: AppFont.interRegular,
    fontSize: AppFont.loginTitleFontSize,
    color: AppColor.signUpFieldColor,
  );

  static const TextStyle hintTextStyle = TextStyle(
    fontFamily: AppFont.interRegular,
    fontSize: AppFont.loginTitleFontSize,
    color: AppColor.hintColor,
  );

  static const TextStyle searchTitleStyle = TextStyle(
    fontFamily: AppFont.poppinsSemiBold,
    fontSize: AppFont.searchTitleCompanyFontSize,
    color: AppColor.searchTitleColor,
  );

  //omar
  static const textstyle12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.interRegular,
    color: AppColor.grey,
  );

  static const textstyle14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.interRegular,
    color: Color(0xff0F172A),
  );

  static const textstyle20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.poppinsRegular,
    color: AppColor.white,
  );
}
