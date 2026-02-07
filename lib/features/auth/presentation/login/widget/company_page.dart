import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/core/utils/shared/my_form_field.dart';
import 'package:intelli_hire/features/auth/controller/login_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/signup_action.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import 'field_item.dart';

class CompanyPage extends StatelessWidget {

  const CompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: cubit.companyFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldItem(
                controller: cubit.companyEmailController,
                title: "Work Email",
                message: "Please enter your email",
                type: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              BlocSelector<LoginCubit, LoginState, bool>(
                selector: (state) => state.changeSuffix,
                builder: (context, state) {
                  return FieldItem(
                    controller: cubit.companyPasswordController,
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
                  formKey: cubit.companyFormKey,
                  title: "Create Account",
                ),
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
