import 'package:flutter/material.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../screen/about_company.dart';
import '../screen/company_login_security_screen.dart';
import '../screen/account_details_screen.dart';
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
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionField(
                  icon: Icons.person,
                  categoryName: 'Account Details',
                  options: ['Name , Industry, Email , Phone , Photo'],
                  fun: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountDetailsScreen(),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Divider(color: Color(0xFFD6D6D6)),
                ),
                OptionField(
                  icon: Icons.business_outlined,
                  categoryName: 'About Company',
                  options: ['About company , Location , Web'],
                  fun: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AboutCompany(),));
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
