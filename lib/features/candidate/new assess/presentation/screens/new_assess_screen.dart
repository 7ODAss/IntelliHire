import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/controller/assessment_session_cubit.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/screens/interview_question_screen.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_color.dart';

class NewAssessScreen extends StatelessWidget {
  const NewAssessScreen({super.key});

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
          'New Assessment',
          style: TextStyle(
            fontFamily: AppFont.interBold,
            fontSize: 17,
            color: Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(48),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 52,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ready to Start?',
              style: TextStyle(
                fontFamily: AppFont.poppinsBold,
                fontSize: 24,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'You will be asked a series of questions. Some require audio answers — speak clearly into your microphone. Others are multiple choice.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFont.interRegular,
                fontSize: 15,
                color: Color(0xFF64748B),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            _infoRow(Icons.mic_rounded, 'Audio questions: record your answer'),
            const SizedBox(height: 12),
            _infoRow(
              Icons.check_circle_outline_rounded,
              'MCQ questions: tap the correct option',
            ),
            const SizedBox(height: 12),
            _infoRow(Icons.timer_outlined, 'No time limit — take your time'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => getIt<AssessmentSessionCubit>(),
                        child: const InterviewQuestionScreen(
                          assessmentId: 'new_assessment',
                        ),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Start Assessment',
                  style: TextStyle(
                    fontFamily: AppFont.interBold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColor.primary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: AppFont.interRegular,
              fontSize: 14,
              color: Color(0xFF334155),
            ),
          ),
        ),
      ],
    );
  }
}
