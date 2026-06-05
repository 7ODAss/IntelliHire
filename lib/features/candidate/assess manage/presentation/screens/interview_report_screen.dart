import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/performance_report.dart';
import '../controller/assess_manage_cubit.dart';
import '../widgets/question_result_card.dart';

class InterviewReportScreen extends StatelessWidget {
  final PerformanceReport report;

  const InterviewReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Interview Report',
          style: TextStyle(
            fontFamily: AppFont.interBold,
            fontSize: 18,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: report.questions.length,
          itemBuilder: (context, index) {
            // 🌟 بنستخدم BlocSelector عشان الكارت ده بس اللي يتعمله Rebuild لما حالته تتغير
            return BlocSelector<AssessManageCubit, AssessManageState, bool>(
              selector: (state) => state.expandedQuestions.contains(index),
              builder: (context, isExpanded) {
                return QuestionResultCard(
                  result: report.questions[index],
                  questionNumber: index + 1,
                  isExpanded: isExpanded,
                  onTap: () {
                    // بننادي على الفانكشن من الكيوبت عشان تغير الـ State
                    context.read<AssessManageCubit>().toggleExpansion(index);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

