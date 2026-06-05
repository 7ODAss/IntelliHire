import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/presentation/widgets/candidate_error_widget.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 🌟 الداتا الوهمية دي ضرورية جداً عشان Skeletonizer يعرف يرسم العضم (Bones)
  static const _emptyPerformance = TrainingPerformance(
    firstName: 'Loading Name',
    totalExams: 0,
    averageScore: 0,
    weekLabel: 'Loading Week',
    weeklyActivity: [0, 0, 0, 0, 0, 0, 0],
    dailyAverageScores: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
  );

  static const _emptyInterviews = InterviewSummary(
    acceptedInterviews: 1,
    pendingInterviews: 2,
    rejectedInterviews: 0,
  );

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = getIt<HomeCubitCandidate>();

    if (!_initialized) {
      // First mount: always load fresh data.
      _initialized = true;
      cubit.reset();
      cubit.loadHomeData();
    } else if (cubit.needsRefresh) {
      // Re-entry after an assessment: the newassess flow set this flag instead
      // of calling loadHomeData() directly (which caused ANR while HomeScreen
      // was buried under the assessment route). Consume the flag and refresh now
      // that HomeScreen is actually visible again.
      cubit.needsRefresh = false;
      cubit.loadHomeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // BlocProvider.value does NOT call .close() when this widget is disposed,
    // which is correct for a lazySingleton cubit that must outlive this screen.
    // BlocProvider(create:) always calls .close() — that was closing the
    // singleton and causing StateError aborts when other cubits tried to
    // emit() into it after navigation.
    return BlocProvider.value(
      value: getIt<HomeCubitCandidate>(),
      child: Scaffold(
        body: BlocBuilder<HomeCubitCandidate, HomeState>(
          buildWhen: (previous, current) {
            return previous.homeSummaryStatus != current.homeSummaryStatus;
          },
          builder: (context, state) {
            switch (state.homeSummaryStatus) {
              case RequestState.error:
                return CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: CandidateErrorWidget(
                        message: state.homeSummaryMessage,
                        onRetry: () =>
                            context.read<HomeCubitCandidate>().loadHomeData(),
                      ),
                    ),
                  ],
                );

              case RequestState.initial:
              case RequestState.loading:
              case RequestState.success:
                final isLoading =
                    state.homeSummaryStatus == RequestState.loading ||
                    state.homeSummaryStatus == RequestState.initial;

                // تجهيز الداتا (لو بيحمل هياخد الوهمية، لو خلص هياخد الحقيقية)
                final performance =
                    state.homeSummary?.trainingPerformance ?? _emptyPerformance;
                final interviews =
                    state.homeSummary?.interviewSummary ?? _emptyInterviews;

                return Skeletonizer(
                  enabled: isLoading,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child:
                              BlocSelector<
                                HomeCubitCandidate,
                                HomeState,
                                TrainingPerformance
                              >(
                                selector: (state) =>
                                    state.homeSummary?.trainingPerformance ??
                                    _emptyPerformance,
                                builder: (context, performance) {
                                  return Header(performance: performance);
                                },
                              ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                            child: (performance.totalExams != 0)
                                ? TrainingPerformanceCard(
                                    performance: performance,
                                    cubit: context.read<HomeCubitCandidate>(),
                                  )
                                : const EmptyScreen(),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                            child: InterviewsSummarySection(
                              interviews: interviews,
                            ),
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
