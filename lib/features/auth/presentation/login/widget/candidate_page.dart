import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/features/auth/controller/login_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/signup_action.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_company.dart';
import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../signup/Candidate Signup/views/candidate_signup_view.dart';
import '../../signup/widget/navigator_to_account.dart';
import 'field_item.dart';

class CandidatePage extends StatelessWidget {
  const CandidatePage({super.key});

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
                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                  ).hasMatch(value)) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
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
                    suffixIconColor: Color(0xFF134CC7),
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

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: SignupAction(
                  formKey: cubit.candidateFormKey,
                  title: "Create Account",
                  onPressed: () {
                    if (cubit.candidateFormKey.currentState!.validate()) {}
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Color(0xFF9CA3AF), thickness: 1.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/images/login/google.svg"),
                          SizedBox(width: 8),
                          Text(
                            "Google",
                            style: AppTextStyle.loginSubTitleStyle.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.linkedInButtonBorderColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/images/login/linkedin.svg"),
                          SizedBox(width: 8),
                          Text(
                            "LinkedIn",
                            style: AppTextStyle.loginSubTitleStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32.0,
                  horizontal: 80,
                ),
                child: NavigatorToAccount(
                  text: 'Don\'t have account?',
                  actionText: ' Sign Up',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CandidateSignUp(),
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
