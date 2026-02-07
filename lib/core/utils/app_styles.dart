import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';

abstract class AppStyles {
  static const textstyle12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.inter,
    color: AppColor.grey,
  );

  static const textstyle14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.inter,
    color: Color(0xff0F172A),
  );

  static const textstyle20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.poppins,
    color: AppColor.white,
  );

}
