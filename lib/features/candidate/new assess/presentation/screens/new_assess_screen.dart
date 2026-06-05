import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/screens/interview_question_screen.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/pop_action_menu.dart';

import '../../../../auth/presentation/login/widget/button_action.dart';
import '../widgets/info_row.dart';
import '../widgets/show_again_check_box.dart';

class NewAssessScreen extends StatelessWidget {
  final String assessmentId;
  final String title;
  final String track;
  const NewAssessScreen({super.key, required this.assessmentId, required this.title, required this.track});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
           return SingleChildScrollView(
             child: ConstrainedBox(
               constraints: BoxConstraints(
                 minHeight: constraints.maxHeight, // بنقوله أقل طول ليك هو طول الشاشة
               ),
               child: IntrinsicHeight(
                 child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PopActionMenu(
                          title: 'Assessment $title',
                          fun: Navigator.of(context).pop,
                        ),
                        const SizedBox(height: 32),
                        Expanded(
                          child: Container(
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
                        InfoRow(
                          icon: Icons.mic_rounded,
                          text: 'Audio questions: record your answer',
                        ),
                        const SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.check_circle_outline_rounded,
                          text: 'MCQ questions: tap the correct option',
                        ),
                        const SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.timer_outlined,
                          text: 'You have 30 minutes to complete the assessment',
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              ShowAgainCheckBox(),
                              const SizedBox(height: 12),
                              ButtonAction(
                                title: 'Start Assessment',
                                style: const TextStyle(
                                  fontFamily: AppFont.interBold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => InterviewQuestionScreen(
                                        assessmentId: 'assess_123',
                                        title: 'Software Engineer',
                                        track: 'Flutter Development',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
               ),
             ),
           );
          } ,
        ),
      ),
    );
  }
}
