import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/features/auth/controller/login_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/signup_action.dart';
import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
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
              ),
              SizedBox(height: 16),
              BlocSelector<LoginCubit,LoginState , bool>(
                selector: (state) =>state.changeSuffix,
                builder: (context, state) {
                  return FieldItem(
                    controller: cubit.candidatePasswordController,
                    title: "Password",
                    message: "Please enter your password",
                    type: TextInputType.visiblePassword,
                    obscureText: state,
                    suffixIcon: state
                        ? Icons.visibility_off
                        : Icons.visibility,
                    suffixIconColor: Color(0xFF134CC7),
                    onSuffixPressed: () {
                      context.read<LoginCubit>().changeSuffix();
                    },
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: SignupAction(
                  formKey: cubit.candidateFormKey,
                  title: "Create Account",
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFF9CA3AF),
                      thickness: 1.5,
                    ),
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
                    child: Divider(
                      color: Color(0xFF9CA3AF),
                      thickness: 1.5,
                    ),
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
                          Text("Google"),
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
                          Text("LinkedIn", style: TextStyle(
                              color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have account?',
                    style: AppTextStyle.landingLoginStyle,
                  ),
                  TextButton(
                    onPressed: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      'Sign up',
                      style: AppTextStyle.subTitleStyle.copyWith(
                        color: AppColor.logicColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
