import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/enums/snack_bar_type.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';
import 'package:intelli_hire/features/auth/presentation/login/login_screen.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/controller/candidate_profile_cubit.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/pop_action_menu.dart';

class DeleteAccountScreen extends StatefulWidget {
  final CandidateProfileCubit cubit;
  const DeleteAccountScreen({super.key, required this.cubit});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // 🌟 FIX: listenWhen ensures this fires ONLY when deleteAccountStatus changes.
        // Without it, the listener also fired when logout() subsequently changed
        // userProfileCandidateLogOutState (2 more emissions) → Snackbar appeared 3x.
        BlocListener<CandidateProfileCubit, CandidateProfileState>(
          listenWhen: (previous, current) =>
              previous.deleteAccountStatus != current.deleteAccountStatus,
          listener: (context, state) {
            if (state.deleteAccountStatus == RequestState.success) {
              context.showSnackBar(
                state.deleteAccountMessage,
                type: SnackBarType.success,
              );
            } else if (state.deleteAccountStatus == RequestState.error) {
              context.showSnackBar(
                state.deleteAccountMessage,
                type: SnackBarType.error,
              );
            }
          },
        ),

        // 🌟 Navigate to LoginScreen once logout completes after account deletion.
        // Previously there was no logout listener here so the user was stranded
        // on the deleted account's screen.
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: PopActionMenu(
                      title: 'Delete Account',
                      fun: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFDC2626),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🌟 العنوان الرئيسي
                  const Text(
                    'Delete Account?',
                    style: TextStyle(
                      fontFamily: AppFont.interBold,
                      fontSize: 20,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Deleting your account is a permanent action. You will lose all your data and settings and cannot recover them.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFont.interRegular,
                        fontSize: 14,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),

                  FieldItem(
                    controller: _passwordController,
                    title: 'Enter current password',
                    type: TextInputType.visiblePassword,
                    prefixIcon: Icons.lock_outline,
                    prefixIconColor: const Color(0xFF94A3B8),
                    hintText: 'Enter current password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  BlocSelector<
                    CandidateProfileCubit,
                    CandidateProfileState,
                    RequestState
                  >(
                    selector: (state) => state.deleteAccountStatus,
                    builder: (context, deleteStatus) {
                      final isLoading = deleteStatus == RequestState.loading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<CandidateProfileCubit>()
                                        .deleteAccount(
                                          currentEmail:
                                              context
                                                  .read<CandidateProfileCubit>()
                                                  .state
                                                  .candidateProfileModel
                                                  ?.email ??
                                              '',
                                          currentPassword:
                                              _passwordController.text,
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontFamily: AppFont.interBold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  BlocSelector<
                    CandidateProfileCubit,
                    CandidateProfileState,
                    RequestState
                  >(
                    selector: (state) => state.deleteAccountStatus,
                    builder: (context, deleteStatus) {
                      final isLoading = deleteStatus == RequestState.loading;
                      return SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ), // بوردر خفيف رمادي
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF0F172A),
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: AppFont.interBold,
                                    fontSize: 16,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
