import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/core/utils/shared/get_initials.dart';
import 'package:intelli_hire/features/candidate/bottom%20_navigation/controller/bottom_nav_candidate_cubit.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/career_option.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/presentation/widgets/candidate_error_widget.dart'; // 🌟 الـ import الجديد للـ Error Widget

import '../../../../core/enums/request.dart';
import '../../../../core/service/service_locator.dart';
import '../../../Organization/Profile/presentation/widgets/custom_log_out_button.dart';
import '../../../auth/presentation/login/login_screen.dart';
import 'controller/candidate_profile_cubit.dart';
import 'widgets/accountoption.dart';
import 'widgets/pop_action_menu.dart';

class ProfileScreenCandidate extends StatelessWidget {
  final String name = 'test name';
  final String email = 'test@gmail.com';

  const ProfileScreenCandidate({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => getIt<CandidateProfileCubit>()..loadProfile(),
        child: BlocBuilder<CandidateProfileCubit, CandidateProfileState>(
          buildWhen: (previous, current) {
            // 🌟 إعادة البناء فقط لو الـ status اتغيرت أو الداتا الحقيقية جوه الموديل اتحدثت
            return previous.status != current.status ||
                previous.candidateProfileModel != current.candidateProfileModel;
          },
          builder: (context, state) {
            final cubit = context.read<CandidateProfileCubit>();

            // 🌟 تطبيق الـ switch-case بالمللي زي الـ HomeScreen لمعالجة انقطاع الإنترنت
            switch (state.status) {
              case RequestState.error:
                return Scaffold(
                  body: RefreshIndicator(
                    onRefresh: () async => cubit.loadProfile(),
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            children: [
                              PopActionMenu(
                                title: 'Account Profile',
                                fun: context
                                    .read<BottomNavCandidateCubit>()
                                    .goBackToPrevious,
                              ),
                              Expanded(
                                child: Center(
                                  child: CandidateErrorWidget(
                                    message: state.candidateProfileMessage,
                                    onRetry: () => cubit.loadProfile(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              case RequestState.initial:
              case RequestState.loading:
              case RequestState.success:
                final photoUrl = state.candidateProfileModel?.photo;
                final hasPhoto = photoUrl != null && photoUrl.trim().isNotEmpty;

                return Scaffold(
                  body: RefreshIndicator(
                    onRefresh: () async => cubit.loadProfile(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                                          color:
                                              AppColor.iconProfileBorderColor,
                                          width: 1.5,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: hasPhoto
                                          ? CachedNetworkImage(
                                              imageUrl: photoUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                    child: SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (
                                                    context,
                                                    url,
                                                    error,
                                                  ) => Center(
                                                    child: Text(
                                                      GetInitials.getInitials(
                                                        state
                                                                .candidateProfileModel
                                                                ?.fullName ??
                                                            name,
                                                      ),
                                                      style: AppTextStyle
                                                          .iconNamePostScreen,
                                                    ),
                                                  ),
                                            )
                                          : Center(
                                              child: Text(
                                                GetInitials.getInitials(
                                                  state
                                                          .candidateProfileModel
                                                          ?.fullName ??
                                                      name,
                                                ),
                                                style: AppTextStyle
                                                    .iconNamePostScreen,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      state.candidateProfileModel?.fullName ??
                                          name,
                                      style: AppTextStyle.accountNamePostScreen,
                                    ),
                                    Text(
                                      state.candidateProfileModel?.email ??
                                          email,
                                      style:
                                          AppTextStyle.accountSubNamePostScreen,
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
                            BlocListener<
                              CandidateProfileCubit,
                              CandidateProfileState
                            >(
                              listener: (context, state) {
                                if (state.userProfileCandidateLogOutState ==
                                    RequestState.success) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              child: CustomLogOutButton(
                                onPressed: cubit.logout,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
