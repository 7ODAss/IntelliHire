import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/widget/navigator_to_account.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/controller/candidate_profile_cubit.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/change_password/candidate_login_security_screen.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/change_email/email_updated_screen.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/pop_action_menu.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../../core/enums/request.dart';
import '../../../../../../core/enums/snack_bar_type.dart';
import '../../../../../../core/utils/shared/context_extension.dart';

class OtpStepChangePassword extends StatefulWidget {
  const OtpStepChangePassword({super.key});

  @override
  State<OtpStepChangePassword> createState() => _OtpStepChangePasswordState();
}

class _OtpStepChangePasswordState extends State<OtpStepChangePassword> {
  late PinInputController? otpController;

  @override
  initState() {
    super.initState();
    otpController = PinInputController();
  }

  @override
  dispose() {
    otpController?.dispose();
    super.dispose();
  }

  //when otp run good navigate to CandidateLoginSecurityScreen  widget

  @override
  Widget build(BuildContext context) {
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
                  /* onCompleted: (pin) =>   cubit.verifyCode(
                        currentEmail: widget.currentEmail ?? "",
                        newEmail: widget.newEmail ?? "",
                        code: pin,
                      ), */
                ),
                const SizedBox(height: 48),

                ButtonAction(
                  title: 'Continue',

                  onPressed: () {
                    if (otpController?.text.length == 6) {
                      /* cubit.verifyCode(
                                currentEmail: widget.currentEmail ?? "",
                                newEmail: widget.newEmail ?? "",
                                code: otpController!.text,
                              ); */
                    } else {
                      context.showSnackBar(
                        'Please enter the full 6-digit code',
                        type: SnackBarType.error,
                      );
                    }
                  },
                ),

                const SizedBox(height: 24),
                NavigatorToAccount(
                  text: 'Didn\'t get OTP? ',
                  actionText: 'Resend OTP',
                  onTap: () {
                    /* cubit.sendCode(
                          currentEmail: widget.currentEmail ?? "",
                          newEmail: widget.newEmail ?? "",
                        ); */
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
