import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/shared/liquid_glass_custom_pop_button.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/widgets/pulse_timer_badge.dart';

import '../../../../../core/utils/app_color.dart';
import '../controller/assessment_session_cubit.dart';

class QuestionProgressHeader extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final VoidCallback onClose;

  const QuestionProgressHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalQuestions > 0
        ? currentQuestion / totalQuestions
        : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              LiquidGlassCustomPopButton(onTap: onClose,),
              Expanded(
                child: Text(
                  'Question $currentQuestion of $totalQuestions',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppFont.poppinsMedium,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 36), // balance
            ],
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF134CC7),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          BlocSelector<AssessmentSessionCubit, AssessmentSessionState, int>(
            selector: (state) => state.remainingTimeInSeconds ?? 1800,
            builder: (context, remainingTime) {
             return PulseTimerBadge(remainingTime: remainingTime);
            },
          ),
        ],
      ),
    );
  }
}
