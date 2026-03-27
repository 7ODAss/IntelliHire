import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/shared/auth_step_layout.dart';
import 'package:intelli_hire/features/auth/controller/sign_up_cubit.dart';

import '../../../../../Organization/Post Job/presentation/widget/custom_dropdown_menu.dart';
import '../../../login/widget/button_action.dart';
import '../../../login/widget/field_item.dart';

class SignUpInformationCompany extends StatelessWidget {
  final VoidCallback onNext;

  const SignUpInformationCompany({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return AuthStepLayout(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 48,
          ),
          child: Form(
            key: cubit.industryFormKey,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldItem(
                    controller: cubit.companyNameController,
                    title: 'Company Name',
                    message: 'Enter Your Company Name',
                    type: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your company name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocSelector<SignUpCubit, SignUpState, String>(
                    selector: (state) {
                      return state.selectedIndustry;
                    },
                    builder: (context, state) {
                      return CustomDropdownMenu(
                        title: "Industry",
                        hint: 'Select Industry',
                        items: cubit.industries,
                        value: state.isEmpty ? null : state,
                        onChanged: (val) => cubit.changeSelectedIndustry(val!),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  ButtonAction(
                    title: 'Next',
                    onPressed: onNext,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
