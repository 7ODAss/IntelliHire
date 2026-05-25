import 'package:flutter/material.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/widget/current_job_card.dart';
import 'package:intelli_hire/features/Organization/Home/domain/entities/home_entity.dart';

class CurrentJobListView extends StatelessWidget {
  const CurrentJobListView({super.key, required this.jobs});

  final List<DashboardJobEntity> jobs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        // 🔴 استخدمنا separated بدل builder
        scrollDirection: Axis.horizontal,
        itemCount: jobs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, n) {
          return CurrentJobCard(job: jobs[n]);
        },
      ),
    );
  }
}
