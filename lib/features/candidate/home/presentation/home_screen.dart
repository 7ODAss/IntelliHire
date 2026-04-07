import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  static const _emptyPerformance = TrainingPerformance(
    userName: 'Loading Name',
    totalExams: 0,
    averageScore: 0,
  );

  static const _emptyInterviews = InterviewSummary(
    accepted: 0,
    inProgress: 0,
    pending: 0,
    rejected: 0,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..loadHomeData(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F3F8),

        // 1. هنا استخدمنا BlocSelector بدل BlocBuilder
        // ده معناه: "يا شاشة متتبنيش من تاني أبداً إلا لو حالة الـ Loading أو الـ Error اتغيرت"
        body: BlocSelector<HomeCubit, HomeState, RequestState>(
          selector: (state) => state.status,
          builder: (context, status) {
            final isLoading = status == RequestState.loading || status == RequestState.initial;
            final isError = status == RequestState.error;
            return Skeletonizer(
              enabled: isLoading,
              //containersColor: Colors.red,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [

                  // 2. عزلنا الـ Header: مش هيتبني غير لو اسم اليوزر اتغير بس!
                  SliverToBoxAdapter(
                    child: BlocSelector<HomeCubit, HomeState, String>(
                      selector: (state) => state.homeSummary?.trainingPerformance.userName ?? 'Loading Name',
                      builder: (context, userName) {
                        return Header(userName: userName);
                      },
                    ),
                  ),

                  if (isError)
                    SliverToBoxAdapter(
                      child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) => ErrorBanner(
                          message: state.errorMessage,
                          onRetry: () => context.read<HomeCubit>().loadHomeData(),
                        ),
                      ),
                    ),

                  // 3. كارت الأداء: ده الوحيد اللي واخد BlocBuilder صريح
                  // عشان لما تغير الأسبوع، هو بس اللي يتبني من جديد بدون ما يأثر على باقي الشاشة
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          final performance = state.homeSummary?.trainingPerformance ?? _emptyPerformance;
                          return TrainingPerformanceCard(
                            performance: performance,
                            cubit: context.read<HomeCubit>(),
                          );
                        },
                      ),
                    ),
                  ),

                  // 4. عزلنا كارت المقابلات: هيراقب داتا المقابلات بس (ملوش دعوة بالأسبوع)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      child: BlocSelector<HomeCubit, HomeState, InterviewSummary>(
                        selector: (state) => state.homeSummary?.interviewSummary ?? _emptyInterviews,
                        builder: (context, interviews) {
                          return InterviewsSummarySection(interviews: interviews);
                        },
                      ),
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}