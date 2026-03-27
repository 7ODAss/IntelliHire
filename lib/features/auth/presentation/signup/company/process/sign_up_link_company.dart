import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';

import '../../../../../../core/enums/request.dart';
import '../../../../../../core/utils/app_text_style.dart';
import '../../../../../Organization/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper.dart';
import '../../../../controller/sign_up_cubit.dart';
import '../../../login/widget/button_action.dart';

class SignUpLinkCompany extends StatelessWidget {
  final VoidCallback onNext;

  const SignUpLinkCompany({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
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
            borderRadius: BorderRadius.only(topRight: Radius.circular(60)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Form(
              key: cubit.linkCompanyFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // link Field
                  FieldItem(
                    controller: cubit.linkCompanyController,
                    title: 'Website or LinkedIn URL',
                    message: 'Enter your Website Company',
                    type: TextInputType.url,
                    hintText: 'https://www.company.com',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a Company Website or LinkedIn URL';
                      }

                      // Regex to check for a valid URL (with or without http/https/www)
                      final urlRegExp = RegExp(
                        r'^(https?:\/\/)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:\d+)?(\/.*)?$',
                        caseSensitive: false,
                      );

                      if (!urlRegExp.hasMatch(value.trim())) {
                        return 'Please enter a valid URL (e.g., https://company.com)';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 48),

                  // Next Button
                  BlocConsumer<SignUpCubit, SignUpState>(
                    listener: (context, state) {
                      if (state.signUpState == RequestState.success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomBottomNavBarWrapper(),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<SignUpCubit, SignUpState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (state.signUpState == RequestState.error)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    state.signUpMessage,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ButtonAction(
                                title: 'Complete Registration',
                                isLoading:
                                    state.signUpState == RequestState.loading,
                                onPressed: onNext,
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {

                                    cubit.signUpCompany(
                                      email: cubit.workEmailController.text,
                                      password:
                                          cubit.workPasswordController.text,
                                      phoneNumber:
                                          cubit.workPhoneController.text,
                                      companyName:
                                          cubit.companyNameController.text,
                                      industry: cubit.state.selectedIndustry,
                                      country: cubit.state.selectedCountry,
                                      gov: cubit.state.selectedGovernorate,
                                      address: cubit.addressController.text,
                                      linkCompany: 'skipped',
                                    );

                                },
                                child: Text(
                                  'Skip this step',
                                  style: AppTextStyle.hintTextStyle,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
