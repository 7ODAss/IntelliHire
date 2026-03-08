import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/job_card.dart';

class JobManagementView extends StatelessWidget {
  const JobManagementView({super.key});

  @override
  Widget build(BuildContext context) {
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

            const SizedBox(height: 24),

            Expanded(
              child: BlocBuilder<JobManagementCubit, JobManagementState>(
                builder: (context, state) {
                  if (state is JobManagementInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is JobManagementLoaded) {
                    final jobs = state.jobsList;

                    if (jobs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "assets/image/bottom nav icon svg/suitcase.svg",
                              height: 50,

                              colorFilter: const ColorFilter.mode(
                                Color(0XFFD6D6D6),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                "No jobs posted yet.",
                                style: TextStyle(
                                  color: Color(0XFFAFAFAF),
                                  fontSize: 16,
                                  fontFamily: AppFont.interRegular,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search your jobs...",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
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
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: jobs.length,
                            itemBuilder: (context, index) {
                              final job = jobs[index];

                              return JobCard(job: job,
                               
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
