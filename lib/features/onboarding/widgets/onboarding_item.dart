import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/features/onboarding/model/onboarding_model.dart';

import '../../../core/utils/app_text_style.dart';

class OnboardingItem extends StatelessWidget {
  final int pageIndex;
  final List<OnboardingModel> onboardingList;
  const OnboardingItem({super.key,required this.pageIndex, required this.onboardingList});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        SvgPicture.asset(onboardingList[pageIndex].image),
        Padding(
          padding: const EdgeInsets.only(top: 56, bottom: 16),
          child: Text(
            onboardingList[pageIndex].title,
            style: AppTextStyle.titleStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            onboardingList[pageIndex].subTitle,
            style: AppTextStyle.subTitleStyle,
          ),
        ),
      ],
    );
  }
}
