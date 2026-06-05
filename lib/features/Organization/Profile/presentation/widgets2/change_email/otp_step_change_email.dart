import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/widget/navigator_to_account.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../../core/enums/request.dart';
import '../../controller/profile_cubit.dart';
import '../pop_action_menu.dart';
import 'email_updated_screen.dart';

class OtpStepChangeEmail extends StatefulWidget {
  final String currentEmail;
  final String newEmail;
  const OtpStepChangeEmail({
    super.key,
    required this.currentEmail,
    required this.newEmail,
  });

  @override
  State<OtpStepChangeEmail> createState() => _OtpStepChangeEmailState();
}

class _OtpStepChangeEmailState extends State<OtpStepChangeEmail> {
  late PinInputController? otpController;

  @override
  void initState() {
    super.initState();
    otpController = PinInputController();
    context.read<ProfileCubit>().resetOtpState();
  }

  @override
  void dispose() {
    otpController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final cubit = context.read<ProfileCubit>();

        return BlocConsumer<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) =>
              previous.otpState != current.otpState,
          listener: (context, state) {
            if (state.otpState == RequestState.success) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmailUpdatedScreen(newEmail: widget.newEmail),
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
                    child: Column(
                      children: [
                        PopActionMenu(
                          title: 'Back to profile',
                          fun: Navigator.of(context).pop,
                        ),
                        const SizedBox(height: 32),
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
                        if (state.otpState == RequestState.error && state.otpMessage != null && state.otpMessage!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              state.otpMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
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
                                          border: Border.all(color: const Color(0xFFAFAFAF)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            cell.character ?? '',
                                            style: const TextStyle(fontSize: 24),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                          onCompleted: (pin) => cubit.verifyCode(
                            currentEmail: widget.currentEmail,
                            newEmail: widget.newEmail,
                            code: pin,
                          ),
                        ),
                        const SizedBox(height: 48),
                        BlocSelector<
                          ProfileCubit,
                          ProfileState,
                          RequestState
                        >(
                          selector: (state) {
                            return state.otpState ?? RequestState.initial;
                          },
                          builder: (context, state) {
                            return ButtonAction(
                              title: 'Continue',
                              isLoading: state == RequestState.loading,
                              onPressed: () {
                                if (otpController?.text.length == 6) {
                                  cubit.verifyCode(
                                    currentEmail: widget.currentEmail,
                                    newEmail: widget.newEmail,
                                    code: otpController!.text,
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        NavigatorToAccount(
                          text: 'Didn\'t get OTP? ',
                          actionText: 'Resend OTP',
                          onTap: () {
                            cubit.sendCode(
                              currentEmail: widget.currentEmail,
                              newEmail: widget.newEmail,
                            );
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
      },
    );
  }
}
