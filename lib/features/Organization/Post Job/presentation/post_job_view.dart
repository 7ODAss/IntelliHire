import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/job_management_cubit/job_management_cubit.dart'; // 🔴 ضفنا الـ Import ده
import 'package:intelli_hire/features/Organization/bottom%20_navigation/controller/bottom_nav_cubit.dart'; // 🔴 ضفنا الـ Import ده
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/custom_pop_button.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_state.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/basic_information_view.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/job_description_view.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/skills_view.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/post_job_stepper.dart';

class PostJobView extends StatelessWidget {
  const PostJobView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔴 بنلف الكود بتاعك بـ Listener عشان الـ Logic فقط
    return BlocListener<PostJobCubit, PostJobState>(
      listener: (context, state) {
        if (state is PostJobSuccess) {
          context.read<JobManagementCubit>().fetchJobs(); // تحديث اللستة
          context.read<BottomNavCubit>().changeIndex(0); // الرجوع للرئيسية
        }
      },
      child: BlocBuilder<PostJobCubit, PostJobState>(
        builder: (context, state) {
          final cubit = context.read<PostJobCubit>();
          return Scaffold(
            // 🟢 ده الكود بتاعك بالظبط بدون أي تغيير في الـ UI
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 55),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomPopButton(
                          onTap: () {
                            cubit.showDiscardDialog(context);
                          },
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cubit.editingJobId != null
                                  ? "Update Job"
                                  : "Post New Job",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColor.darkBlue,
                                fontFamily: AppFont.poppinsBold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PostJobStepper(screenNumber: cubit.activeStep),
                  const SizedBox(height: 32),
                  IndexedStack(
                    index: cubit.activeStep,
                    children: [
                      BasicInformationView(),
                      SkillsView(),
                      JobDescriptionView(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}