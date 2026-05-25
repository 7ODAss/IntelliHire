import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/candidate%20register%20cubit/candidate_register_cubit.dart';
import 'package:intelli_hire/features/auth/controller/candidate%20register%20cubit/candidate_register_state.dart';
import 'package:intelli_hire/features/auth/controller/external%20login/external_login_cubit.dart';
import 'package:intelli_hire/features/auth/controller/external%20login/external_login_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/verify_email_view.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_button.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_text_field.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/footer.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/or_dvider.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/signup_header.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/social_buttons.dart';
import '../../../login/login_screen.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/account_setup_view.dart';
// 👈 أضف استيراد الصفحة الرئيسية هنا
import 'package:intelli_hire/features/Organization/bottom%20_navigation/presentation/custom_bottom_nav_bar_wrapper.dart';

class CandidateSignUpView extends StatefulWidget {
  const CandidateSignUpView({super.key});

  @override
  State<CandidateSignUpView> createState() => _CandidateSignUpState();
}

class _CandidateSignUpState extends State<CandidateSignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool agreeToTerms = false;
  bool showTermsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ExternalLoginCubit>()..initDeepLinkListener(),
      child: BlocListener<ExternalLoginCubit, ExternalLoginState>(
        listener: (context, state) {
          if (state is ExternalLoginSuccess) {
            // ✅ التحقق من حالة البروفايل قبل التوجيه
            if (state.isProfileComplete) {
              // 🏠 لو البروفايل كامل -> الصفحة الرئيسية
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomBottomNavBarWrapper(),
                ),
                    (route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) =>
                        ProfileSetupCubit(ApiService(), userToken: state.token),
                    child: const AccountSetupView(),
                  ),
                ),
                    (route) => false,
              );
            }
          } else if (state is ExternalLoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.errorMsg), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SignupHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        CustomTextField(
                          hint: "Full Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Full Name is required";
                            }
                            if (value.length < 3) {
                              return "Full Name must be at least 3 characters";
                            }
                            return null;
                          },
                          controller: _nameController,
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          hint: "Email",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            if (!RegExp(
                              r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                            ).hasMatch(value)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                          controller: _emailController,
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          hint: "Password",
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          hint: "Confirm Password",
                          isPassword: true,
                          controller: _confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        BlocConsumer<CandidateRegisterCubit,
                            CandidateRegisterState>(
                          listener: (context, state) {
                            if (state is CandidateRegisterSuccess) {
                              final cubit =
                              context.read<CandidateRegisterCubit>();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: cubit,
                                    child: const VerifyEmailView(),
                                  ),
                                ),
                              );
                            } else if (state is CandidateRegisterFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.errorMsg),
                                  backgroundColor: Colors.red,
                                  behavior: state.isStep1Error
                                      ? SnackBarBehavior.floating
                                      : SnackBarBehavior.fixed,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return CustomButton(
                              onPressed: state is CandidateRegisterLoading
                                  ? null
                                  : () {
                                final isValid =
                                _formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }

                                final cubit = context
                                    .read<CandidateRegisterCubit>();
                                cubit.saveFirstStep(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                cubit.registerCandidate();
                              },
                              title: state is CandidateRegisterLoading
                                  ? "Creating Account..."
                                  : "Create Account",
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        const OrDvider(),
                        const SizedBox(height: 24),
                        const SocialButtons(type: 0,),
                        const SizedBox(height: 24),
                        Footer(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 109),
                      ],
                    ),
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