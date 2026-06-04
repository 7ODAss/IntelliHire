import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/sign_up_cubit/sign_up_cubit.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../candidate/profile/presentation/widgets/change_password/candidate_login_security_screen.dart';
import '../screen/about_company.dart';
import '../screen/company_login_security_screen.dart';
import 'optionfield.dart';

class SecurityPrivacy extends StatelessWidget {
  const SecurityPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Security & Privacy', style: AppTextStyle.accountNamePostScreen),
        Card(
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionField(
                  icon: Icons.lock_outlined,
                  categoryName: 'Login & Security',
                  options: ['Password , Delete account'],
                  fun: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyLoginSecurityScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
