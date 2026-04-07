import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../../domain/entities/training_performance.dart';
import 'glass_stat_box_obstruction_content.dart';

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
            height: 100,
            child: LiquidGlassView(
              backgroundWidget: Container(
                color: const Color(0xFF0F172A),
                width: double.infinity,
                height: 100,
              ),
              children: [
                LiquidGlass(
                  width: boxWidth - 10,
                  height: 100,
                  distortion: 0.0,
                  chromaticAberration: 0.0,
                  magnification: 1.0,
                  blur: LiquidGlassBlur(sigmaX: 12, sigmaY: 12),
                  shape: RoundedRectangleShape(cornerRadius: 14),
                  position: const LiquidGlassAlignPosition(alignment: Alignment.centerLeft),
                  color: Colors.white.withOpacity(0.09),
                  child: GlassStatBoxObstructionContent(
                    label: 'Total Exams',
                    value: '${performance.totalExams}',
                  ),
                ),
                LiquidGlass(
                  width: boxWidth,
                  height: 100,
                  distortion: 0.0,
                  chromaticAberration: 0.0,
                  magnification: 1.0,
                  blur: LiquidGlassBlur(sigmaX: 12, sigmaY: 12),
                  shape: RoundedRectangleShape(cornerRadius: 14),
                  position: const LiquidGlassAlignPosition(alignment: Alignment.centerRight),
                  color: Colors.white.withOpacity(0.09),
                  child: GlassStatBoxObstructionContent(
                    label: 'Average Score',
                    value: performance.averageScore.toStringAsFixed(0),
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
