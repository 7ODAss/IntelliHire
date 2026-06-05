import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_state.dart';
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormField<String>(
                              validator: (_) {
                                if (cubit.selectedCareerLevel == null ||
                                    cubit.selectedCareerLevel!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                              builder: (field) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDropdownMenu(
                                      title: "Career Level",
                                      hint: "Junior",
                                      items: const [
                                        "Intern",
                                        'Junior',
                                        'Mid-Level',
                                        'Senior',
                                        'Team Lead',
                                      ],
                                      value: cubit.selectedCareerLevel,
                                      onChanged: (val) {
                                        cubit.updateCareerLevel(val);
                                        field.didChange(val);
                                      },
                                    ),
                                    if (field.hasError)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 8,
                                        ),
                                        child: Text(
                                          field.errorText!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Experience (Years)",
                                  style: AppTextStyle.textstyle14.copyWith(
                                    color: AppColor.darkBlue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: cubit.expController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    hintText: 'e.g. 2',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 15,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xffD6D6D6),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColor.primary,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      FormField<String>(
                        validator: (_) {
                          if (cubit.selectedCategoryLabel == null ||
                              cubit.selectedCategoryLabel!.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomDropdownMenu(
                                title: "Category",
                                hint: "Select Category",
                                items: cubit.jobCategories
                                    .map((c) => c['label']!)
                                    .toList(),
                                value: cubit.selectedCategoryLabel,
                                onChanged: (val) {
                                  cubit.updateCategory(val);
                                  field.didChange(val);
                                },
                              ),
                              if (field.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    left: 8,
                                  ),
                                  child: Text(
                                    field.errorText!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      FormField<String>(
                        validator: (_) {
                          if (cubit.selectedSubCategoryLabel == null ||
                              cubit.selectedSubCategoryLabel!.isEmpty) {
                            return 'Please select a subcategory';
                          }
                          return null;
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomDropdownMenu(
                                title: "Subcategory",
                                hint: 'Select Subcategory',
                                items: cubit.getAvailableSubCategoryLabels(),
                                value: cubit.selectedSubCategoryLabel,
                                onChanged: (val) {
                                  cubit.updateSubCategory(val);
                                  field.didChange(val);
                                },
                              ),
                              if (field.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    left: 8,
                                  ),
                                  child: Text(
                                    field.errorText!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      FormField<int>(
                        validator: (_) {
                          if (cubit.selectedJobType == -1) {
                            return 'Please select a job type';
                          }
                          return null;
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Job Type",
                                style: AppTextStyle.textstyle14.copyWith(
                                  color: AppColor.darkBlue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PostJobChoiceChip(
                                    label: 'Full Time',
                                    isSelected: cubit.selectedJobType == 0,
                                    onTap: () {
                                      cubit.updateJobType(0);
                                      field.didChange(0);
                                    },
                                  ),
                                  PostJobChoiceChip(
                                    label: 'Part Time',
                                    isSelected: cubit.selectedJobType == 1,
                                    onTap: () {
                                      cubit.updateJobType(1);
                                      field.didChange(1);
                                    },
                                  ),
                                  PostJobChoiceChip(
                                    label: 'Remote',
                                    isSelected: cubit.selectedJobType == 2,
                                    onTap: () {
                                      cubit.updateJobType(2);
                                      field.didChange(2);
                                    },
                                  ),
                                ],
                              ),
                              // إظهار نص الخطأ لو موجود
                              if (field.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 8,
                                  ),
                                  child: Text(
                                    field.errorText!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          );
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
                        onPressed: () => cubit.showDiscardDialog(context),
                        text: 'Cancel',
                        textColor: AppColor.darkBlue,
                        bgColor: Colors.transparent,
                        borderColor: const Color(0xffD6D6D6),
                      ),
                      const SizedBox(width: 16),
                      PostJobButton(
                        flex: 2,
                        onPressed: () {
                          if (cubit.basicInfoKey.currentState!.validate() &&
                              cubit.validateBasicInfo()) {
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
