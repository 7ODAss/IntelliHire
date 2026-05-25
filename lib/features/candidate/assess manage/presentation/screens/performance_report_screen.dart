import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/performance_report.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../Organization/Job Managment/presentation/views/widget/custom_pop_button.dart';
import '../controller/assess_manage_cubit.dart';
import '../widgets/performance_card.dart';
import 'interview_report_screen.dart';

/// Used when navigating from AssessmentHistoryScreen (cubit already provided)
class PerformanceReportFromCubitScreen extends StatelessWidget {

  const PerformanceReportFromCubitScreen({
    super.key,
  });

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
        );
      },
    );
  }
}


class PerformanceReportScreen extends StatelessWidget {
  final PerformanceReport report;
  final bool isLoading;
  final bool comeFromAssess;

  const PerformanceReportScreen({
    super.key,
    required this.report,
    this.isLoading = false,
    this.comeFromAssess = false,
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
          child: (comeFromAssess)
              ? null
              : CustomPopButton(onTap: () => Navigator.pop(context)),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Performance Report\n',
                style: const TextStyle(
                  fontFamily: AppFont.interBold,
                  fontSize: 18,
                  color: Color(0xFF0F172A),
                ),
              ),
              TextSpan(
                text: '${report.title} • ${report.track}',
                style: const TextStyle(
                  fontFamily: AppFont.interRegular,
                  fontSize: 12,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Skeletonizer(
        enabled: isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PerformanceCard(report: report),
              const SizedBox(height: 24),

              // View interview report button
              if (!isLoading && report.questions.isNotEmpty)
                InterviewReportScreen(report: report),
              if (comeFromAssess)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ButtonAction(
                    title: 'Done',
                    onPressed: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).popUntil((route) => route.isFirst);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
