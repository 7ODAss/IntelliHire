import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/sign_up_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_location_company.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../login/widget/field_item.dart';
import '../../login/widget/signup_action.dart';
import '../widget/custom_drop_down.dart';
import '../widget/custom_stepper.dart';
import '../widget/pop_action.dart';

class SignUpInformationCompany extends StatelessWidget {
  const SignUpInformationCompany({super.key});

  @override
  Widget build(BuildContext context) {
    print("sign up information company");
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        final cubit = context.read<SignUpCubit>();
        return Form(
          key: cubit.industryFormKey,
          child: Scaffold(
            body: Container(
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
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F172A),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: PopAction(),
                          ),
                          const SizedBox(height: 16),
                          CustomStepper(screenNumber: 0),
                          const SizedBox(height: 16),
                          Text(
                            'Company Info',
                            style: AppTextStyle
                                .signUpTitleInformationCompanyStyle,
                          ),
                          Text(
                            'Let\'s get to know your organization better',
                            style: AppTextStyle.loginSubTitleStyle,
                          ),
                        ],
                      ),
                    ),

                    Container(
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
                              validator: (value) {
                                // if (value!.isEmpty) {
                                //   return 'Please select an industry';
                                // }
                                // return null;
                              },
                            ),

                            const SizedBox(height: 48),
                            SignupAction(
                              formKey: cubit.industryFormKey,
                              title: 'Next',
                              onPressed: () {
                                if (cubit.industryFormKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BlocProvider.value(
                                            value: cubit,
                                            child: SignUpLocationCompany(
                                                selectedPage: 1),
                                          ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
