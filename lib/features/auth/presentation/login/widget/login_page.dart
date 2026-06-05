import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';
import 'package:intelli_hire/features/auth/controller/login_cubit/login_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/remember_me.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/social_buttons.dart';
import 'package:intelli_hire/features/auth/controller/external%20login/external_login_cubit.dart';
import 'package:intelli_hire/features/auth/controller/external%20login/external_login_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate Signup/views/account_setup_view.dart';
import 'package:intelli_hire/features/Organization/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/sign_up_process.dart';
import 'package:intelli_hire/features/candidate/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper_candidate.dart';
import 'package:intelli_hire/features/auth/controller/sign_up_cubit/sign_up_cubit.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_cubit.dart';

import '../../../../../core/enums/snack_bar_type.dart';
import '../../../../onboarding/presentation/landing_screen.dart';
import '../../signup/company/widget/navigator_to_account.dart';
import 'field_item.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

enum UserType { candidate, company }

class _LogInPageState extends State<LogInPage> {
  UserType selectedType = UserType.candidate; // الافتراضي مترشح
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // دالة بناء الـ Tab الاحترافي
  Widget _buildTabItem({required String title, required UserType type}) {
    bool isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = type),
        child: Container(
          margin: const EdgeInsets.all(4),
          height: 42,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF0F172A)
                  : const Color(0xFFAFAFAF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // 1. المستمع الأول: الخاص بتسجيل الدخول بجوجل (External Login)
        BlocListener<ExternalLoginCubit, ExternalLoginState>(
          listener: (context, state) {
            if (state is ExternalLoginSuccess) {
              Future.delayed(Duration.zero, () {
                final bool isCompany = state.userType == 'Company' || state.userType == 'company';
                if (isCompany) {
                  if (state.isProfileComplete) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CustomBottomNavBarWrapper(),
                      ),
                      (route) => false,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => SignUpCubit(),
                          child: const SignUpProcess(),
                        ),
                      ),
                      (route) => false,
                    );
                  }
                } else {
                  if (state.isProfileComplete) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CustomBottomNavBarWrapperCandidate(),
                      ),
                      (route) => false,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => ProfileSetupCubit(
                            getIt(),
                            userToken: state.token,
                          ),
                          child: const AccountSetupView(),
                        ),
                      ),
                      (route) => false,
                    );
                  }
                }
              });
            } else if (state is ExternalLoginFailure) {
              context.showSnackBar(state.error, type: SnackBarType.error);
            }
          },
        ),

        // 🌟 2. المستمع التاني: الخاص بتسجيل الدخول العادي (تم تعديله لمنع الدخول ببروفايل ناقص)
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.loginState == RequestState.success) {
              // 🔴 جلب حالة اكتمال البروفايل ونوع الحساب من استجابة السيرفر تلقائياً
              final bool isProfileComplete = state.loginModel?.isProfileComplete ?? true;
              final String userType = state.loginModel?.userType ?? '';
              final bool isCompany = userType == 'Company' || userType == 'company';

              if (isProfileComplete) {
                // ✅ البروفايل كامل -> التوجيه لـ Home حسب نوع الحساب الحقيقي
                if (isCompany) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomBottomNavBarWrapper(),
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomBottomNavBarWrapperCandidate(),
                    ),
                    (route) => false,
                  );
                }
              } else {
                // ❌ البروفايل ناقص -> التوجيه لشاشات إكمال البيانات حسب نوع الحساب الحقيقي
                if (isCompany) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => SignUpCubit(),
                        child: const SignUpProcess(),
                      ),
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => ProfileSetupCubit(
                          getIt(),
                          userToken: state.loginModel!.token,
                        ),
                        child: const AccountSetupView(),
                      ),
                    ),
                    (route) => false,
                  );
                }
              }
            } else if (state.loginState == RequestState.error) {
              context.showSnackBar(
                state.loginMessage,
                type: SnackBarType.error,
              );
            }
          },
        ),
      ],
      // 🌟 BlocBuilder عشان نحدث الشاشة لو بيحمل (Loading)
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, loginState) {
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // الـ Tab الاحترافي
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          _buildTabItem(
                            title: "Candidate",
                            type: UserType.candidate,
                          ),
                          _buildTabItem(
                            title: "Company",
                            type: UserType.company,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    FieldItem(
                      controller: emailController,
                      title: "Email",
                      message: "Enter Email",
                      type: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    FieldItem(
                      controller: passwordController,
                      title: "Password",
                      message: "Enter Password",
                      type: TextInputType.visiblePassword,
                      obscureText: true,
                    ),

                    const SizedBox(height: 16),
                    const RememberMe(),
                    const SizedBox(height: 16),

                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xFF9CA3AF),
                            thickness: 1.5,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "OR CONTINUE WITH",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFF9CA3AF),
                            thickness: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // زرار تسجيل الدخول
                    loginState.loginState == RequestState.loading
                        ? const Center(child: CircularProgressIndicator())
                        : ButtonAction(
                            title: "Log In",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<LoginCubit>().login(
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                  rememberMe: true,
                                );
                              }
                            },
                          ),

                    const SizedBox(height: 20),
                    // إرسال '0' أو '1'
                    SocialButtons(
                      type: selectedType == UserType.candidate ? '0' : '1',
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: NavigatorToAccount(
                        text: 'Don\'t have account?',
                        actionText: ' Sign Up',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LandingScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}