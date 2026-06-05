import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/enums/request.dart';
import '../../../../../core/enums/snack_bar_type.dart';
import '../../../../../core/utils/shared/context_extension.dart';
import '../../../controller/forget_password_cubit/forget_password_cubit.dart';
import '../../login/widget/button_action.dart';
import '../../signup/company/widget/navigator_to_account.dart';

class OtpStep extends StatelessWidget {
  const OtpStep({super.key});


  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listenWhen: (previous, current) => previous.otpState != current.otpState,
      listener: (context, state) {
        if (state.otpState == RequestState.success) {
          cubit.pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
          context.showSnackBar(
            state.otpMessage,
            type: SnackBarType.success,
          );
        }
        if (state.otpState == RequestState.error) {
          context.showSnackBar(
            state.otpMessage,
            type: SnackBarType.error,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            PinInput(
                length: 6,
                autoFocus: true,
                pinController: cubit.otpController,
                builder: (context, cells) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: cells.map((cell) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(color: Color(0xFFAFAFAF)),
                              ),
                              child: Center(
                                child: Text(
                                  cell.character ?? '',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                onCompleted: (pin) => cubit.verifyCode(code: pin,)
            ),
            const SizedBox(height: 48,),
            BlocSelector<ForgetPasswordCubit, ForgetPasswordState, RequestState>(
              selector: (state) {
                return state.otpState;
              },
              builder: (context, state) {
                return ButtonAction(
                  title: 'Continue',
                  isLoading: state == RequestState.loading,
                  onPressed: () {
                    if (cubit.otpController.text.length == 6) {
                      print("OTP: ${cubit.otpController.text}");
                      cubit.verifyCode(code: cubit.otpController.text);
                    } else {
                      context.showSnackBar('Please enter the full 6-digit code',
                          type: SnackBarType.error);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 24,),
            NavigatorToAccount(
              text: 'Didn\'t get OTP? ',
              actionText: 'Resend OTP',
              onTap: () {
                cubit.sendCode(email: cubit.emailController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}