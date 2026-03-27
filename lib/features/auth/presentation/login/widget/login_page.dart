import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';
import 'package:intelli_hire/features/auth/controller/login_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/remember_me.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_company.dart';
import 'package:intelli_hire/user_screen.dart';

import '../../../../../core/enums/snack_bar_type.dart';
import '../../../../Organization/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper.dart';
import '../../signup/Candidate Signup/views/candidate_signup_view.dart';
import '../../signup/widget/navigator_to_account.dart';
import 'external_log_in.dart';
import 'field_item.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: cubit.candidateFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldItem(
                controller: cubit.candidateEmailController,
                title: "Email",
                message: "Please enter your email",
                type: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  } else if (!RegExp(
                    r"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$",
                  ).hasMatch(value)) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              BlocSelector<LoginCubit, LoginState, bool>(
                selector: (state) => state.changeSuffix,
                builder: (context, state) {
                  return FieldItem(
                    controller: cubit.candidatePasswordController,
                    title: "Password",
                    message: "Please enter your password",
                    type: TextInputType.visiblePassword,
                    obscureText: state,
                    suffixIcon: state ? Icons.visibility_off : Icons.visibility,
                    suffixIconColor: const Color(0xFF134CC7),
                    onSuffixPressed: () {
                      context.read<LoginCubit>().changeSuffix();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters long";
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              const RememberMe(),
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state.loginState == RequestState.success) {
                    context.showSnackBar(
                      state.loginMessage,
                      type: SnackBarType.success,
                    );
                    if (cubit.loginModel!.userType == 'Company') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (
                              context) => const CustomBottomNavBarWrapper(),
                        ),
                      );
                    }
                    if (cubit.loginModel!.userType == 'Individual') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (
                              context) => const UserScreen(),
                        ),
                      );
                    }
                  }
                    if (state.loginState == RequestState.error) {
                      context.showSnackBar(
                        state.loginMessage,
                        type: SnackBarType.error,
                      );
                    }
                },
                builder: (context, state) {
                  return BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: ButtonAction(
                              title: "Log In",
                              isLoading:
                                  state.loginState == RequestState.loading,
                              onPressed: () {
                                if (cubit.candidateFormKey.currentState!
                                    .validate()) {
                                  cubit.login(
                                    email: cubit.candidateEmailController.text,
                                    password:
                                        cubit.candidatePasswordController.text,
                                    rememberMe: cubit.state.rememberMeCheck,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              const Row(
                children: [
                  Expanded(
                    child: Divider(color: Color(0xFF9CA3AF), thickness: 1.5),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                    child: Divider(color: Color(0xFF9CA3AF), thickness: 1.5),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const ExternalLogIn(userType: 'candidate'),
              Padding(
                padding: const EdgeInsets.only(
                  top: 32.0,
                  left: 40,
                  bottom: 32.0,
                ),
                child: NavigatorToAccount(
                  text: 'Don\'t have account?',
                  actionText: ' Candidate',
                  actionText2: 'Organization',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CandidateSignUp(),
                      ),
                    );
                  },
                  onTap2: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpCompany(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
