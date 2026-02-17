import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/sign_up_cubit.dart';

import '../../../login/widget/field_item.dart';
import '../../../login/widget/signup_action.dart';
import '../../widget/custom_drop_down.dart';

class SignUpInformationCompany extends StatelessWidget {
  final VoidCallback onNext;

  const SignUpInformationCompany({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.5, 0.5, 1.0],
          colors: [
            Colors.white,
            Colors.white,
            Color(0xFF0F172A),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(60),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 48,
          ),
          child: Form(
            key: cubit.industryFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldItem(
                  controller: cubit.companyNameController,
                  title: 'Company Name',
                  message: 'Enter Your Company Name',
                  type: TextInputType.name,
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter your company name';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 16),
                CustomDropDown(
                  items: cubit.industries,
                  selectedValue: cubit.selectedIndustry,
                  onChanged: (value) {
                    cubit.selectedIndustry = value;
                  },
                  hintText: 'Industry',
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please select an industry';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 48),
                SignupAction(
                  formKey: cubit.industryFormKey,
                  title: 'Next',
                  onPressed: onNext,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}