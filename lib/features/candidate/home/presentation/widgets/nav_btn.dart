import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

class NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const NavBtn({super.key,required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassView(
        backgroundWidget: Container(
          width: 37,
          height: 37,
          decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.22),
              width: 1,
            ),
          ),
        ),
        children: [
          LiquidGlass(
            width: 37,
            height: 37,
            // صفر الانحراف تماماً
            distortion: 0.0,
            chromaticAberration: 0.0,
            magnification: 1.0,

            // ضيف ضبابية مصنفرة
            blur: LiquidGlassBlur(sigmaX: 12, sigmaY: 12),

            // حواف دائرية للعدسة
            shape: RoundedRectangleShape(cornerRadius: 20),
            position: LiquidGlassAlignPosition(alignment: Alignment.centerLeft),

            // الباكدج دي بتحتاج لون Tint خفيف عشان تدي شكل الإزاز
            color: Colors.white.withOpacity(0.09),

            // هنا بنستخدم كلاس جديد "يحجب" الانعكاسات تماماً
            child: Icon(
              icon,
              color: enabled ? Colors.white : Colors.white24,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}