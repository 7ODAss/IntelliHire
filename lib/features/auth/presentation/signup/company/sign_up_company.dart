import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_process.dart';

import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/shared/auth_layout.dart';
import '../../../controller/sign_up_cubit.dart';
import '../../login/login_screen.dart';
import '../../login/widget/button_action.dart';
import '../widget/navigator_to_account.dart';
import '../widget/pop_action.dart';
import '../widget/terms_conditions.dart';

class SignUpCompany extends StatelessWidget {
  const SignUpCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          final cubit = context.read<SignUpCubit>();
          return Form(
            key: cubit.workFormKey,
            child: Scaffold(
              body: AuthLayout(
                bodyColor: const Color(0xFFF8FAFC),
                headerContent: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PopAction(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome to IntelliHire',
                      style: AppTextStyle.signUpTitleStyle,
                    ),
                    Text(
                      'Step into the future of hiring',
                      style: AppTextStyle.loginSubTitleStyle,
                    ),
                  ],
                ),
                bodyContent: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldItem(
                            controller: cubit.workEmailController,
                            title: 'Work Email',
                            message: 'Enter Your Work Email',
                            type: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              // Must have @, must have a domain, and must end with .com
                              else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.com$",
                              ).hasMatch(value)) {
                                return "Please enter a valid email ending in .com";
                              }
                              // Block common free domains to ensure it's a company domain
                              else if (RegExp(
                                r'@(gmail\.com|yahoo\.com|hotmail\.com|outlook\.com)$',
                                caseSensitive: false,
                              ).hasMatch(value)) {
                                return "Please use your company/work email address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          FieldItem(
                            controller: cubit.workPhoneController,
                            title: 'Phone Number',
                            message: 'Enter Your Phone Number',
                            type: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Phone number is required";
                              }
                              // Strip spaces if you are using the EgyptianPhoneFormatter
                              String cleanPhone = value.replaceAll(' ', '');
                              // Check if it's at least 8 digits
                              if (cleanPhone.length < 8) {
                                return "Phone number must be at least 8 digits";
                              }
                              // Optional: Ensure it only contains numbers
                              if (!RegExp(r'^[0-9]+$').hasMatch(cleanPhone)) {
                                return "Phone number must contain only digits";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocSelector<SignUpCubit, SignUpState, bool>(
                            selector: (state) {
                              return state.changeSuffix;
                            },
                            builder: (context, state) {
                              return FieldItem(
                                controller: cubit.workPasswordController,
                                title: 'Password',
                                message: 'Enter Your Password',
                                type: TextInputType.visiblePassword,
                                obscureText: state,
                                suffixIcon: state
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                suffixIconColor: Color(0xFF134CC7),
                                onSuffixPressed: () {
                                  cubit.changeSuffix();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is required";
                                  }
                                  if (value.length < 8) {
                                    return "Password must be at least 8 characters long";
                                  }
                                  // Must contain at least one lowercase [a-z] AND one uppercase [A-Z]
                                  if (!RegExp(
                                    r'^(?=.*[a-z])(?=.*[A-Z]).+$',
                                  ).hasMatch(value)) {
                                    return "Password must contain both uppercase and lowercase letters";
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          TermsConditions(),
                          const SizedBox(height: 16),
                          ButtonAction(
                            title: 'Create Account',
                            onPressed: () {
                              bool isFormValid = cubit.workFormKey.currentState!
                                  .validate();
                              // Check if Terms & Conditions is checked
                              bool isTermsChecked =
                                  cubit.state.checkBoxTermsConditions;
                              if (!isTermsChecked) {
                                // Show an error if they didn't check the box
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'You must agree to the Terms and Privacy Policy',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (isFormValid && isTermsChecked) {
                                cubit.clearAllControllers();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return BlocProvider.value(
                                        value: cubit,
                                        child: SignUpProcess(),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 32.0,
                              horizontal: 80,
                            ),
                            child: NavigatorToAccount(
                              text: 'Already have account?',
                              actionText: ' Log in',
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
