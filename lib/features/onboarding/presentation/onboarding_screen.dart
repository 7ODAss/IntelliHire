import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/utils/app_color.dart';
import '../model/onboarding_model.dart';
import '../widgets/onboarding_action.dart';
import '../widgets/onboarding_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int pageIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 300, bottom: 48),
                child: TextButton(
                  onPressed: () {
                    if (pageIndex < onboardingList.length - 1) {
                      _pageController.animateToPage(
                        onboardingList.length - 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text('Skip', style: AppTextStyle.subTitleStyle),
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  pageIndex = index;
                });
              },
              itemCount: onboardingList.length,
              itemBuilder: (context, index) => OnboardingItem(
                pageIndex: pageIndex,
                onboardingList: onboardingList,
              ),
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: onboardingList.length,
            axisDirection: Axis.horizontal,
            effect: ExpandingDotsEffect(
              spacing: 8.0,
              dotWidth: 10,
              dotHeight: 10,
              radius: 56,
              paintStyle: PaintingStyle.fill,
              strokeWidth: 1.5,
              activeDotColor: AppColor.logicColor,
              dotColor: AppColor.notActiveIndicatorColor,
            ),
            onDotClicked: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            },
          ),
          OnboardingAction(
            pageIndex: pageIndex,
            onboardingList: onboardingList,
            pageController: _pageController,
          ),
        ],
      ),
    );
  }
}
