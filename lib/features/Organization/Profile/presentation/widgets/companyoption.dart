import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/sign_up_cubit.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../screen/company_details.dart';
import 'optionfield.dart';

class CompanyOption extends StatelessWidget {
  const CompanyOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Company', style: AppTextStyle.accountNamePostScreen),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionField(
                  icon: Icons.business_outlined,
                  categoryName: 'Company Details',
                  options: ['Name , Industry , Location , Web'],
                  fun: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => CompanyDetails(),));
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
