import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/assessment.dart';

class AssessmentCard extends StatelessWidget {
  final Assessment assessment;
  final VoidCallback onTap;

  const AssessmentCard({
    super.key,
    required this.assessment,
    required this.onTap,
  });

  Color _getBadgeColor(String badge) {
    final lower = badge.toLowerCase();
    if (lower.contains('excellent')) return const Color(0xFF22C55E);
    if (lower.contains('solid')) return const Color(0xFFCA8A04);
    return const Color(0xFF134CC7);
  }

  Color _getScoreColor(double score) {
    if (score >= 85) return const Color(0xFF134CC7);
    if (score >= 70) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assessment.title,
                        style: const TextStyle(
                          fontFamily: AppFont.interBold,
                          fontSize: 16,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        assessment.track,
                        style: const TextStyle(
                          fontFamily: AppFont.interRegular,
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${assessment.aiScore.toInt()}%',
                      style: TextStyle(
                        fontFamily: AppFont.poppinsBold,
                        fontSize: 22,
                        color: _getScoreColor(assessment.aiScore),
                      ),
                    ),
                    const Text(
                      'AI Score',
                      style: TextStyle(
                        fontFamily: AppFont.interRegular,
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE2E8F0), height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _getBadgeColor(
                      assessment.performanceBadge,
                    ).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_outlined,
                        size: 14,
                        color: _getBadgeColor(assessment.performanceBadge),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        assessment.performanceBadge,
                        style: TextStyle(
                          fontFamily: AppFont.interRegular,
                          fontSize: 12,
                          color: _getBadgeColor(assessment.performanceBadge),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 4),
                Text(
                  assessment.date,
                  style: TextStyle(
                    fontFamily: AppFont.interRegular,
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
