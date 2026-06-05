import 'package:flutter/material.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_font.dart';

class PulseTimerBadge extends StatefulWidget {
  final int remainingTime;

  const PulseTimerBadge({super.key, required this.remainingTime});

  @override
  State<PulseTimerBadge> createState() => _PulseTimerBadgeState();
}

class _PulseTimerBadgeState extends State<PulseTimerBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // سرعة النبضة (نص ثانية وتكبير بنسبة 10%)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _checkAnimation();
  }

  // الدالة دي بتشتغل كل ما الكيوبت يبعت ثانية جديدة
  @override
  void didUpdateWidget(covariant PulseTimerBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkAnimation();
  }

  void _checkAnimation() {
    // لو فاضل 10 ثواني أو أقل، شغل النبض المستمر
    if (widget.remainingTime <= 60 && widget.remainingTime > 0) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
    } else {
      // غير كده وقف الأنيميشن ورجعه لحجمه الطبيعي
      _controller.stop();
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (widget.remainingTime / 60).floor().toString().padLeft(2, '0');
    final seconds = (widget.remainingTime % 60).toString().padLeft(2, '0');
    final isDanger = widget.remainingTime <= 60;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDanger
              ? [
            const BoxShadow(
              color: Colors.redAccent,
              blurRadius: 10,
              spreadRadius: 2,
              blurStyle: BlurStyle.inner, // الظل الداخلي اللي اتفقنا عليه
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_outlined,
              size: 20,
              color: isDanger ? Colors.red : AppColor.primary,
            ),
            const SizedBox(width: 4),
            Text(
              "$minutes:$seconds",
              style: TextStyle(
                fontFamily: AppFont.interBold,
                color: isDanger ? Colors.red : AppColor.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}