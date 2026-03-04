import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/custom_pop_button.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/controller/post_job_state.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/basic_information_view.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/job_description_view.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/skills_view.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/post_job_stepper.dart';

class PostJobView extends StatelessWidget {
  const PostJobView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostJobCubit, PostJobState>(
      builder: (context, state) {
        final cubit = context.read<PostJobCubit>();
        return Scaffold(
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
                            "Post New Job",
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
    );
  }
}
