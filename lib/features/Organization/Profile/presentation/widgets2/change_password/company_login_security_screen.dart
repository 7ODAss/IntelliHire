import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/enums/request.dart';
import '../../../../../auth/presentation/login/widget/button_action.dart';
import '../../../../../auth/presentation/login/widget/field_item.dart';
import '../../controller/profile_cubit.dart';
import '../pop_action_menu.dart';
import 'company_otp_step_change_password.dart';

class CompanyChangePasswordScreen extends StatefulWidget {
  const CompanyChangePasswordScreen({super.key});

  @override
  State<CompanyChangePasswordScreen> createState() =>
      _CompanyChangePasswordScreenState();
}

class _CompanyChangePasswordScreenState
    extends State<CompanyChangePasswordScreen> {
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
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.changePasswordRequestState != current.changePasswordRequestState,
      listener: (context, state) {
        if (state.changePasswordRequestState == RequestState.success) {
          context.read<ProfileCubit>().resetPasswordRequestState();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: context.read<ProfileCubit>(),
                child: const CompanyOtpStepChangePassword(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final email = state.companyEmail ?? state.companyAccount?.email ?? '';
        final isSocial = email.toLowerCase().endsWith('@gmail.com') ||
            email.toLowerCase().endsWith('@outlook.com') ||
            email.toLowerCase().endsWith('@hotmail.com') ||
            email.toLowerCase().endsWith('@live.com');

        final isLoading = state.changePasswordRequestState == RequestState.loading;

        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: securityInfoKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PopActionMenu(title: 'Change Password'),
                      const SizedBox(height: 32),
                      FieldItem(
                        controller: currentPassController,
                        title: isSocial ? 'Current Password (Optional - Social Account)' : 'Current Password',
                        hintText: isSocial ? 'Leave empty (social login)' : 'Enter current password',
                        type: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock_outlined,
                        prefixIconColor: const Color(0xFFB4ADAE),
                        validator: (value) {
                          if (isSocial) return null;
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
                          if (!isSocial && value == currentPassController.text) {
                            return "New password can't match current password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      FieldItem(
                        controller: confirmNewPassController,
                        title: 'Confirm New Password',
                        hintText: 'Re-enter new password',
                        type: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock_outlined,
                        prefixIconColor: const Color(0xFFB4ADAE),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Confirm password is required";
                          }
                          if (value != newPassController.text) {
                            return "Confirm password does not match new password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 48),
                      ButtonAction(
                        title: isLoading ? 'Updating...' : 'Update Password',
                        onPressed: isLoading
                            ? null
                            : () {
                                if (securityInfoKey.currentState!.validate()) {
                                  context.read<ProfileCubit>().changePassword(
                                        isSocial ? '' : currentPassController.text,
                                        newPassController.text,
                                      );
                                }
                              },
                      ),
                      if (state.changePasswordRequestState == RequestState.error &&
                          state.changePasswordRequestMessage != null) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            state.changePasswordRequestMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
