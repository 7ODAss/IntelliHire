import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_state.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/post_job_button.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/post_job_text_field.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/skill_chip.dart';

class SkillsView extends StatelessWidget {
  const SkillsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostJobCubit, PostJobState>(
      builder: (context, state) {
        final cubit = context.read<PostJobCubit>();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: cubit.skillsKey,
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
                    border: Border.all(
                      color: const Color(0xffF1F1F1),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Skills',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFont.interBold,
                          color: AppColor.darkBlue,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PostJobTextField(
                              title: "Required Skills",
                              hint: "Type Skill...",
                              controller: cubit.skillController,
                              validator: (value) {
                                String typedSkill = value?.trim() ?? '';
                                if (cubit.addedSkills.isEmpty &&
                                    typedSkill.isEmpty) {
                                  return 'Please add at least one skill';
                                }

                                if (typedSkill.isNotEmpty) {
                                  if (cubit.addedSkills.contains(typedSkill)) {
                                    return 'This skill is already added!';
                                  }
                                  return 'Please press (+) to add skill';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: InkWell(
                              onTap: () {
                                String typedSkill = cubit.skillController.text
                                    .trim();

                                if (typedSkill.isNotEmpty) {
                                  if (cubit.addedSkills.contains(typedSkill)) {
                                    cubit.skillsKey.currentState?.validate();
                                  } else {
                                    cubit.addSkill();
                                    cubit.skillsKey.currentState?.validate();
                                  }
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColor.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (cubit.addedSkills.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: cubit.addedSkills.map((skill) {
                              return SkillChip(
                                label: skill,
                                onDeleted: () => cubit.removeSkill(skill),
                              );
                            }).toList(),
                          ),
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
                        bgColor: Colors.white,
                        borderColor: const Color(0xffD6D6D6),
                      ),

                      const SizedBox(width: 16),
                      PostJobButton(
                        flex: 2,
                        onPressed: () {
                          String typedSkill = cubit.skillController.text.trim();

                          if (typedSkill.isNotEmpty &&
                              cubit.addedSkills.contains(typedSkill)) {
                            cubit.skillController.clear();
                          }

                          bool isFormValid =
                              cubit.skillsKey.currentState?.validate() ?? false;

                          if (isFormValid && cubit.validateSkills()) {
                            cubit.nextStep();
                          }
                        },
                        text: 'Next Step',
                        textColor: Colors.white,
                        bgColor: AppColor.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
