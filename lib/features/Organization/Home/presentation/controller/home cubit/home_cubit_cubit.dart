import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/models/applicant_model.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/features/Organization/Home/domain/entities/home_entity.dart';
import 'package:intelli_hire/features/Organization/Home/domain/usecases/get_home_data_usecase.dart';
import 'package:intelli_hire/features/Organization/Home/domain/usecases/get_top_talent_usecase.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/home%20cubit/home_cubit_state.dart';

class HomeOrganizationCubit extends Cubit<HomeState> {
  final GetDashboardUseCase getDashboardUseCase;

  HomeOrganizationCubit(this.getDashboardUseCase) : super(HomeInitial());

  Future<void> fetchDashboard({bool showLoading = true}) async {
    await ApplicantModel.loadProcessedSessionIds();
    print("--- [FETCH DASHBOARD] processedSessionIds at fetch time: ${ApplicantModel.processedSessionIds}");
    if (showLoading || state is! HomeLoaded) {
      emit(HomeLoading());
    }
    final result = await getDashboardUseCase.execute();

    // Fetch top talent list in parallel/sequence to ensure accurate UI counts
    final topTalentResult = await getIt<GetTopTalentUseCase>().execute();

    result.fold(
      (failureMessage) => emit(HomeError(failureMessage)),
      (dashboardData) {
        int realTopTalentCount = (dashboardData.topTalentCandidatesCount - ApplicantModel.processedSessionIds.length).clamp(0, 999999);
        int realPendingCount = (dashboardData.pendingCandidates - ApplicantModel.processedSessionIds.length).clamp(0, 999999);
        int realTopTalentInterviewsCount = dashboardData.topTalentInterviewsCount;

        topTalentResult.fold(
          (failure) {
            print("--- [FETCH DASHBOARD ERROR] Failed to fetch top talent list: $failure");
          }, // fallback to backend count if error
          (candidates) {
            print("--- [FETCH DASHBOARD] Top talent candidates from server: ${candidates.map((c) => "${c.name} (Status: ${c.status}, ID: ${c.sessionId})").toList()}");
            final pendingCandidates = candidates
                .where((a) => a.status.toLowerCase() == "pending" && !ApplicantModel.processedSessionIds.contains(a.sessionId))
                .toList();
            realTopTalentCount = pendingCandidates.length;
            print("--- [FETCH DASHBOARD] Filtered pending candidates count: $realTopTalentCount");

            final uniqueRoles = pendingCandidates.map((c) => c.role).toSet();
            realTopTalentInterviewsCount = uniqueRoles.length;
          },
        );

        emit(HomeLoaded(
          HomeEntity(
            companyName: dashboardData.companyName,
            interviewsCount: dashboardData.interviewsCount,
            totalCandidates: dashboardData.totalCandidates,
            pendingCandidates: dashboardData.pendingCandidates,
            topTalentCandidatesCount: realTopTalentCount,
            topTalentInterviewsCount: realTopTalentInterviewsCount,
            jobs: dashboardData.jobs,
          ),
        ));
      },
    );
  }

  void updateTopTalentCount(int count) {
    if (state is HomeLoaded) {
      final currentData = (state as HomeLoaded).dashboardData;
      final diff = currentData.topTalentCandidatesCount - count;
      final newPending = (currentData.pendingCandidates - diff).clamp(0, 999999);
      emit(HomeLoaded(
        HomeEntity(
          companyName: currentData.companyName,
          interviewsCount: currentData.interviewsCount,
          totalCandidates: currentData.totalCandidates,
          pendingCandidates: newPending,
          topTalentCandidatesCount: count,
          topTalentInterviewsCount: count > 0 ? currentData.topTalentInterviewsCount : 0,
          jobs: currentData.jobs,
        ),
      ));
    }
  }
}