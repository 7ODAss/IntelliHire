import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/account_setup_view.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_button.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_text_field.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/footer.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/or_dvider.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/signup_header.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/social_buttons.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/terms_checkbox.dart';
import 'package:intelli_hire/features/auth/presentation/signup/widget/pop_action.dart';

import '../../../login/login_screen.dart';

class CandidateSignUp extends StatefulWidget {
  const CandidateSignUp({super.key});

  @override
  State<CandidateSignUp> createState() => _CandidateSignUpState();
}

class _CandidateSignUpState extends State<CandidateSignUp> {
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SignupHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CustomTextField(
                      hint: "Full Name",
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Full Name is required";
                      //   } else if (value.length < 3) {
                      //     return "Full Name must be at least 3 characters";
                      //   }
                      //   return null;
                      // },
                      controller: _nameController,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      hint: "Email",
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Email is required";
                      //   } else if (!RegExp(
                      //     r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                      //   ).hasMatch(value)) {
                      //     return "Enter a valid email address";
                      //   }
                      //   return null;
                      // },
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      hint: "Password",
                      isPassword: true,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Password is required";
                      //   } else if (value.length < 6) {
                      //     return "Password must be at least 6 characters";
                      //   }
                      //   return null;
                      // },
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 16),

                    TermsCheckbox(
                      value: agreeToTerms,
                      side: showTermsError
                          ? BorderSide(color: Colors.red,)
                          : BorderSide(color: AppColor.grey),
                      onChanged: (val) {
                        setState(() {
                          agreeToTerms = val ?? false;
                          showTermsError = false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    CustomButton(
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        //
                        // if (!agreeToTerms) {
                        //   setState(() {
                        //     showTermsError = true;
                        //   });
                        //   return;
                        // }
                        // if (!isValid) {
                        //   return;
                        // }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AccountSetupView(),
                          ),
                        );
                      },
                      title: "Create Account",
                    ),
                    const SizedBox(height: 24),

                    OrDvider(),
                    const SizedBox(height: 24),

                    SocialButtons(),
                    const SizedBox(height: 24),

                    Footer(onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    }),
                    const SizedBox(height: 109),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
