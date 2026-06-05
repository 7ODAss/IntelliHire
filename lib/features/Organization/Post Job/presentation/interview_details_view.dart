import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_state.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/post_job_button.dart';

class InterviewDetailsView extends StatelessWidget {
  const InterviewDetailsView({super.key});

  Future<void> _selectDate(BuildContext context, bool isStartDate, PostJobCubit cubit) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); 

    DateTime initial = isStartDate 
        ? (cubit.selectedStartDate ?? today) 
        : (cubit.selectedEndDate ?? cubit.selectedStartDate ?? today);
        
    DateTime first = isStartDate 
        ? today 
        : (cubit.selectedStartDate ?? today);

    if (initial.isBefore(first)) {
      initial = first;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first, 
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColor.primary, 
              onPrimary: Colors.white, 
              surface: AppColor.searchCardItemColor, 
              onSurface: const Color(0xff0F172A), 
            ),
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: AppColor.searchCardItemColor, 
              headerBackgroundColor: AppColor.searchCardItemColor, 
              surfaceTintColor: Colors.transparent, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primary, 
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isStartDate) {
        cubit.updateStartDate(picked);
      } else {
        cubit.updateEndDate(picked);
      }
    }
  }

  Widget _buildDatePicker(BuildContext context, String title, DateTime? selectedDate, VoidCallback onTap) {
    String formattedDate = selectedDate != null
        ? "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}"
        : "Select Date";

    bool isActive = selectedDate != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: isActive ? AppColor.primary.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? AppColor.primary : const Color(0xffD6D6D6),
                width: isActive ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: isActive ? AppColor.primary : Colors.grey.shade500,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Icon(
                  Icons.calendar_month_rounded, 
                  color: isActive ? AppColor.primary : Colors.grey.shade500, 
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInlineCounter(String title, TextEditingController controller, PostJobCubit cubit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff475569),
            ),
          ),
          Container(
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xffF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xffE2E8F0)),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => cubit.decrementCounter(controller),
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                  child: Container(
                    width: 35,
                    alignment: Alignment.center,
                    child: const Icon(Icons.remove, size: 16, color: AppColor.darkBlue),
                  ),
                ),
                Container(
                  width: 40,
                  color: Colors.white,
                  child: TextFormField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 9),
                    ),
                    onChanged: (val) {
                      if (val.isEmpty) {
                        controller.text = '0';
                        controller.selection = const TextSelection.collapsed(offset: 1);
                      } else {
                        int? parsed = int.tryParse(val);
                        if (parsed != null && val != parsed.toString()) {
                          controller.text = parsed.toString();
                          controller.selection = TextSelection.collapsed(offset: controller.text.length);
                        }
                      }
                      cubit.updateCounters();
                    },
                  ),
                ),
                InkWell(
                  onTap: () => cubit.incrementCounter(controller),
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                  child: Container(
                    width: 35,
                    alignment: Alignment.center,
                    child: const Icon(Icons.add, size: 16, color: AppColor.darkBlue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostJobCubit, PostJobState>(
      builder: (context, state) {
        final cubit = context.read<PostJobCubit>();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interview Dates',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFont.interBold,
                        color: AppColor.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildDatePicker(context, "Start Date", cubit.selectedStartDate, () => _selectDate(context, true, cubit))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDatePicker(context, "End Date", cubit.selectedEndDate, () => _selectDate(context, false, cubit))),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    const Text(
                      'Interview Questions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFont.interBold,
                        color: AppColor.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Specify the count for each category. The total sum must be between 7 and 20.',
                      style: TextStyle(
                        fontSize: 12, 
                        color: Color(0xff64748B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildInlineCounter("Coding Questions", cubit.codingCtrl, cubit),
                    _buildInlineCounter("Behavioral Questions", cubit.behavioralCtrl, cubit),
                    _buildInlineCounter("Technical Questions", cubit.technicalCtrl, cubit),
                    _buildInlineCounter("CV Screening Count", cubit.cvCountCtrl, cubit),

                    const SizedBox(height: 16),
                    const Divider(color: Color(0xffEAEDFE), thickness: 1),
                    const SizedBox(height: 16),

                    Builder(
                      builder: (context) {
                        final coding = int.tryParse(cubit.codingCtrl.text) ?? 0;
                        final behav = int.tryParse(cubit.behavioralCtrl.text) ?? 0;
                        final tech = int.tryParse(cubit.technicalCtrl.text) ?? 0;
                        final cv = int.tryParse(cubit.cvCountCtrl.text) ?? 0;
                        final total = coding + behav + tech + cv;
                        final isValid = total >= 7 && total <= 20;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Items Selected',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.darkBlue,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isValid 
                                        ? AppColor.primary.withValues(alpha: 0.08) 
                                        : Colors.red.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$total / 20',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isValid ? AppColor.primary : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (!isValid) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    color: Colors.red,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'The total sum must be between 7 and 20. Currently: $total',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        );
                      }
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
                      onPressed: () => cubit.previousStep(),
                      text: 'Back',
                      textColor: AppColor.darkBlue,
                      bgColor: Colors.transparent,
                      borderColor: const Color(0xffD6D6D6),
                    ),
                    const SizedBox(width: 16),
                   PostJobButton(
                      flex: 2,
                      onPressed: () => cubit.submitJob(context), 
                      text: state is PostJobLoading 
                          ? 'Saving...' 
                          : (cubit.isEditMode ? 'Save Edits' : 'Post Job'),
                      textColor: Colors.white,
                      bgColor: AppColor.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}