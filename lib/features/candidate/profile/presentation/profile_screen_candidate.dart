import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/core/utils/shared/get_initials.dart';
import 'package:intelli_hire/features/candidate/bottom%20_navigation/controller/bottom_nav_candidate_cubit.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/career_option.dart';

import '../../../../core/enums/request.dart';
import '../../../../core/service/service_locator.dart';
import '../../../Organization/Profile/presentation/widgets/custom_log_out_button.dart';
import '../../../auth/presentation/login/login_screen.dart';
import 'controller/candidate_profile_cubit.dart';
import 'widgets/accountoption.dart';
import 'widgets/pop_action_menu.dart';

class ProfileScreenCandidate extends StatelessWidget {
  final String name = 'mahmoudmagdy';
  final String email = 'mahmoudmagdy1443@gmail.com';

  const ProfileScreenCandidate({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => getIt<CandidateProfileCubit>()..loadProfile(),
        child: BlocBuilder<CandidateProfileCubit, CandidateProfileState>(
          builder: (context, state) {
            final cubit = context.read<CandidateProfileCubit>();
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PopActionMenu(
                        title: 'Account Profile',
                        fun: context
                            .read<BottomNavCandidateCubit>()
                            .goBackToPrevious,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Spacer(),
                          Column(
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: AppColor.iconProfileColor,
                                  border: Border.all(
                                    color: AppColor.iconProfileBorderColor,
                                    width: 1.5,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child:
                                (cubit.state.candidateProfileModel?.photo != null && cubit.state.candidateProfileModel!.photo.isNotEmpty)
                                    ? Image.memory(
                                        base64Decode(cubit.state.candidateProfileModel!.photo),
                                        fit: BoxFit.cover,
                                      )
                                    : Center(
                                        child: Text(
                                          //GetInitials.getInitials(cubit.state.candidateProfileModel?.fullName ?? name),
                                          GetInitials.getInitials(name),
                                          style:
                                              AppTextStyle.iconNamePostScreen,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                //cubit.state.candidateProfileModel?.fullName ?? name,
                                name,
                                style: AppTextStyle.accountNamePostScreen,
                              ),
                              Text(
                                //cubit.state.candidateProfileModel?.email ?? email,
                                email,
                                style: AppTextStyle.accountSubNamePostScreen,
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 32),

                      AccountOption(cubit: cubit),

                      const SizedBox(height: 24),
                      CareerOption(cubit: cubit),
                      const SizedBox(height: 48),
                      BlocListener<CandidateProfileCubit, CandidateProfileState>(
                        listener: (context, state) {
                          if (state.userProfileCandidateLogOutState == RequestState.success) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        child: CustomLogOutButton(onPressed: cubit.logout),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
