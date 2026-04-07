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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: CornerInterviewCard(
                count: interviews.accepted,
                label: 'Accepted',
                icon: Icons.check_circle_outline_rounded,
                iconColor: const Color(0xFF16A34A),
                height: 165,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  CenterInterviewCard(
                    count: interviews.inProgress,
                    label: 'In Progress',
                    icon: Icons.sync_rounded,
                    iconColor: const Color(0xFF2563EB),
                    width: 350,
                  ),
                  const SizedBox(height: 10),
                  CenterInterviewCard(
                    count: interviews.pending,
                    label: 'Pending',
                    icon: Icons.access_time_rounded,
                    iconColor: const Color(0xFFF2C94C),
                    width: 350,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: CornerInterviewCard(
                count: interviews.rejected,
                label: 'Rejected',
                icon: Icons.cancel_outlined,
                iconColor: const Color(0xFFDC2626),
                height: 165,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
