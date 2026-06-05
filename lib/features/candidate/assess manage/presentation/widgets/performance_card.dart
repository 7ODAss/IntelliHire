import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/presentation/widgets/stat_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/app_font.dart';
import '../../domain/entities/performance_report.dart';

class PerformanceCard extends StatelessWidget {
  final PerformanceReport report;
  const PerformanceCard({super.key, required this.report});

  String _formatAvgReply(String value) {
    String clean = value.trim();
    bool hasSuffix = clean.toLowerCase().endsWith('s');
    if (hasSuffix) {
      clean = clean.substring(0, clean.length - 1).trim();
    }
    final parsed = double.tryParse(clean);
    if (parsed != null) {
      return "${parsed.toStringAsFixed(1)}s";
    }
    return value.endsWith('s') ? value : "${value}s";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2436),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🌟 1. الـ Expanded الصح مكانه هنا (عشان يمنع تداخل النص مع الدايرة بالعرض)
              Skeleton.keep(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall AI Score',
                      style: TextStyle(
                        fontFamily: AppFont.interBold,
                        fontSize: 14,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: report.overallAiScore),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (_, value, __) => Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                          fontFamily: AppFont.poppinsBold,
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFF161E2E),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF3D497D),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.15),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/images/candidate/arrow.svg',
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: Color(0xFFB4ADAE), thickness: 1.5),
          const SizedBox(height: 12),

          // 🌟 2. شيلنا الـ Expanded اللي هنا خالص، ورجعناه Column عادي جداً
          Row(
            children: [
              StatItem(label: "Questions", value: "${report.questionsCount}"),
              const Spacer(),
              StatItem(label: "Accuracy", value: '${report.accuracy.toInt()}%')
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              StatItem(label:' Total Time', value:  '${report.totalTime}m'),
              const Spacer(),
              StatItem(label:' Avg. Reply', value: _formatAvgReply(report.avgReply)),
            ],
          ),
        ],
      ),
    );
  }
}
