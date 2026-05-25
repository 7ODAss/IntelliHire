import 'package:flutter/material.dart';
import '../../../../../core/utils/app_font.dart';
import '../../domain/entities/interview_summary.dart';
import 'center_interview_card.dart';
import 'corner_interview_card.dart';

class InterviewsSummarySection extends StatelessWidget {
  final InterviewSummary interviews;
  const InterviewsSummarySection({super.key,required this.interviews});

  @override
  Widget build(BuildContext context) {
    print('interviews summary section build');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Interviews Summary',
          style: TextStyle(
            fontFamily: AppFont.interSemiBold,
            fontSize: 18,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),

        // Row of 3: Accepted | In Progress | Rejected
        Row(
          children: [
            Expanded(
              child: CornerInterviewCard(
                count: interviews.acceptedInterviews,
                label: 'Accepted',
                icon: Icons.check_circle_outline_rounded,
                iconColor: const Color(0xFF16A34A),
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: CornerInterviewCard(
                count: interviews.pendingInterviews,
                label: 'Pending',
                icon: Icons.access_time_rounded,
                iconColor: const Color(0xFFF2C94C),
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: CornerInterviewCard(
                count: interviews.rejectedInterviews,
                label: 'Rejected',
                icon: Icons.cancel_outlined,
                iconColor: const Color(0xFFDC2626),

              ),
            ),
          ],
        ),
      ],
    );
  }
}
