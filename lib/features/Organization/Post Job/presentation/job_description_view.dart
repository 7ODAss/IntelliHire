import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/models/job_model.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/controller/post_job_state.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/job_description_text_field.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/post_job_button.dart';

class JobDescriptionView extends StatelessWidget {
  const JobDescriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostJobCubit, PostJobState>(
      builder: (context, state) {
        final cubit = context.read<PostJobCubit>();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: cubit.jobDescKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      JobDescriptionTextField(
                        title: "Job Description",
                        hint:
                            "Describe the role , responsibilities , and what you are looking for ...",
                        controller: cubit.descController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the job description';
                          }
                          if (value.trim().length < 20) {
                            return 'Description is too short. Please provide more details.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      JobDescriptionTextField(
                        title: "Job Requirements",
                        hint: "List the requirements...",
                        controller: cubit.reqController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the job requirements';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Row(
                    children: [
                      PostJobButton(
                        flex: 1,
                        onPressed: cubit.previousStep,
                        text: 'Back',
                        textColor: AppColor.darkBlue,
                        bgColor: Colors.transparent,
                        borderColor: const Color(0xffD6D6D6),
                      ),
                      const SizedBox(width: 16),
                      PostJobButton(
                        flex: 2,
                        text: cubit.editingJobId != null
                            ? 'Update Job'
                            : 'Post Job Now',
                        textColor: Colors.white,
                        bgColor: AppColor.primary,
                        onPressed: () {
                          if (cubit.validateJobDesc()) {
                            String jobTypeText;
                            switch (cubit.selectedJobType) {
                              case 0:
                                jobTypeText = "Full Time";
                                break;
                              case 1:
                                jobTypeText = "Part Time";
                                break;
                              case 2:
                                jobTypeText = "Remote";
                                break;
                              default:
                                jobTypeText = "Full Time";
                            }

                            final savedJob = JobModel(
                              id:
                                  cubit.editingJobId ??
                                  DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                              title: cubit.titleController.text,
                              location: cubit.selectedLocation ?? "Remote",
                              jobType: jobTypeText,
                              date:
                                  "Posted ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                              candidatesCount: 0,
                              description: cubit.descController.text,
                              requirements: cubit.reqController.text,
                              careerLevel: cubit.selectedCareerLevel,
                              experience: cubit.selectedExperience,
                              skills: List.from(cubit.addedSkills),
                            );

                            if (cubit.editingJobId != null) {
                              context.read<JobManagementCubit>().editJob(
                                savedJob,
                              );
                            } else {
                              context.read<JobManagementCubit>().addJob(
                                savedJob,
                              );
                            }

                            cubit.reset();
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Please fill all required fields!',
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.only(
                                  bottom: 30,
                                  left: 24,
                                  right: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
