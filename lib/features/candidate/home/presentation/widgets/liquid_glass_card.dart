import 'package:flutter/material.dart';
import 'package:intelli_hire/features/candidate/home/presentation/widgets/glass_stat_box_obstruction_content.dart';
import '../../domain/entities/training_performance.dart';

class LiquidGlassCard extends StatelessWidget {
  final TrainingPerformance performance;
  const LiquidGlassCard({super.key, required this.performance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final availableWidth = constraints.maxWidth;
          final boxWidth = (availableWidth - 30) / 2;

          return SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // الكارد الأول (Total Exams)
                Container(
                  width: boxWidth,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: GlassStatBoxObstructionContent(
                    label: 'Total Exams',
                    value: '${performance.totalExams}',
                  ),
                ),
                // الكارد الثاني (Average Score)
                Container(
                  width: boxWidth,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: GlassStatBoxObstructionContent(
                    label: 'Average Score',
                    value: performance.averageScore.toString(),
                    suffix: '%',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
