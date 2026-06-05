import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/job_management_cubit/job_management_state.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/job_card.dart';

class JobManagementView extends StatelessWidget {
  const JobManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<JobManagementCubit>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              "Job Management",
              style: AppTextStyle.textstyle20.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColor.darkBlue,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
              child: TextField(
                onChanged: (value) => cubit.searchJobs(value),
                decoration: InputDecoration(
                  hintText: "Search your jobs...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xff898989),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: BlocConsumer<JobManagementCubit, JobManagementState>(
                listener: (context, state) {
                  if (state is JobDeletedSuccess) {
                    // Handle success if needed
                  } else if (state is JobManagementError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  bool isLoading =
                      state is JobManagementInitial || state is JobManagementLoading;
                  List<JobItemEntity> displayJobs = [];

                  if (state is JobManagementLoaded) {
                    displayJobs = state.data.jobs;
                  } else if (cubit.originalData != null) {
                    displayJobs = cubit.originalData!.jobs;
                  }

                  bool shouldShowSkeleton = isLoading && displayJobs.isEmpty;
                  
                  int itemCount = shouldShowSkeleton
                      ? 5
                      : (displayJobs.isEmpty ? 1 : displayJobs.length);

                  return Skeletonizer(
                    enabled: shouldShowSkeleton,
                    child: RefreshIndicator(
                      onRefresh: () async => cubit.fetchJobs(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          if (shouldShowSkeleton) {
                            return JobCard(
                              job: JobItemEntity(
                                id: '',
                                title: '                          ',
                                type: '       ',
                                location: '                  ',
                                postedAt: '           ',
                                applicantsCount: 0,
                              ),
                            );
                          }

                          if (displayJobs.isEmpty) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/image/icon svg/suitcase.svg",
                                    height: 50,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0XFFD6D6D6),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "No jobs found.",
                                    style: TextStyle(
                                      color: Color(0XFFAFAFAF),
                                      fontSize: 16,
                                      fontFamily: AppFont.interRegular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return JobCard(job: displayJobs[index]);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}