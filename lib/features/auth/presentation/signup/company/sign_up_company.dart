import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/sign_up_cubit/sign_up_cubit.dart';
import 'package:intelli_hire/features/auth/controller/external%20login/external_login_cubit.dart';
import 'package:intelli_hire/features/auth/controller/external%20login/external_login_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/process/sign_up_information_company.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/widget/check_email_screen.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/widget/navigator_to_account.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/widget/pop_action.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/social_buttons.dart';
import '../../../../../core/enums/request.dart';
import '../../../../../core/enums/snack_bar_type.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/shared/auth_layout.dart';
import '../../../../../core/utils/shared/context_extension.dart';
import '../../login/login_screen.dart';
import '../../login/widget/button_action.dart';
import '../../login/widget/field_item.dart';
import '../../../../Organization/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper.dart';
import '../../../../candidate/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper_candidate.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/account_setup_view.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_process.dart';
import 'package:intelli_hire/core/service/api_service.dart';

class SignUpCompany extends StatefulWidget {
  const SignUpCompany({super.key});

  @override
  State<SignUpCompany> createState() => _SignUpCompanyState();
}

class _SignUpCompanyState extends State<SignUpCompany> {
  late TextEditingController workEmailController;
  late TextEditingController workPasswordController;
  late TextEditingController workConfirmPasswordController;
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
    workEmailController.dispose();
    workPasswordController.dispose();
    workConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpCubit()),
        BlocProvider(create: (context) => ExternalLoginCubit()..initDeepLinkListener()),
      ],
      child: BlocListener<ExternalLoginCubit, ExternalLoginState>(
        listener: (context, state) {
          if (state is ExternalLoginSuccess) {
            if (state.userType == 'Company' || state.userType == 'company') {
              if (state.isProfileComplete) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomBottomNavBarWrapper(),
                  ),
                  (route) => false,
                );
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => SignUpCubit(),
                      child: const SignUpProcess(),
                    ),
                  ),
                  (route) => false,
                );
              }
            } else {
              if (state.isProfileComplete) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomBottomNavBarWrapperCandidate(),
                  ),
                  (route) => false,
                );
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => ProfileSetupCubit(ApiService(), userToken: state.token),
                      child: const AccountSetupView(),
                    ),
                  ),
                  (route) => false,
                );
              }
            }
          } else if (state is ExternalLoginFailure) {
            context.showSnackBar(state.error, type: SnackBarType.error);
          }
        },
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listenWhen: (previous, current) => previous.signUpState != current.signUpState,
          listener: (context, state) {
            if (state.signUpState == RequestState.success) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CheckEmailScreen(),
                ),
              );
            } else if (state.signUpState == RequestState.error) {
              context.showSnackBar(
                state.signUpMessage,
                type: SnackBarType.error,
              );
            }
          },
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.com$",
                              ).hasMatch(value)) {
                                return "Please enter a valid email ending in .com";
                              }
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

                          BlocSelector<SignUpCubit, SignUpState, bool>(
                            selector: (state) => state.changePasswordSuffix,
                            builder: (context, state) {
                              return FieldItem(
                                controller: workPasswordController,
                                title: 'Password',
                                message: 'Enter Your Password',
                                type: TextInputType.visiblePassword,
                                obscureText: state,
                                suffixIcon: state ? Icons.visibility_off : Icons.visibility,
                                suffixIconColor: const Color(0xFF134CC7),
                                onSuffixPressed: () {
                                  cubit.changePasswordSuffix();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is required";
                                  }
                                  if (value.length < 8) {
                                    return "Password must be at least 8 characters long";
                                  }
                                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).+$').hasMatch(value)) {
                                    return "Password must contain both uppercase and lowercase letters";
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          BlocSelector<SignUpCubit, SignUpState, bool>(
                            selector: (state) => state.changeConfirmPasswordSuffix,
                            builder: (context, state) {
                              return FieldItem(
                                controller: workConfirmPasswordController,
                                title: 'Confirm Password',
                                message: 'Enter Your Password again',
                                type: TextInputType.visiblePassword,
                                obscureText: state,
                                suffixIcon: state ? Icons.visibility_off : Icons.visibility,
                                suffixIconColor: const Color(0xFF134CC7),
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
                          const SizedBox(height: 24),

                          ButtonAction(
                            title: 'Create Account',
                            isLoading: state.signUpState == RequestState.loading,
                            onPressed: () {
                              if (workFormKey.currentState!.validate()) {
                                cubit.signUpCompany(
                                  email: workEmailController.text,
                                  password: workPasswordController.text,
                                  confirmPassword: workConfirmPasswordController.text,
                                );
                              }
                            },
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 32.0,
                              horizontal: 40,
                            ),
                            child: NavigatorToAccount(
                              text: 'Already have account?',
                              actionText: ' Log in',
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              ),
                            ),
                          ),
                          
                          const SocialButtons(type: '1'),
                          
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}