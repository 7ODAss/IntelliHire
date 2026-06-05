import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';

import '../../../../../../core/enums/request.dart';
import '../../../../../../core/enums/snack_bar_type.dart';
import '../../../../../auth/presentation/login/widget/button_action.dart';
import '../../../../../auth/presentation/login/widget/field_item.dart';
import '../../controller/candidate_profile_cubit.dart';
import '../pop_action_menu.dart';

class CandidateCHangePasswordStep extends StatefulWidget {
  final CandidateProfileCubit cubit;
  const CandidateCHangePasswordStep({super.key, required this.cubit});

  @override
  State<CandidateCHangePasswordStep> createState() =>
      _CandidateCHangePasswordStepState();
}

class _CandidateCHangePasswordStepState
    extends State<CandidateCHangePasswordStep> {
  late TextEditingController currentPassController;
  late TextEditingController newPassController;
  late TextEditingController confirmNewPassController;
  late GlobalKey<FormState> securityInfoKey;

  @override
  void initState() {
    super.initState();
    currentPassController = TextEditingController();
    newPassController = TextEditingController();
    confirmNewPassController = TextEditingController();
    securityInfoKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmNewPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 Changed: Now listening to changePasswordVerifyState (new OTP-flow endpoint)
    // instead of changePasswordStatus (the old direct-change endpoint that bypassed OTP).
    return BlocListener<CandidateProfileCubit, CandidateProfileState>(
      listenWhen: (previous, current) =>
          previous.changePasswordVerifyState !=
          current.changePasswordVerifyState,
      listener: (context, state) {
        if (state.changePasswordVerifyState == RequestState.success) {
          context.showSnackBar(
            type: SnackBarType.success,
            'Password changed successfully',
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (state.changePasswordVerifyState == RequestState.error) {
          context.showSnackBar(
            type: SnackBarType.error,
            state.changePasswordVerifyMessage,
          );
        }
      },

      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: securityInfoKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PopActionMenu(title: 'Change Password'),
                    const SizedBox(height: 32),
                    FieldItem(
                      controller: currentPassController,
                      title: 'Current Password',
                      hintText: 'Enter current password',
                      type: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock_outlined,
                      prefixIconColor: const Color(0xFFB4ADAE),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    FieldItem(
                      controller: newPassController,
                      title: 'New Password',
                      hintText: 'Enter new password',
                      type: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock_outlined,
                      prefixIconColor: const Color(0xFFB4ADAE),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value == currentPassController.text) {
                          return "New password can't match current password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    FieldItem(
                      controller: confirmNewPassController,
                      title: 'Confirm New Password',
                      hintText: 'Confirm new password',
                      type: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock_outlined,
                      prefixIconColor: const Color(0xFFB4ADAE),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value != newPassController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 48),
                    // 🌟 Changed: Now selecting changePasswordVerifyState for the loading indicator,
                    // matching the new verifyNewPassword call below.
                    BlocSelector<
                      CandidateProfileCubit,
                      CandidateProfileState,
                      RequestState
                    >(
                      selector: (state) => state.changePasswordVerifyState,
                      builder: (context, state) {
                        return ButtonAction(
                          isLoading: state == RequestState.loading,
                          title: 'Update Password',
                          onPressed: () {
                            if (securityInfoKey.currentState!.validate()) {
                              final email =
                                  widget
                                      .cubit
                                      .state
                                      .candidateProfileModel
                                      ?.email ??
                                  '';
                              // 🌟 Changed: calling verifyNewPassword() with the token that was
                              // returned from the OTP check step and stored in
                              // state.changePasswordOtpCheckToken.
                              // Previously called changePassword(currentPass, newPass) which
                              // bypassed the OTP flow entirely and hit a different endpoint.
                              widget.cubit.verifyNewPassword(
                                email: email,
                                token: widget
                                    .cubit
                                    .state
                                    .changePasswordOtpCheckToken,
                                currentPassword: currentPassController.text,
                                newPassword: newPassController.text,
                                confirmPassword: confirmNewPassController.text,
                              );
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
