import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/login_page.dart';

import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/shared/auth_layout.dart';
import '../../controller/login_cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // lib/features/auth/presentation/login/login_screen.dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthLayout(
        headerContent: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/login/logo.svg', height: 60),
            const SizedBox(height: 16),
            Text('Welcome back to IntelliHire', style: AppTextStyle.loginTitleStyle),
            const SizedBox(height: 8),
            Text('Step into the future of hiring', style: AppTextStyle.loginSubTitleStyle),
          ],
        ),
        bodyContent: BlocProvider(
          create: (context) => LoginCubit(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [LogInPage(), const SizedBox(height: 100)],
          ),
        ),
      ),
    );
  }
}