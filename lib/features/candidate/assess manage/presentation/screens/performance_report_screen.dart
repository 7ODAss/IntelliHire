import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/performance_report.dart';
import '../../../../Organization/Job Managment/presentation/widget/custom_pop_button.dart';
import '../../../../Organization/Profile/presentation/widgets/pop_action_menu.dart';
import '../controller/assess_manage_cubit.dart';
import 'interview_report_screen.dart';

/// Used when navigating from AssessmentHistoryScreen (cubit already provided)
class PerformanceReportFromCubitScreen extends StatelessWidget {
  final String title;
  final String track;
  const PerformanceReportFromCubitScreen({super.key,required this.title,required this.track});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssessManageCubit, AssessManageState>(
      buildWhen: (prev, curr) => prev.reportStatus != curr.reportStatus,
      builder: (context, state) {
        final isLoading = state.reportStatus != RequestState.success;
        final report = state.report;

        if (state.reportStatus == RequestState.error) {
          return Scaffold(body: Center(child: Text(state.errorMessage)));
        }

        return PerformanceReportScreen(
          report: report ?? PerformanceReport.empty(),
          isLoading: isLoading,
          title: title,
          track: track,
        );
      },
    );
  }
}

/// Used after interview submission (report passed directly)
class PerformanceReportScreen extends StatelessWidget {
  final PerformanceReport report;
  final bool isLoading;
  final String title;
  final String track;

  const PerformanceReportScreen({
    super.key,
    required this.report,
    this.isLoading = false,
    required this.title,
    required this.track,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CustomPopButton(
            onTap: () => Navigator.pop(context),
          ),
        ),
        title: RichText(text: TextSpan(children: [
          TextSpan(text: 'Performance Report\n',
              style: const TextStyle(
                fontFamily: AppFont.interBold,
                fontSize: 18,
                color: Color(0xFF0F172A),
              ),),
          TextSpan(text:'$title • $track',
                style: const TextStyle(
                  fontFamily: AppFont.interRegular,
                  fontSize: 12,
                  color: Color(0xFF475569),
                ),),
        ])),
      ),
      body: Skeletonizer(
        enabled: isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Score card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Overall AI Score',
                          style: TextStyle(
                            fontFamily: AppFont.interRegular,
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.insights_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: report.aiScore),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (_, value, __) => Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                          fontFamily: AppFont.poppinsBold,
                          fontSize: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _statItem('Questions', '${report.totalQuestions}'),
                        _divider(),
                        _statItem('Accuracy', '${report.accuracy.toInt()}%'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _statItem('Total Time', report.totalTime),
                        _divider(),
                        _statItem('Avg. Reply', report.avgReply),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // View interview report button
              if (!isLoading && report.results.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InterviewReportScreen(report: report),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColor.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.article_outlined,
                      color: AppColor.primary,
                    ),
                    label: const Text(
                      'View Full Interview Report',
                      style: TextStyle(
                        fontFamily: AppFont.interRegular,
                        fontSize: 14,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label :',
            style: const TextStyle(
              fontFamily: AppFont.interRegular,
              fontSize: 12,
              color: Colors.white60,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppFont.interBold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 40,
    color: Colors.white24,
    margin: const EdgeInsets.symmetric(horizontal: 16),
  );
}
