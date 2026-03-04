import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/models/job_model.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/applicants_view.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/custom_popup_menu.dart';

class JobCard extends StatelessWidget {
  const JobCard({
    super.key, required this.job,
    
  });
final JobModel job;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (newContext) => BlocProvider.value(
              value: context.read<ApplicantsCubit>(),
              child: const ApplicantsScreen(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xff898989),
              spreadRadius: 0,
              blurRadius: 6.3,
              offset: const Offset(0, 3),
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
                Expanded(child: Text(job.title, style: AppTextStyle.textstyle16)),

                CustomPopupMenu(job: job,),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              "${job.location} • ${job.date}",
              style: AppTextStyle.textstyle12.copyWith(
                color: Color(0xff475569),
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
                    color: Color(0x4DB9C2FD),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    job.jobType,
                    style: AppTextStyle.textstyle12.copyWith(
                      color: AppColor.primary,
                    ),
                  ),
                ),

                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 18,
                      color: const Color(0xFF082F82),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${job.candidatesCount} Candidate",
                      style: AppTextStyle.textstyle12.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475569),
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
