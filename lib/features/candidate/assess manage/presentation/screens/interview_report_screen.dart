import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/performance_report.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/question_result.dart';

class InterviewReportScreen extends StatelessWidget {
  final PerformanceReport report;

  const InterviewReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'AI Interview Report',
          style: TextStyle(
            fontFamily: AppFont.poppinsBold,
            fontSize: 18,
            color: Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: report.results.length,
        itemBuilder: (context, index) {
          return _QuestionResultCard(
            result: report.results[index],
            questionNumber: index + 1,
          );
        },
      ),
    );
  }
}

class _QuestionResultCard extends StatelessWidget {
  final QuestionResult result;
  final int questionNumber;

  const _QuestionResultCard({
    required this.result,
    required this.questionNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Q$questionNumber',
              style: const TextStyle(
                fontFamily: AppFont.interBold,
                fontSize: 12,
                color: AppColor.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.questionText,
            style: const TextStyle(
              fontFamily: AppFont.interBold,
              fontSize: 14,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),

          // Transcribed answer
          const _BubbleLabel(
            label: 'Your Answer (Transcribed)',
            isCandidate: true,
          ),
          const SizedBox(height: 6),
          _AnswerBubble(text: result.transcribedAnswer, isCandidate: true),
          const SizedBox(height: 12),

          // Ideal answer
          const _BubbleLabel(label: 'Ideal AI Answer', isCandidate: false),
          const SizedBox(height: 6),
          _AnswerBubble(text: result.idealAnswer, isCandidate: false),
        ],
      ),
    );
  }
}

class _BubbleLabel extends StatelessWidget {
  final String label;
  final bool isCandidate;

  const _BubbleLabel({required this.label, required this.isCandidate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCandidate ? const Color(0xFF94A3B8) : AppColor.primary,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFont.interRegular,
            fontSize: 11,
            color: isCandidate ? const Color(0xFF94A3B8) : AppColor.primary,
          ),
        ),
      ],
    );
  }
}

class _AnswerBubble extends StatelessWidget {
  final String text;
  final bool isCandidate;

  const _AnswerBubble({required this.text, required this.isCandidate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCandidate ? const Color(0xFFF1F5F9) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCandidate
              ? const Color(0xFFE2E8F0)
              : const Color(0xFFBFDBFE),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppFont.interRegular,
          fontSize: 13,
          color: isCandidate
              ? const Color(0xFF334155)
              : const Color(0xFF1E40AF),
          height: 1.5,
        ),
      ),
    );
  }
}
