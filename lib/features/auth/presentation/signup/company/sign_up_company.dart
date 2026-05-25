import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_process.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/widget/check_email_screen.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/widget/navigator_to_account.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/widget/pop_action.dart';

import '../../../../../core/enums/request.dart';
import '../../../../../core/enums/snack_bar_type.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/shared/auth_layout.dart';
import '../../../../../core/utils/shared/context_extension.dart';
import '../../../controller/sign_up_cubit/sign_up_cubit.dart';
import '../../login/login_screen.dart';
import '../../login/widget/button_action.dart';
import '../../login/widget/external_log_in.dart';

class SignUpCompany extends StatefulWidget {
  const SignUpCompany({super.key});

  @override
  State<SignUpCompany> createState() => _SignUpCompanyState();
}

class _SignUpCompanyState extends State<SignUpCompany> {
  //Work Information
  late TextEditingController workEmailController;
  late TextEditingController workPasswordController;
  late TextEditingController workConfirmPasswordController ;
  late GlobalKey<FormState> workFormKey;

  @override
  void initState() {
    super.initState();
    workEmailController = TextEditingController();
    workPasswordController = TextEditingController();
    workConfirmPasswordController = TextEditingController();
    workFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    workEmailController.dispose();
    workPasswordController.dispose();
    workConfirmPasswordController.dispose();
    workFormKey.currentState?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listenWhen: (previous, current) =>
            previous.signUpState != current.signUpState,
        listener: (context, state) {
          if (state.signUpState == RequestState.success) {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CheckEmailScreen()),
            );
          } else if (state.signUpState == RequestState.error) {
            context.showSnackBar(state.signUpMessage, type: SnackBarType.error);
          }
        },
        builder: (context, state) {
          return BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              final cubit = context.read<SignUpCubit>();
              return Form(
                key: workFormKey,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 48,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FieldItem(
                              controller: workEmailController,
                              title: 'Work Email',
                              message: 'Enter Your Work Email',
                              type: TextInputType.emailAddress,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return "Email is required";
                              //   }
                              //   // Must have @, must have a domain, and must end with .com
                              //   else if (!RegExp(
                              //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.com$",
                              //   ).hasMatch(value)) {
                              //     return "Please enter a valid email ending in .com";
                              //   }
                              //   // Block common free domains to ensure it's a company domain
                              //   else if (RegExp(
                              //     r'@(gmail\.com|yahoo\.com|hotmail\.com|outlook\.com)$',
                              //     caseSensitive: false,
                              //   ).hasMatch(value)) {
                              //     return "Please use your company/work email address";
                              //   }
                              //   return null;
                              // },
                            ),
                            const SizedBox(height: 16),
                            BlocSelector<SignUpCubit, SignUpState, bool>(
                              selector: (state) {
                                return state.changePasswordSuffix;
                              },
                              builder: (context, state) {
                                return FieldItem(
                                  controller: workPasswordController,
                                  title: 'Password',
                                  message: 'Enter Your Password',
                                  type: TextInputType.visiblePassword,
                                  obscureText: state,
                                  suffixIcon: state
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  suffixIconColor: Color(0xFF134CC7),
                                  onSuffixPressed: () {
                                    cubit.changePasswordSuffix();
                                  },
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return "Password is required";
                                  //   }
                                  //   if (value.length < 8) {
                                  //     return "Password must be at least 8 characters long";
                                  //   }
                                  //   // Must contain at least one lowercase [a-z] AND one uppercase [A-Z]
                                  //   if (!RegExp(
                                  //     r'^(?=.*[a-z])(?=.*[A-Z]).+$',
                                  //   ).hasMatch(value)) {
                                  //     return "Password must contain both uppercase and lowercase letters";
                                  //   }
                                  //   return null;
                                  // },
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocSelector<SignUpCubit, SignUpState, bool>(
                              selector: (state) {
                                return state.changeConfirmPasswordSuffix;
                              },
                              builder: (context, state) {
                                return FieldItem(
                                  controller: workConfirmPasswordController,
                                  title: 'Confirm Password',
                                  message: 'Enter Your Password again',
                                  type: TextInputType.visiblePassword,
                                  obscureText: state,
                                  suffixIcon: state
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  suffixIconColor: Color(0xFF134CC7),
                                  onSuffixPressed: () {
                                    cubit.changeConfirmPasswordSuffix();
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password not match";
                                    }
                                    if (value != workPasswordController.text) {
                                      return "Password not match";
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            const SizedBox(height: 16),
                            ButtonAction(
                              title: 'Create Account',
                              isLoading: state.signUpState == RequestState.loading,
                              onPressed: () {
                                bool isFormValid = workFormKey.currentState!.validate();
                                if (isFormValid) {
                                  cubit.signUpCompany(
                                    email: workEmailController.text,
                                    password: workPasswordController.text,
                                    confirmPassword: workConfirmPasswordController.text,
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                            const Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Color(0xFF9CA3AF),
                                    thickness: 1.5,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    "OR CONTINUE WITH",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Color(0xFF9CA3AF),
                                    thickness: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            const ExternalLogIn(userType: 'company'),
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
              );
            },
          );
        },
      ),
    );
  }
}
