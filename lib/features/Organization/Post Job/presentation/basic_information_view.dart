import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/controller/post_job_state.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/custom_dropdown_menu.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/post_job_button.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/post_job_choice_chip.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/post_job_text_field.dart';

class BasicInformationView extends StatelessWidget {
  const BasicInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostJobCubit, PostJobState>(
      builder: (context, state) {
        final cubit = context.read<PostJobCubit>();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: cubit.basicInfoKey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFont.interBold,
                          color: AppColor.darkBlue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PostJobTextField(
                        title: 'Job Title',
                        hint: 'e.g. Junior React Developer',
                        controller: cubit.titleController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a job title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownMenu(
                              title: "Career Level",
                              hint: "Junior",
                              items: const [
                                'Junior',
                                'Mid-Level',
                                'Senior',
                                'Team Lead',
                              ],
                              value: cubit.selectedCareerLevel,
                              onChanged: (val) => cubit.updateCareerLevel(val),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomDropdownMenu(
                              title: "Experience",
                              hint: '0 to 1 Years',
                              items: const [
                                "0 to 1 Years",
                                "1 to 3 Years",
                                "3 to 5 Years",
                                "+5 Years",
                              ],
                              value: cubit.selectedExperience,
                              onChanged: (val) => cubit.updateExperience(val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Job Type'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PostJobChoiceChip(
                            label: 'Full Time',
                            isSelected: cubit.selectedJobType == 0,
                            onTap: () {
                              cubit.updateJobType(0);
                            },
                          ),
                          PostJobChoiceChip(
                            label: 'Part Time',
                            isSelected: cubit.selectedJobType == 1,
                            onTap: () {
                              cubit.updateJobType(1);
                            },
                          ),
                          PostJobChoiceChip(
                            label: 'Remote',
                            isSelected: cubit.selectedJobType == 2,
                            onTap: () {
                              cubit.updateJobType(2);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomDropdownMenu(
                        title: "Location",
                        hint: 'Select Location',
                        items: const [
                          "Building 4 , Street 9 , Maadi ,Egypt , Red Sea",
                          "Building 4 , Street 9 , Maadi ,Egypt , Cairo",
                        ],
                        value: cubit.selectedLocation,
                        onChanged: (val) => cubit.updateLocation(val),
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
                        onPressed: () {
                          cubit.showDiscardDialog(context);
                        },
                        text: 'Cancel',
                        textColor: AppColor.darkBlue,
                        bgColor: Colors.transparent,
                        borderColor: Color(0xffD6D6D6),
                      ),

                      const SizedBox(width: 16),
                      PostJobButton(
                        flex: 2,
                        onPressed: () {
                          if (cubit.validateBasicInfo()) {
                            cubit.nextStep();
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
                        text: 'Next Step',
                        textColor: Colors.white,
                        bgColor: AppColor.primary,
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
