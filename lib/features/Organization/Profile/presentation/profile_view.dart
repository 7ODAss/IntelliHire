import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Profile/presentation/widgets/company_profile_header.dart';
import 'package:intelli_hire/features/Organization/Profile/presentation/widgets/custom_log_out_button.dart';
import '../../../../core/enums/request.dart';
import '../../../../core/utils/shared/get_initials.dart';
import '../../../auth/presentation/login/login_screen.dart';
import '../../bottom _navigation/controller/bottom_nav_cubit.dart';
import 'controller/profile_cubit.dart';
import 'widgets/accountoption.dart';
import 'widgets/security_privacy.dart';
import 'widgets/pop_action_menu.dart';

class ProfileView extends StatelessWidget {
  final String name = 'Tech Corp Inc.';
  final String email = 'techcorp@business.com';

  const ProfileView({super.key});


  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PopActionMenu(
                  title: 'Account Profile',
                  fun: context
                      .read<BottomNavCubit>()
                      .goBackToPrevious,
                ),
                const SizedBox(height: 16),
                CompanyProfileHeader(name: name, email: email,),
                const SizedBox(height: 32),
                AccountOption(),
                const SizedBox(height: 24),
                SecurityPrivacy(),
                const SizedBox(height: 48),
                BlocListener<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state.userProfileLogOutState == RequestState.success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  child: CustomLogOutButton(onPressed: cubit.logout,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
