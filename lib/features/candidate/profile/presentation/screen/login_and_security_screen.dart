import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/enums/snack_bar_type.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/controller/candidate_profile_cubit.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/change_password/otp_step_change_password.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/delete_account_screen.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/optionfield.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/pop_action_menu.dart';

class LoginAndSecurityScreen extends StatelessWidget {
  final CandidateProfileCubit cubit;
  const LoginAndSecurityScreen({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CandidateProfileCubit, CandidateProfileState>(
      // 🌟 Only react when changePasswordOtpRequestState changes — not on every state emission.
      listenWhen: (previous, current) =>
          previous.changePasswordOtpRequestState !=
          current.changePasswordOtpRequestState,
      listener: (context, state) {
        if (state.changePasswordOtpRequestState == RequestState.success) {
          // 🌟 OTP request succeeded — navigate to OTP screen now.
          // Previously this navigation happened unconditionally with await,
          // meaning it ran even if the OTP request failed.
          Navigator.push(
            context,
            MaterialPageRoute(
              // 🌟 Carry BlocProvider.value so OtpStepChangePassword's BlocListener
              // / BlocSelector can resolve CandidateProfileCubit from context.
              builder: (context) => BlocProvider.value(
                value: cubit,
                child: OtpStepChangePassword(cubit: cubit),
              ),
            ),
          );
        } else if (state.changePasswordOtpRequestState == RequestState.error) {
          context.showSnackBar(
            state.changePasswordOtpRequestMessage,
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PopActionMenu(title: 'Login & Security'),
              const SizedBox(height: 32),

              // 🌟 Show loading indicator on the Change Password option while OTP is being requested.
              BlocSelector<CandidateProfileCubit, CandidateProfileState, bool>(
                selector: (state) =>
                    state.changePasswordOtpRequestState == RequestState.loading,
                builder: (context, isLoading) {
                  return OptionField(
                    icon: Icons.lock_outlined,
                    categoryName: 'Change Password',
                    options: ['Update your account password'],
                    fun: isLoading
                        ? null // 🌟 Disable tap while request is in-flight.
                        : () {
                            // 🌟 Fire the OTP request. Navigation is handled in the BlocListener above,
                            // only when the request actually succeeds.
                            cubit.requestPasswordOtp(
                              currentEmail:
                                  cubit.state.candidateProfileModel?.email ??
                                  '',
                            );
                          },
                  );
                },
              ),

              const SizedBox(height: 48),
              Text(
                'Account Management',
                style: AppTextStyle.fieldTitleStyle.copyWith(fontSize: 16),
              ),

              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // 🌟 Carry BlocProvider.value so DeleteAccountScreen can resolve cubit.
                        builder: (context) => BlocProvider.value(
                          value: cubit,
                          child: DeleteAccountScreen(cubit: cubit),
                        ),
                      ),
                    );
                  },
                  title: Text(
                    'Delete Account',
                    style: AppTextStyle.fieldTitleStyle.copyWith(
                      color: const Color(0xFFDC2626),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      'This action cannot be undone',
                      style: TextStyle(color: Color(0xFFEF4444), fontSize: 12),
                    ),
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 22,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
