import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/features/onboarding/model/onboarding_model.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../models/forget_password_model.dart';

class ForgetPasswordItem extends StatelessWidget {
  final int pageIndex;
  final List<ForgetPasswordModel> forgetPasswordList;
  const ForgetPasswordItem({super.key,required this.pageIndex, required this.forgetPasswordList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SvgPicture.asset(forgetPasswordList[pageIndex].image),
          Padding(
            padding: const EdgeInsets.only(top: 56, bottom: 16),
            child: Text(
              forgetPasswordList[pageIndex].title,
              style: AppTextStyle.titleStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              forgetPasswordList[pageIndex].subTitle,
              style: AppTextStyle.subTitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16,),
          forgetPasswordList[pageIndex].widget,
        ],
      ),
    );
  }
}
