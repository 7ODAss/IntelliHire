import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/assessment.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/controller/assessment_session_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/service/service_locator.dart';
import '../controller/assess_manage_cubit.dart';
import '../widgets/assessment_card.dart';
import '../widgets/candidate_error_widget.dart';
import '../widgets/empty_assessment_widget.dart';
import 'performance_report_screen.dart';

class AssessmentHistoryScreen extends StatelessWidget {
  const AssessmentHistoryScreen({super.key});

  static final _dummyList = List.generate(
    3,
    (i) => const Assessment(
      sessionId: '',
      title: 'Front-End Assessment',
      track: 'Frontend Engineering Track',
      aiScore: 90,
      label: 'Excellent Performance',
      date: 'Oct 25, 2023',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Assessment History',
          style: TextStyle(
            fontFamily: AppFont.poppinsBold,
            fontSize: 20,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: BlocBuilder<AssessManageCubit, AssessManageState>(
        buildWhen: (prev, curr) => prev.historyStatus != curr.historyStatus,
        builder: (context, state) {
          if (state.historyStatus == RequestState.error) {
            return CandidateErrorWidget(
              message: state.errorMessage,
              onRetry: () =>
                  context.read<AssessManageCubit>().loadAssessmentHistory(),
            );
          }

          final isLoading = state.historyStatus != RequestState.success;
          final assessments = isLoading ? _dummyList : state.assessments;

          if (!isLoading && assessments.isEmpty) {
            return const EmptyAssessmentWidget();
          }

          return Skeletonizer(
            enabled: isLoading,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: assessments.length,
              itemBuilder: (context, index) {
                return AssessmentCard(
                  assessment: assessments[index],
                  onTap: () {
                    if (!isLoading) {
                      context.read<AssessManageCubit>().loadPerformanceReport(
                        assessments[index].sessionId,
                      );

                      final String userJobTitle =
                          getIt<AssessmentSessionCubit>().state.cv?.jobTitle ??
                          assessments[index].title;

                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<AssessManageCubit>(),
                            child: PerformanceReportFromCubitScreen(
                              jobTitle: userJobTitle,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
