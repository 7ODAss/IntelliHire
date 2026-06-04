import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/candidate/home/presentation/widgets/performance_line_chart.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/app_font.dart';
import '../../domain/entities/training_performance.dart';
import '../../domain/entities/weekly_activity_summary.dart';
import '../controller/home_cubit.dart';
import 'activity_bar.dart';
import 'date_glass_card.dart';
import 'liquid_glass_card.dart';
import 'nav_btn.dart';

class TrainingPerformanceCard extends StatelessWidget {
  final TrainingPerformance performance;
  final HomeCubitCandidate cubit;

  const TrainingPerformanceCard({
    super.key,
    required this.performance,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    print('✅ Training Performance Card Built (Main)');
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

            Skeleton.replace(
              replacement: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              child: LiquidGlassCard(performance: performance),
            ),

            const SizedBox(height: 10),
            BlocSelector<HomeCubitCandidate, HomeState, WeeklyActivitySummary?>(
              selector: (state) => state.weekActivity,
              builder: (context, state) {
                print('🔄 إعادة بناء جزء التقويم فقط');
                final labelString = state?.weekLabel ?? performance.weekLabel;

                final textPainter = TextPainter(
                  text: TextSpan(
                    text: labelString,
                    style: AppTextStyle.candidateHomePageCalenderTitle,
                  ),
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                )..layout();

                final dynamicWidth = textPainter.size.width + 32;
                return Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        NavBtn(
                          icon: Icons.chevron_left_rounded,
                          onTap: () => cubit.getPrevWeek(),
                        ),
                        const SizedBox(width: 12),
                        DateGlassCard(
                          weekLabel: labelString,
                          dynamicWidth: dynamicWidth,
                        ),
                        const SizedBox(width: 12),
                        NavBtn(
                          icon: Icons.chevron_right_rounded,
                          onTap: () => cubit.getNextWeek(),
                        ),
                      ],
                    ),
                  ),
                );
              },
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

            BlocSelector<HomeCubitCandidate, HomeState, WeeklyActivitySummary?>(
              selector: (state) => state.weekActivity,
              builder: (context, state) {
                print('📊 إعادة بناء العواميد فقط');
                final activity =
                    state?.weeklyActivity ?? performance.weeklyActivity;
                final maxVal = activity.isEmpty
                    ? 0
                    : activity.reduce((a, b) => a > b ? a : b);
                final scores = performance.dailyAverageScores;
                return Skeleton.replace(
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
                    height: 200,
                    child: PerformanceLineChart(
                      scores: scores,
                      weekDays:
                          cubit.weekDays, // باصينا أيام الأسبوع من الكيوبت
                      examsTakenList: activity, // عدد الامتحانات اليومية
                      /* examsTakenList: [
                        2,
                        3,
                        1,
                        4,
                        5,
                        2,
                        3,
                      ], // باصينا عدد الامتحانات اليومية من الكيو 
                      */
                      /* scores: [
                        50,
                        75.2,
                        60.7,
                        85.9,
                        90,
                        70,
                        80,
                      ], // باصينا الدرجات من الكيوبت
                       */
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
