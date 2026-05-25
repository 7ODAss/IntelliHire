import 'package:flutter/material.dart';
import 'package:intelli_hire/features/candidate/home/domain/entities/weekly_activity_summary.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../../../../../core/utils/app_font.dart';
import '../../domain/entities/training_performance.dart';

class DateGlassCard extends StatelessWidget {
  final double dynamicWidth;
  final String weekLabel;

  const DateGlassCard({
    super.key,
    required this.dynamicWidth,
    required this.weekLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dynamicWidth,
      height: 37,
      child: LiquidGlassView(
        backgroundWidget: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.22), width: 1),
          ),

          width: dynamicWidth,
          height: 37,
        ),
        children: [
          LiquidGlass(
            // صفر الانحراف تماماً
            width: dynamicWidth,
            height: 37,
            distortion: 0.0,
            chromaticAberration: 0.0,
            magnification: 1.0,

            // ضيف ضبابية مصنفرة
            blur: LiquidGlassBlur(sigmaX: 12, sigmaY: 12),

            // حواف دائرية للعدسة
            shape: RoundedRectangleShape(cornerRadius: 30),
            position: LiquidGlassAlignPosition(alignment: Alignment.center),

            // الباكدج دي بتحتاج لون Tint خفيف عشان تدي شكل الإزاز
            color: Colors.white.withOpacity(0.12),
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: weekLabel.split(',')[0],
                      style: const TextStyle(
                        fontFamily: AppFont.interSemiBold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: weekLabel.split(',')[1],
                      style: const TextStyle(
                        fontFamily: AppFont.interSemiBold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
