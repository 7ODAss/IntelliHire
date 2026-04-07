import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_font.dart';

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
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
                    borderRadius: BorderRadius.circular(18),
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
                    fontFamily: AppFont.interBold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 36), // balance
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF3B82F6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
