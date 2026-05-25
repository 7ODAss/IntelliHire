import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/applicants_view.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/custom_popup_menu.dart';

class JobCard extends StatelessWidget {
  const JobCard({
    super.key,
    required this.job, // 🔴 بنستقبل job
  });

  // 🔴 التعديل هنا: غيرنا النوع من JobModel لـ JobItemEntity
  final JobItemEntity job;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ApplicantsCubit>().fetchApplicantsForJob(job.id);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (newContext) => BlocProvider.value(
              value: context.read<ApplicantsCubit>(),
              child: ApplicantsScreen(jobTitle: job.title, jobId: job.id),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            // ضفت const للـ box shadow
            BoxShadow(
              color: Color(0xff898989),
              spreadRadius: 0,
              blurRadius: 6.3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(job.title, style: AppTextStyle.textstyle16),
                ),
                CustomPopupMenu(job: job),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              "${job.location ?? 'Remote'} • ${job.postedAt}",
              style: AppTextStyle.textstyle12.copyWith(
                color: const Color(0xff475569),
              ),
            ),

            const SizedBox(height: 10),

            Divider(color: Colors.grey.shade300, height: 1),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x4DB9C2FD),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    // 🔴 عدلنا job.jobType لـ job.type حسب الـ Entity
                    job.type,
                    style: AppTextStyle.textstyle12.copyWith(
                      color: AppColor.primary,
                    ),
                  ),
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.people,
                      size: 18,
                      color: Color(0xFF082F82),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      // 🔴 عدلنا candidatesCount لـ applicantsCount حسب الـ Entity
                      "${job.applicantsCount} Candidate",
                      style: AppTextStyle.textstyle12.copyWith(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
