import 'package:flutter/material.dart';
import '../../../../../core/utils/app_font.dart';

class GlassStatBoxObstructionContent extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;

  const GlassStatBoxObstructionContent({
    super.key,
    required this.label,
    required this.value,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // محاذاة النص جوه البوكس
      alignment: Alignment.centerLeft,
      // الحواف الدائرية تكون أصغر قليلاً من العدسة لتجنب تداخل الحدود
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        // لون صلب ومطابق تماماً للخلفية عشان يخفي كل حاجة وراه
        color: Color(0xFF0D1B2A).withOpacity(0.15), // الكحلي الصلب بتاع الكارت
        borderRadius: BorderRadius.circular(12),
        // الحدود الصلبة كجزء من محتوى البوكس
        border: Border.all(
          color: Colors.white.withOpacity(0.22),
          width: 1,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: AppFont.poppinsBold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontFamily: AppFont.poppinsBold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  if (suffix.isNotEmpty)
                    TextSpan(
                      text: suffix,
                      style: const TextStyle(
                        fontFamily: AppFont.interMedium,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}