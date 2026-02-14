import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_information_company.dart';
import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../controller/sign_up_cubit.dart';
import '../../login/login_screen.dart';
import '../../login/widget/signup_action.dart';
import '../widget/navigator_to_account.dart';
import '../widget/pop_action.dart';
import '../widget/terms_conditions.dart';

class SignUpCompany extends StatelessWidget {
  const SignUpCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<SignUpCubit>();
          return Form(
            key: cubit.workFormKey,
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
                      ),

                      SingleChildScrollView(
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
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return "Email is required";
                                  //   } else if (!RegExp(
                                  //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                  //   ).hasMatch(value)) {
                                  //     return "Please enter a valid email (e.g., name@company.com)";
                                  //   } else if (RegExp(
                                  //     r'@(gmail\.com|yahoo\.com|hotmail\.com|outlook\.com)$',
                                  //     caseSensitive: false,
                                  //   ).hasMatch(value)) {
                                  //     return "Please use your company/work email address";
                                  //   }
                                  //   return null;
                                  // },
                                ),
                                const SizedBox(height: 16),
                                FieldItem(
                                  controller: cubit.workPhoneController,
                                  title: 'Phone Number',
                                  message: 'Enter Your Phone Number',
                                  type: TextInputType.phone,
                                  validator: (value) {
                                    // if (value == null || value.isEmpty) {
                                    //   return "Phone number is required";
                                    // }
                                    // return null;
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
                                        // if (value == null || value.isEmpty) {
                                        //   return "Password is required";
                                        // } else if (value.length < 6) {
                                        //   return "Password must be at least 6 characters long";
                                        // }
                                        // return null;
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                TermsConditions(),
                                const SizedBox(height: 16),
                                SignupAction(
                                  formKey: cubit.workFormKey,
                                  title: 'Create Account',
                                  onPressed: () {
                                    if (cubit.workFormKey.currentState!
                                        .validate()) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BlocProvider.value(value: cubit,
                                              child: SignUpInformationCompany(),
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
                    ],
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
