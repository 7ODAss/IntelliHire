import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/widgets/pulse_timer_badge.dart';

class QuestionProgressHeader extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final VoidCallback onClose;
  final Stream<int>? timerStream;
  final int initialRemainingTime;

  const QuestionProgressHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.onClose,
    this.timerStream,
    this.initialRemainingTime = 600,
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
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
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
          timerStream != null
              ? StreamBuilder<int>(
                  stream: timerStream,
                  initialData: initialRemainingTime,
                  builder: (context, snapshot) {
                    return PulseTimerBadge(
                      remainingTime: snapshot.data ?? initialRemainingTime,
                    );
                  },
                )
              : PulseTimerBadge(remainingTime: initialRemainingTime),
        ],
      ),
    );
  }
}
