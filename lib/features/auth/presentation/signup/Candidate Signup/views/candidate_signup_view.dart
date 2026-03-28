import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/features/auth/controller/candidate%20register%20cubit/candidate_register_cubit.dart';
import 'package:intelli_hire/features/auth/controller/candidate%20register%20cubit/candidate_register_state.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/account_setup_view.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_button.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_text_field.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/footer.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/or_dvider.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/signup_header.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/social_buttons.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/terms_checkbox.dart';
import '../../../login/login_screen.dart';

class CandidateSignUpView extends StatefulWidget {
  const CandidateSignUpView({super.key});

  @override
  State<CandidateSignUpView> createState() => _CandidateSignUpState();
}

class _CandidateSignUpState extends State<CandidateSignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool agreeToTerms = false;
  bool showTermsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CandidateRegisterCubit, CandidateRegisterState>(
        listener: (context, state) {
          if (state is CandidateRegisterFailure && state.isStep1Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMsg),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SingleChildScrollView(
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      TermsCheckbox(
                        value: agreeToTerms,
                        side: showTermsError
                            ? const BorderSide(color: Colors.red)
                            : BorderSide(color: AppColor.grey),
                        onChanged: (val) {
                          setState(() {
                            agreeToTerms = val ?? false;
                            showTermsError = false;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      BlocBuilder<
                        CandidateRegisterCubit,
                        CandidateRegisterState
                      >(
                        builder: (context, state) {
                          return CustomButton(
                            onPressed: () {
                              final isValid = _formKey.currentState!.validate();

                              if (!agreeToTerms) {
                                setState(() {
                                  showTermsError = true;
                                });
                                return;
                              }

                              if (!isValid) return;

                              final cubit = context
                                  .read<CandidateRegisterCubit>();
                              cubit.saveFirstStep(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(value: cubit),
                                      BlocProvider(
                                        create: (context) =>
                                            ProfileSetupCubit(ApiService()),
                                      ),
                                    ],
                                    child: const AccountSetupView(),
                                  ),
                                ),
                              );
                            },
                            title: "Create Account",
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const OrDvider(),
                      const SizedBox(height: 24),
                      const SocialButtons(),
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
    );
  }
}
