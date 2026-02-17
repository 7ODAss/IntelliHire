import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/candidate_signup_view.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_company.dart';
import '../../../core/utils/app_color.dart';
import '../../../core/utils/app_icon.dart';
import '../../auth/presentation/login/login_screen.dart';
import '../../auth/presentation/signup/widget/navigator_to_account.dart';
import '../widgets/signup_card.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 130),
              child: SvgPicture.asset(AppIcon.landingImage1),
            ),
            const SizedBox(height: 50),
            SignupCard(
              title: 'I`m a Candidate',
              subtitle: 'Practice coding',
              icon: AppIcon.landingImage2,
              color: AppColor.landingCardColor,
              opTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CandidateSignUp()),
                );
              },
            ),
            const SizedBox(height: 15),
            SignupCard(
              title: 'I`m a Recruiter ',
              subtitle: 'Hire talent & Track stats',
              icon: AppIcon.landingImage3,
              color: AppColor.landingCardColor,
              opTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpCompany()),
                );
              },
            ),
            const SizedBox(height: 50),
            NavigatorToAccount(
              text: 'Already have account?',
              actionText: ' Log in',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
