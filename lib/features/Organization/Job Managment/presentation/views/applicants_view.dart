import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/core/models/applicant_model.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/appliocants_cubit/applicants_state.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/applicant_card.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/custom_pop_button.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/filter_chip.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ApplicantsScreen extends StatefulWidget {
  final String jobTitle;
  final String jobId;

  const ApplicantsScreen({
    super.key,
    required this.jobTitle,
    required this.jobId,
  });

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  final List<String> filters = const [
    "All",
    "Top Rated",
    "Pending",
    "Accepted",
    "Rejected",
  ];

  @override
  void initState() {
    super.initState();
    context.read<ApplicantsCubit>().fetchApplicantsForJob(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicantsCubit, ApplicantsState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 55),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomPopButton(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Applicants",
                            style: AppTextStyle.textstyle20.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColor.darkBlue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.jobTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.textstyle12.copyWith(
                              color: const Color(0xff475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: filters.map((filter) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CustomChoiceChip(
                        label: filter,
                        isSelected: state.selectedFilter == filter,
                        onTap: () {
                          context.read<ApplicantsCubit>().changeFilter(filter);
                        },
                        onSelected: () {},
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: Builder(
                  builder: (context) {
                    bool isLoading =
                        state is ApplicantsInitial ||
                        state is ApplicantsLoading;

                    if (state.filteredApplicants.isEmpty && !isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_off_outlined,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No applicants ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    int itemCount = isLoading
                        ? 5
                        : state.filteredApplicants.length;

                    return Skeletonizer(
                      enabled: isLoading,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          if (isLoading) {
                            final dummyModel = ApplicantModel.fromJson({
                              "sessionId": "",
                              "name": "                          ",
                              "role": "                  ",
                              "aiScore": 0,
                              "status": "Pending",
                              "experienceYears": 0,
                              "avgResponseTime": 0.0,
                              "accuracyPercent": 0,
                              "strengthPoints": "",
                              "weaknessPoints": "",
                            });
                            // 🔴 بنمرر الـ jobId للكارت الوهمي عشان ميزعلش
                            return ApplicantCard(
                              applicant: dummyModel,
                              jobId: widget.jobId,
                            );
                          }

                          final applicantEntity =
                              state.filteredApplicants[index];

                          final applicantModel = ApplicantModel.fromJson({
                            "sessionId": applicantEntity.sessionId,
                            "name": applicantEntity.fullName,
                            "role":
                                (applicantEntity.currentRole != null &&
                                    applicantEntity.currentRole!.isNotEmpty)
                                ? applicantEntity.currentRole
                                : "Candidate",
                            "aiScore": (applicantEntity.overallScore ?? 0)
                                .round()
                                .toInt(),
                            "status": applicantEntity.status ?? "Pending",
                            "experienceYears": 0,
                            "avgResponseTime": 0.0,
                            "accuracyPercent":
                                (applicantEntity.overallScore ?? 0),
                            "strengthPoints": "",
                            "weaknessPoints": "",
                          });

                          return ApplicantCard(
                            applicant: applicantModel,
                            jobId: widget.jobId,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
