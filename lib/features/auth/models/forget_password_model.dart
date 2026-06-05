import 'package:flutter/material.dart';

import '../../../core/utils/app_icon.dart';
import '../../../core/utils/app_text.dart';
import '../presentation/forgetpassword/widget/change_password_step.dart';
import '../presentation/forgetpassword/widget/email_step.dart';
import '../presentation/forgetpassword/widget/otp_step.dart';

class ForgetPasswordModel {
  final String image;
  final String title;
  final String subTitle;
  final Widget widget;

  ForgetPasswordModel({
    required this.image,
    required this.title,
    required this.subTitle,
    required this.widget,
  });
}

List<ForgetPasswordModel> forgetPasswordList = [
  ForgetPasswordModel(
    image: AppIcon.forgetPasswordImage1,
    title: AppText.forgetPasswordTitleBoard1,
    subTitle: AppText.forgetPasswordSubTitleBoard1,
    widget: EmailStep(),
  ),
  ForgetPasswordModel(
    image: AppIcon.forgetPasswordImage2,
    title: AppText.forgetPasswordTitleBoard2,
    subTitle: AppText.forgetPasswordSubTitleBoard2,
    widget: OtpStep(),
  ),
  ForgetPasswordModel(
    image: AppIcon.forgetPasswordImage3,
    title: AppText.forgetPasswordTitleBoard3,
    subTitle: AppText.forgetPasswordSubTitleBoard3,
    widget: ChangePasswordStep(),
  ),
];