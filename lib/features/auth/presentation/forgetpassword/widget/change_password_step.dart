import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/auth/controller/forget_password_cubit/forget_password_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/login/login_screen.dart';

import '../../../../../core/enums/request.dart';
import '../../../../../core/enums/snack_bar_type.dart';
import '../../../../../core/utils/shared/context_extension.dart';
import '../../login/widget/button_action.dart';
import '../../login/widget/field_item.dart';

class ChangePasswordStep extends StatelessWidget {
  const ChangePasswordStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listenWhen: (previous, current) =>
          previous.resetPasswordState != current.resetPasswordState,
      listener: (context, state) {
        if (state.resetPasswordState == RequestState.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
          context.showSnackBar(
            state.resetPasswordMessage,
            type: SnackBarType.success,
          );
        }
        if (state.resetPasswordState == RequestState.error) {
          context.showSnackBar(
            state.resetPasswordMessage,
            type: SnackBarType.error,
          );
        }
      },
      child: Form(
        key: cubit.formKey,
        child: Column(
          children: [
            const SizedBox(height: 16),
            BlocSelector<ForgetPasswordCubit, ForgetPasswordState, bool>(
              selector: (state) {
                return state.changePasswordSuffix;
              },
              builder: (context, state) {
                return FieldItem(
                  controller: cubit.passwordController,
                  title: 'Password',
                  message: 'Enter Your Password',
                  type: TextInputType.visiblePassword,
                  obscureText: state,
                  suffixIcon: state ? Icons.visibility_off : Icons.visibility,
                  suffixIconColor: Color(0xFF134CC7),
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
                    // Must contain at least one lowercase [a-z] AND one uppercase [A-Z]
                    if (!RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z]).+$',
                    ).hasMatch(value)) {
                      return "Password must contain both uppercase and lowercase letters";
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            BlocSelector<ForgetPasswordCubit, ForgetPasswordState, bool>(
              selector: (state) {
                return state.changeConfirmPasswordSuffix;
              },
              builder: (context, state) {
                return FieldItem(
                  controller: cubit.confirmPasswordController,
                  title: 'Confirm Password',
                  message: 'Enter Your Password again',
                  type: TextInputType.visiblePassword,
                  obscureText: state,
                  suffixIcon: state ? Icons.visibility_off : Icons.visibility,
                  suffixIconColor: Color(0xFF134CC7),
                  onSuffixPressed: () {
                    cubit.changeConfirmPasswordSuffix();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password not match";
                    }
                    if (value != cubit.passwordController.text) {
                      return "Password not match";
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 16),
            BlocSelector<
              ForgetPasswordCubit,
              ForgetPasswordState,
              RequestState
            >(
              selector: (state) {
                return state.resetPasswordState;
              },
              builder: (context, state) {
                return ButtonAction(
                  title: 'Continue',
                  isLoading: state == RequestState.loading,
                  onPressed: () {
                    if (cubit.formKey.currentState!.validate()) {
                      cubit.resetPassword(
                        email: cubit.emailController.text,
                        token: cubit.token,
                        password: cubit.passwordController.text,
                        confirmPassword: cubit.confirmPasswordController.text,
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            BlocSelector<
              ForgetPasswordCubit,
              ForgetPasswordState,
              RequestState
            >(
              selector: (state) {
                return state.resetPasswordState;
              },
              builder: (context, state) {
                bool isLoading = state == RequestState.loading;
                return TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('Cancel', style: AppTextStyle.subTitleStyle),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
