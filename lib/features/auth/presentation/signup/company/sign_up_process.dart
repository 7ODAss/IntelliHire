import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/process/sign_up_information_company.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/process/sign_up_link_company.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/process/sign_up_location_company.dart';

import '../../../controller/sign_up_cubit.dart';
import 'company_sign_up_header.dart';

class SignUpProcess extends StatelessWidget {
  const SignUpProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        final cubit = context.read<SignUpCubit>();
        final currentScreen = state.currentScreen;
        final List<String> titles = ['Company Info', 'Location', 'Website'];
        final List<String> subtitles = [
          'Let\'s get to know your organization better',
          'Where is your company headquarters located?',
          'Help candidates know more about you',
        ];
        return Scaffold(
          body: Column(
            children: [
              CompanySignupHeader(
                screenNumber: currentScreen,
                title: titles[currentScreen],
                subtitle: subtitles[currentScreen],
                onPressed: () {
                  if (currentScreen > 0) {
                    cubit.previousStep();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              Expanded(
                child: IndexedStack(
                  index: currentScreen,
                  children: [
                    SignUpInformationCompany(
                      onNext: () {
                        if (cubit.industryController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please Select Your Industry',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (cubit.validateCurrentStep()) {
                          cubit.nextStep();
                        }
                      },
                    ),

                    SignUpLocationCompany(
                      onNext: () {
                        final country = cubit.countryController.text.isEmpty;
                        final gov = cubit.govController.text.isEmpty;

                        if (country) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please Select Your Country',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (gov) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please Select Your Governorate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (cubit.validateCurrentStep()) {
                          cubit.nextStep();
                        }
                      },
                    ),

                    // Step 2: Company Website/Link
                    SignUpLinkCompany(
                      onNext: () {
                        if (cubit.validateCurrentStep()) {
                            cubit.signUpCompany(
                              email: cubit.workEmailController.text,
                              password: cubit.workPasswordController.text,
                              phoneNumber: cubit.workPhoneController.text,
                              companyName: cubit.companyNameController.text,
                              industry: cubit.state.selectedIndustry,
                              country: cubit.state.selectedCountry,
                              gov: cubit.state.selectedGovernorate,
                              address: cubit.addressController.text,
                              linkCompany: cubit.linkCompanyController.text,
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
