import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/app_font.dart';
import '../../domain/entities/training_performance.dart';
import '../controller/home_cubit.dart';
import 'activity_bar.dart';
import 'date_glass_card.dart';
import 'liquid_glass_card.dart';
import 'nav_btn.dart';

class TrainingPerformanceCard extends StatelessWidget {
  final TrainingPerformance performance;
  final HomeCubit cubit;

  const TrainingPerformanceCard({super.key,required this.performance,required this.cubit});

  @override
  Widget build(BuildContext context) {
    final activity = cubit.currentActivity;
    final maxVal = activity.reduce((a, b) => a > b ? a : b);
    final textStyle = const TextStyle(
      fontFamily: AppFont.interSemiBold,
      fontSize: 14,
      color: Colors.white,
    );
    final (:month, :year, :weekNum) = cubit.weekLabel();
    final labelString = '$month $year , Week $weekNum';
    final textPainter = TextPainter(
      text: TextSpan(text: labelString, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    final dynamicWidth = textPainter.size.width + 32;
    final boxWidth = (MediaQuery.of(context).size.width - 120) / 2;

    print('training performance card build');
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF0F172A), Color(0xFF28355F)],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton.keep(
              child: const Text(
                'Training Performance',
                style: TextStyle(
                  fontFamily: AppFont.interBold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Skeleton.keep(
              child: const Text(
                'Great stats, keep it up!',
                style: TextStyle(
                  fontFamily: AppFont.interRegular,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),

            // 🌟 السر التاني: استبدال الإزاز ببوكسات عادية وقت التحميل فقط
            Skeleton.replace(
              replacement: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white10, // لون البوكس وقت التحميل
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ده الكارت الحقيقي اللي هيظهر بعد التحميل ما يخلص
              child: LiquidGlassCard(performance: performance),
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavBtn(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => cubit.changeWeekOffset(-1),
                ),
                const SizedBox(width: 12),
                DateGlassCard(
                  dynamicWidth: dynamicWidth,
                  month: month,
                  year: year.toString(),
                  week: weekNum.toString(),
                ),
                const SizedBox(width: 12),
                NavBtn(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => cubit.changeWeekOffset(1),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Skeleton.keep(
              child: const Text(
                'Your Activity This Week',
                style: TextStyle(
                  fontFamily: AppFont.interSemiBold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),

            Skeleton.replace(
              replacement: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.white10, // لون البوكس وقت التحميل
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: SizedBox(
                height: 140,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(cubit.weekDays.length, (i) {
                    final fraction = maxVal == 0 ? 0.0 : (activity[i] / maxVal);
                    final isToday = i == cubit.todayIndex;
                    final barH = maxVal == 0
                        ? 6.0
                        : ((activity[i] / maxVal) * 80).clamp(6.0, 80.0);
                    return Expanded(
                      child: ActivityBar(
                        fraction: fraction,
                        height: barH,
                        label: cubit.weekDays[i],
                        count: activity[i],
                        isToday: isToday,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
