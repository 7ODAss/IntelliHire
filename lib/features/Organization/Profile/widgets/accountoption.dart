import 'package:flutter/material.dart';

import '../../../../core/utils/app_text_style.dart';
import '../presentation/login_security_screen.dart';
import '../presentation/personal_information_screen.dart';
import 'optionfield.dart';

class AccountOption extends StatelessWidget {
  const AccountOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account', style: AppTextStyle.accountNamePostScreen),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionField(
                  icon: Icons.person,
                  categoryName: 'Personal Information',
                  options: ['Email , Phone , Photo'],
                  fun: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalInformationScreen(),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Divider(color: Color(0xFFD6D6D6)),
                ),
                OptionField(
                  icon: Icons.lock_outlined,
                  categoryName: 'Login & Security',
                  options: ['Password , Delete account'],
                  fun: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginSecurityScreen(),
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
