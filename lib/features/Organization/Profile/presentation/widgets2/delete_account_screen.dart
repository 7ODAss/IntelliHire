import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import 'package:intelli_hire/features/auth/presentation/login/login_screen.dart';
import 'package:intelli_hire/features/Organization/Profile/presentation/controller/profile_cubit.dart';
import 'pop_action_menu.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  late final TextEditingController _currentEmailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _currentEmailController = TextEditingController();
    _currentEmailController.addListener(_onEmailChanged);
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  void _onEmailChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _currentEmailController.removeListener(_onEmailChanged);
    _currentEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isSocialAccount(String email) {
    final lower = email.trim().toLowerCase();
    return lower.endsWith('@gmail.com') ||
        lower.endsWith('@outlook.com') ||
        lower.endsWith('@hotmail.com') ||
        lower.endsWith('@live.com');
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.deleteAccountState != current.deleteAccountState,
      listener: (context, state) {
        if (state.deleteAccountState == RequestState.success) {
          cubit.resetDeleteAccountState();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isSocial = isSocialAccount(_currentEmailController.text);
        final isLoading = state.deleteAccountState == RequestState.loading;

        return Scaffold(
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
                    const SizedBox(height: 60),

                    FieldItem(
                      controller: _currentEmailController,
                      title: 'Enter current Email',
                      type: TextInputType.emailAddress,
                      prefixIcon: Icons.account_circle_outlined,
                      prefixIconColor: const Color(0xFF94A3B8),
                      hintText: 'Enter current email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    FieldItem(
                      controller: _passwordController,
                      title: isSocial ? 'Enter current password (Optional - Social Account)' : 'Enter current password',
                      type: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock_outline,
                      prefixIconColor: const Color(0xFF94A3B8),
                      obscureText: true,
                      hintText: isSocial ? 'Leave empty (social login)' : 'Enter current password',
                      validator: (value) {
                        if (isSocial) return null;
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.deleteCompanyAccount(
                                    email: _currentEmailController.text,
                                    currentPassword: isSocial ? '' : _passwordController.text,
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
                        child: Text(
                          isLoading ? 'Deleting...' : 'Delete',
                          style: const TextStyle(
                            fontFamily: AppFont.interBold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (state.deleteAccountState == RequestState.error &&
                        state.deleteAccountMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        state.deleteAccountMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: AppFont.interBold,
                            fontSize: 16,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
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
