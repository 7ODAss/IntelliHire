import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_font.dart';
import '../../domain/entities/question_result.dart';
import 'answer_bubble.dart';

class QuestionResultCard extends StatelessWidget {
  final QuestionResult result;
  final int questionNumber;
  final bool isExpanded;
  final VoidCallback onTap;

  const QuestionResultCard({
    super.key,
    required this.result,
    required this.questionNumber,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded
                ? AppColor.primary.withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Q$questionNumber',
                  style: const TextStyle(
                    fontFamily: AppFont.interBold,
                    fontSize: 16,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.questionText,
                    style: const TextStyle(
                      fontFamily: AppFont.interBold,
                      fontSize: 16,
                      color: Color(0xFF0F172A),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDAE3FF),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColor.primary,
                    size: 25,
                  ),
                ),
              ),
            ),
            // 🌟 الجزء المتحرك (بيظهر ويختفي بـ Animation)
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity, height: 0),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10), // مسافة من فوق
                child: IntrinsicHeight(
                  // 🌟 السر الأول: بيخلي الـ Row ياخد ارتفاع أطول حاجة جواه
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // 🌟 السر التاني: بيخلي عمود الـ Timeline يتمط لآخر الـ Row
                    children: [
                      // 1. عامود الـ Timeline
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFFCBD5E1),
                              shape: BoxShape.circle,
                            ),
                          ),

                          Expanded(
                            child: Container(
                              width: 2,
                              color: const Color(0xFFE2E8F0),
                            ),
                          ),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: AppColor.primary,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // مسافة بين الـ Timeline والإجابات
                      // 2. عامود الإجابات
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Answer (Transcribed)',
                              style: TextStyle(
                                fontFamily: AppFont.interRegular,
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnswerBubble(
                              text: result.userAnswer,
                              isCandidate: true,
                            ),
                            const SizedBox(height: 24), // مسافة بين الإجابتين
                            const Text(
                              'Ideal AI Answer',
                              style: TextStyle(
                                fontFamily: AppFont.interRegular,
                                fontSize: 12,
                                color: AppColor.primary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnswerBubble(
                              text: result.idealAnswer,
                              isCandidate: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }
}