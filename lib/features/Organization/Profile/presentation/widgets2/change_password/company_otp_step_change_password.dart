import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/widget/navigator_to_account.dart';
import 'package:intelli_hire/features/Organization/Profile/presentation/controller/profile_cubit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../pop_action_menu.dart';

class CompanyOtpStepChangePassword extends StatefulWidget {
  const CompanyOtpStepChangePassword({super.key});

  @override
  State<CompanyOtpStepChangePassword> createState() => _CompanyOtpStepChangePasswordState();
}

class _CompanyOtpStepChangePasswordState extends State<CompanyOtpStepChangePassword> {
  late PinInputController? otpController;

  @override
  void initState() {
    super.initState();
    otpController = PinInputController();
  }

  @override
  void dispose() {
    otpController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.changePasswordOtpState != current.changePasswordOtpState,
      listener: (context, state) {
        if (state.changePasswordOtpState == RequestState.success) {
          cubit.resetPasswordChangeStates();
          // Pop twice to return to the options screen
          Navigator.pop(context); // Pops OTP step
          Navigator.pop(context); // Pops request step
        } else if (state.changePasswordOtpState == RequestState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.changePasswordOtpMessage != null && state.changePasswordOtpMessage!.isNotEmpty
                    ? state.changePasswordOtpMessage!
                    : 'The OTP code is incorrect. Please try again.',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final email = state.companyEmail ?? state.companyAccount?.email ?? '';
        final isLoading = state.changePasswordOtpState == RequestState.loading;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
                child: Column(
                  children: [
                    PopActionMenu(
                      title: 'Change Password',
                      fun: Navigator.of(context).pop,
                    ),
                    const SizedBox(height: 24),
                    SvgPicture.asset(
                      'assets/images/forget_password_svg/frame-2.svg',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 56, bottom: 16),
                      child: Text('Get Your Code', style: AppTextStyle.titleStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Enter the 6-digit code sent to your email',
                        style: AppTextStyle.subTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PinInput(
                      length: 6,
                      autoFocus: true,
                      pinController: otpController,
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
                      onCompleted: (pin) {
                        cubit.verifyPasswordOtp(
                          email: email,
                          code: pin,
                        );
                      },
                    ),
                    const SizedBox(height: 48),
                    ButtonAction(
                      title: isLoading ? 'Verifying...' : 'Continue',
                      onPressed: isLoading
                          ? null
                          : () {
                              if (otpController?.text.length == 6) {
                                cubit.verifyPasswordOtp(
                                  email: email,
                                  code: otpController!.text,
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 24),
                    NavigatorToAccount(
                      text: 'Didn\'t get OTP? ',
                      actionText: 'Resend OTP',
                      onTap: () {
                        cubit.resendPasswordOtp(email: email);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
