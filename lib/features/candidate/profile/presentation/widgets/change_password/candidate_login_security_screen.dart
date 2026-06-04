import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';

import '../../../../../../core/enums/request.dart';
import '../../../../../../core/enums/snack_bar_type.dart';
import '../../../../../../core/utils/app_text_style.dart';
import '../../../../../auth/presentation/login/login_screen.dart';
import '../../../../../auth/presentation/login/widget/button_action.dart';
import '../../../../../auth/presentation/login/widget/field_item.dart';
import '../../controller/candidate_profile_cubit.dart';
import '../pop_action_menu.dart';

class CandidateLoginSecurityScreen extends StatefulWidget {
  const CandidateLoginSecurityScreen({super.key});

  @override
  State<CandidateLoginSecurityScreen> createState() =>
      _CandidateLoginSecurityScreenState();
}

class _CandidateLoginSecurityScreenState
    extends State<CandidateLoginSecurityScreen> {
  // Security
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
    final cubit = context.read<CandidateProfileCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<CandidateProfileCubit, CandidateProfileState>(
          listenWhen: (previous, current) =>
              previous.changePasswordStatus != current.changePasswordStatus,
          listener: (context, state) {
            if (state.changePasswordStatus == RequestState.success) {
              context.showSnackBar(
                type: SnackBarType.success,
                'Password changed successfully',
              );
              Navigator.pop(context);
            } else if (state.changePasswordStatus == RequestState.error) {
              context.showSnackBar(
                type: SnackBarType.error,
                state.changePasswordMessage,
              );
            }
          },
        ),

        BlocListener<CandidateProfileCubit, CandidateProfileState>(
          listenWhen: (previous, current) =>
              previous.deleteAccountStatus != current.deleteAccountStatus,
          listener: (context, state) {
            if (state.deleteAccountStatus == RequestState.success) {
              context.showSnackBar(
                type: SnackBarType.success,
                'Account deleted successfully',
              );
            } else if (state.deleteAccountStatus == RequestState.error) {
              context.showSnackBar(
                type: SnackBarType.error,
                state.deleteAccountMessage,
              );
            }
          },
        ),

        BlocListener<CandidateProfileCubit, CandidateProfileState>(
          listenWhen: (previous, current) =>
              previous.userProfileCandidateLogOutState !=
              current.userProfileCandidateLogOutState,
          listener: (context, state) {
            if (state.userProfileCandidateLogOutState == RequestState.success) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
          },
        ),
      ],
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
                      prefixIconColor: Color(0xFFB4ADAE),
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
                      prefixIconColor: Color(0xFFB4ADAE),
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
                      hintText: 'Enter new password',
                      type: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock_outlined,
                      prefixIconColor: Color(0xFFB4ADAE),
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
                    const SizedBox(height: 48),
                    ButtonAction(
                      title: 'Update Password',
                      onPressed: () {
                        if (securityInfoKey.currentState!.validate()) {
                          cubit.changePassword(
                            currentPassController.text,
                            newPassController.text,
                          );
                        }
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
