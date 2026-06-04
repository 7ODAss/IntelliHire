import 'package:flutter/material.dart';

class ChangeEmailModel {
  final String title;
  final String subTitle;
  final String desc;
  final String fieldTitle;
  final String hintText;
  final IconData? icon;
  final IconData? icon2;
  ChangeEmailModel({
    required this.title,
    required this.subTitle,
    required this.desc,
    required this.fieldTitle,
    required this.hintText,
    required this.icon,
    this.icon2,
  });
}

List<ChangeEmailModel> changeEmailList = [
  ChangeEmailModel(
    title: 'Confirm your identity',
    subTitle: 'Step 1 of 2 — Confirm password',
    desc: 'We need to verify it\'s you before changing sensitive info.',
    fieldTitle: 'Current password',
    hintText: 'Enter current password',
    icon: Icons.lock_outline,
    icon2: Icons.visibility_off,
  ),
  ChangeEmailModel(
    title: 'Enter new email',
    subTitle: 'Step 2 of 2 — New email',
    desc: 'We\'ll send a one-time password (OTP) to confirm it\'s yours.',
    fieldTitle: 'New email address',
    hintText: 'example@mail.com',
    icon: Icons.email_outlined,
  ),
];
