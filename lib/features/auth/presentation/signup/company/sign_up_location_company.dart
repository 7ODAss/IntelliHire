import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_link_company.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../controller/sign_up_cubit.dart';
import '../../login/widget/signup_action.dart';
import '../widget/custom_search.dart';
import '../widget/custom_stepper.dart';
import '../widget/pop_action.dart';

class SignUpLocationCompany extends StatelessWidget {
  final int selectedPage;

  const SignUpLocationCompany({super.key, required this.selectedPage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        final cubit = context.read<SignUpCubit>();
        return Form(
          key: cubit.locationFormKey,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: PopAction(),
                          ),
                          const SizedBox(height: 16),
                          CustomStepper(screenNumber: selectedPage),
                          const SizedBox(height: 16),
                          Text(
                            'Location',
                            style: AppTextStyle
                                .signUpTitleInformationCompanyStyle,
                          ),
                          Text(
                            'Where is your company headquarters located?',
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
                            LocationSelectionSection(cubit: cubit),
                            const SizedBox(height: 16),
                            // Address Field
                            FieldItem(
                              controller: cubit.addressController,
                              title: 'Detailed Address',
                              message: 'Enter your detailed address',
                              type: TextInputType.streetAddress,
                              hintText: 'e.g Building 4, Street 9, Maadi',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a detailed address';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 48),

                            // Next Button
                            SignupAction(
                              formKey: cubit.locationFormKey,
                              title: 'Next',
                              onPressed: () {
                                if (cubit.locationFormKey.currentState!
                                    .validate()) {
                                  if (cubit
                                          .countryController
                                          .text
                                          .isNotEmpty &&
                                      cubit
                                          .govController
                                          .text
                                          .isNotEmpty ) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider.value(
                                              value: cubit,
                                              child: SignUpLinkCompany(
                                                selectedPage: 2,
                                              ),
                                            ),
                                      ),
                                    );
                                  }
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
