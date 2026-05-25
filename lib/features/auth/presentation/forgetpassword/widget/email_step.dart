import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';

import '../../../../../core/enums/request.dart';
import '../../../../../core/enums/snack_bar_type.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../controller/forget_password_cubit/forget_password_cubit.dart';
import '../../login/widget/button_action.dart';
import '../../login/widget/field_item.dart';

class EmailStep extends StatelessWidget {
  const EmailStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listenWhen: (previous, current) =>
      previous.checkEmailState != current.checkEmailState,
      listener: (context, state) {
        if (state.checkEmailState == RequestState.success) {
          cubit.pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
          context.showSnackBar(
            state.checkEmailMessage,
            type: SnackBarType.success,
          );
        }
        if (state.checkEmailState == RequestState.error) {
          context.showSnackBar(
            state.checkEmailMessage,
            type: SnackBarType.error,
          );
        }
      },
      child: Form(
        key: cubit.emailFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            children: [
              FieldItem(
                title: 'Email',
                message: 'Please enter your email',
                controller: cubit.emailController,
                type: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 48),
              BlocSelector<ForgetPasswordCubit, ForgetPasswordState, RequestState>(
                selector: (state) {
                  return state.checkEmailState;
                },
                builder: (context, state) {
                  return ButtonAction(
                    title: 'Recover Password',
                    isLoading: state == RequestState.loading,
                    onPressed: () {
                      if (cubit.emailFormKey.currentState!.validate()) {
                        cubit.sendCode(email: cubit.emailController.text);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '← Back to Login',
                  style: AppTextStyle.subTitleStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
