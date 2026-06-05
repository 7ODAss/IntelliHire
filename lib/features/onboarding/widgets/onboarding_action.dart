import 'package:flutter/material.dart';

import '../../../core/utils/app_color.dart';
import '../../../core/utils/app_text_style.dart';
import '../model/onboarding_model.dart';
import '../presentation/landing_screen.dart';

class OnboardingAction extends StatelessWidget {
  final int pageIndex;
  final List<OnboardingModel> onboardingList;
  final PageController pageController;

  const OnboardingAction({
    super.key,
    required this.pageIndex,
    required this.onboardingList,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(55.0),
      child: ElevatedButton(
        onPressed: () {
          if (pageIndex < onboardingList.length - 1) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LandingScreen()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColor.logicColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: AppColor.logicColor,
                radius: 20,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                pageIndex == onboardingList.length - 1 ? 'Get Started' : 'Next',
                style: AppTextStyle.subTitleStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
