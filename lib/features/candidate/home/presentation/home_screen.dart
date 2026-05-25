import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/candidate/home/presentation/widgets/empty_screen.dart';
import 'package:intelli_hire/features/candidate/home/presentation/widgets/error_banner.dart';
import 'package:intelli_hire/features/candidate/home/presentation/widgets/header_section.dart';
import 'package:intelli_hire/features/candidate/home/presentation/widgets/interviews_summary_section.dart';
import 'package:intelli_hire/features/candidate/home/presentation/widgets/training_performance_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/enums/request.dart';
import '../../../../core/service/service_locator.dart';
import '../domain/entities/interview_summary.dart';
import '../domain/entities/training_performance.dart';
import 'controller/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 🌟 الداتا الوهمية دي ضرورية جداً عشان Skeletonizer يعرف يرسم العضم (Bones)
  static const _emptyPerformance = TrainingPerformance(
    firstName: 'Loading Name',
    totalExams: 0,
    averageScore: 0,
    weekLabel: 'Loading Week',
    weeklyActivity: [0, 0, 0, 0, 0, 0, 0],
  );

  static const _emptyInterviews = InterviewSummary(
    acceptedInterviews: 1,
    pendingInterviews: 2,
    rejectedInterviews: 0,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubitCandidate>()..loadHomeData(),
      child: Scaffold(
        body: BlocBuilder<HomeCubitCandidate, HomeState>(
          buildWhen: (previous, current) {
            // 🌟 السطر ده هو السحر:
            // هيمنع الشاشة الرئيسية إنها تتبني لما الكيوبت يبعت Loading للتقويم
            // أو لما الـ weekActivity تتغير.
            return previous.homeSummary != current.homeSummary || previous.homeSummary == null;
          },
          builder: (context, state) {
            switch (state.homeSummaryStatus) {
              case RequestState.error:
                return CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: ErrorBanner(
                          message: state.homeSummaryMessage,
                          onRetry: () => context.read<HomeCubitCandidate>().loadHomeData(),
                        ),
                      ),
                    ),
                  ],
                );

              case RequestState.initial:
              case RequestState.loading:
              case RequestState.success:

                final isLoading = state.homeSummaryStatus == RequestState.loading || state.homeSummaryStatus == RequestState.initial;

                // تجهيز الداتا (لو بيحمل هياخد الوهمية، لو خلص هياخد الحقيقية)
                final performance = state.homeSummary?.trainingPerformance ??
                    _emptyPerformance;
                final interviews = state.homeSummary?.interviewSummary ??
                    _emptyInterviews;

                return Skeletonizer(
                  enabled: isLoading,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Header(userName: performance.firstName),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                          child: (performance.totalExams != 0) ?
                          TrainingPerformanceCard(performance: performance, cubit: context.read<HomeCubitCandidate>(), // 🌟 شغال هنا بأمان تام
                          ) : const EmptyScreen(),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                          child: InterviewsSummarySection(
                            interviews: interviews,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}