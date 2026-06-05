import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/Organization/Profile/presentation/widgets/company_profile_header.dart';
import 'package:intelli_hire/features/Organization/Profile/presentation/widgets/custom_log_out_button.dart';
import '../../../../core/enums/request.dart';
import '../../../auth/presentation/login/login_screen.dart';
import '../../bottom _navigation/controller/bottom_nav_cubit.dart';
import 'controller/profile_cubit.dart';
import 'widgets/accountoption.dart';
import 'widgets/security_privacy.dart';
import 'widgets/pop_action_menu.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().getCompanyAccountDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.getCompanyAccountState == RequestState.loading && state.companyAccount == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final displayName = state.companyAccount?.name.isNotEmpty == true 
                ? state.companyAccount!.name 
                : 'Tech Corp Inc.';
            final displayEmail = state.companyAccount?.email.isNotEmpty == true 
                ? state.companyAccount!.email 
                : 'techcorp@business.com';
            final displayPhoto = state.companyAccount?.photo;

            return SingleChildScrollView(
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
                    CompanyProfileHeader(
                      name: displayName,
                      email: displayEmail,
                      imageUrl: displayPhoto,
                    ),
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
            );
          },
        ),
      ),
    );
  }
}
