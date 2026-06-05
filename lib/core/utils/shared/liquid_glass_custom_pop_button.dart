import 'package:flutter/material.dart';

class LiquidGlassCustomPopButton extends StatelessWidget {
  const LiquidGlassCustomPopButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        // 1. الإطار الخارجي (اللي بيعمل لمعة الإزاز من فوق وضل من تحت)
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.white.withOpacity(0.6), // لمعة بيضاء قوية فوق على الشمال
                Colors.white.withOpacity(0.0), // شفاف في النص
                Colors.white.withOpacity(0.0), // شفاف في النص
                Colors.black.withOpacity(0.6), // ضل غامق تحت على اليمين
              ],
              stops: const [0.0, 0.4,0.45, 1.0], // توزيع الألوان عشان اللمعة تبان حادة
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4), // ضل خفيف تحت الزرار نفسه
              )
            ]
        ),
        // 2. سُمك الإزاز (Edge Thickness)
        child: Padding(
          padding: const EdgeInsets.all(1.2), // الرقم ده هو عرض البوردر
          child: Container(
            // 3. اللون الداخلي للزرار (الخلفية الغامقة)
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF1E293B), // أفتح سِنة بسيطة من لون الخلفية
                  Color(0xFF0F172A), // لون الخلفية الأساسي الكحلي الغامق
                ],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}