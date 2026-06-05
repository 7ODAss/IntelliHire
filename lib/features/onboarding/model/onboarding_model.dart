import '../../../core/utils/app_icon.dart';
import '../../../core/utils/app_text.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String subTitle;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.subTitle,

  });
}

List<OnboardingModel> onboardingList = [
  OnboardingModel(
    image: AppIcon.onBoardingImage1,
    title: AppText.titleBoard1,
    subTitle: AppText.subTitleBoard1,
  ),
  OnboardingModel(
    image: AppIcon.onBoardingImage2,
    title: AppText.titleBoard2,
    subTitle: AppText.subTitleBoard2,
  ),
  OnboardingModel(
    image: AppIcon.onBoardingImage3,
    title: AppText.titleBoard3,
    subTitle: AppText.subTitleBoard3,
  ),
];
