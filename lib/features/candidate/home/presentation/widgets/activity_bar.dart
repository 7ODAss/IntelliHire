import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../../../../../core/utils/app_font.dart';

class ActivityBar extends StatelessWidget {
  final double fraction; // استقبلنا النسبة المئوية هنا (0.0 إلى 1.0)
  final double height;
  final String label;
  final int count;
  final bool isToday;

  const ActivityBar({
    super.key,
    required this.fraction,
    required this.height,
    required this.label,
    required this.count,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    const List<Color> circularColor =[Color(0xFF0F172A), Color(0xFF28355F)];
    const List<Color> barColor = [Color(0xFF4ADE80), Color(0xFF35CD6D), Color(0xFF4ADE80)];
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Count above bar
        Text(
          '$count',
          style: TextStyle(
            fontFamily: AppFont.interMedium,
            fontSize: 12,
            color: Color(0xFF4ADE80),
          ),
        ),

        const Spacer(),
        // Thin pill bar — width ~10px inside the expanded cell
        count != 0 ? Container(
          width: 10,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: barColor,
            ),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: barColor.first.withOpacity(0.9),
                blurRadius: 5,       // مدى نعومة وزغللة الظل (كل ما زاد بقى أنعم)
                offset: const Offset(0, 3), // اتجاه الظل (0 يمين/شمال، و 3 بيكسل لتحت)
              ),
            ],
          ),
        ) : SizedBox(),
        const SizedBox(height: 8),
        // Day label — today gets green circle
        isToday
            ? LiquidGlassView(
          backgroundWidget: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: circularColor,
              ),
              shape: BoxShape.circle,

            ),
          ),
          children: [
            LiquidGlass(
              width: 24,
              height: 24,
              // صفر الانحراف تماماً
              distortion: 0.0,
              chromaticAberration: 0.0,
              magnification: 1.0,

              blur: LiquidGlassBlur(sigmaX: 12, sigmaY: 12),

              shape: RoundedRectangleShape(cornerRadius: 20),
              position: LiquidGlassAlignPosition(
                alignment: Alignment.center,
              ),

              color: Colors.white.withOpacity(0.15),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppFont.interBold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        )
            : Text(
          label,
          style: const TextStyle(
            fontFamily: AppFont.interRegular,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
