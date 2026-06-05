import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Home/domain/entities/home_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/widget/stauts_box.dart';

// 🔴 Imports الجديدة التي نحتاجها للتنقل لصفحة Applicants وصفحة Edit
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/applicants_view.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/post_job_view.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/controller/bottom_nav_cubit.dart';

class CurrentJobCard extends StatelessWidget {
  final DashboardJobEntity job;

  const CurrentJobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8D5D6), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFont.interBold,
                        color: AppColor.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 18,
                          color: Color(0XFF475569),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          job.postedAt,
                          style: AppTextStyle.textstyle12.copyWith(
                            color: const Color(0XFF475569),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF101828),
                  size: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFFEAECF0), width: 1),
                ),
                color: Colors.white,
                elevation: 8,
                offset: const Offset(-17, 35),
                constraints: const BoxConstraints(minWidth: 55, maxWidth: 55),
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == 'team') {
                    context.read<ApplicantsCubit>().fetchApplicantsForJob(
                      job.id,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (newContext) => BlocProvider.value(
                          value: context.read<ApplicantsCubit>(),
                          child: ApplicantsScreen(
                            jobTitle: job.title,
                            jobId: job.id,
                          ),
                        ),
                      ),
                    );
                  } else if (value == 'edit') {
                    context.read<PostJobCubit>().fetchAndLoadJobForEdit(job.id);
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (newContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<PostJobCubit>(),
                            ),
                            BlocProvider.value(
                              value: context.read<JobManagementCubit>(),
                            ),
                            BlocProvider.value(
                              value: context.read<BottomNavCubit>(),
                            ),
                          ],
                          child: const PostJobView(),
                        ),
                      ),
                    );
                  } else if (value == 'delete') {
                    context.read<JobManagementCubit>().deleteJob(job.id);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'team',
                    height: 30,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Icon(
                        Icons.people_alt,
                        color: Color(0xFF1877F2),
                        size: 20,
                      ),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'edit',
                    height: 30,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.penToSquare,
                        color: Color(0xFF475467),
                        size: 17,
                      ),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    height: 30,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.trashCan,
                        color: Color(0xFFF04438),
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: StautsBox(
                  iconpath: "assets/image/icon svg/Dropped.svg",
                  label: "Rejected",
                  count: job.rejectedCount,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StautsBox(
                  iconpath: "assets/image/icon svg/Completed.svg",
                  label: "Accepted",
                  count: job.acceptedCount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
