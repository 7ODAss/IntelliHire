import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/models/applicant_model.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/features/Organization/Home/domain/usecases/get_top_talent_usecase.dart';
import 'package:intelli_hire/features/Organization/Home/domain/usecases/submit_decision_usecase.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/home%20cubit/home_cubit_cubit.dart';
import 'review_session_state.dart';

class ReviewSessionCubit extends Cubit<ReviewSessionState> {
  final GetTopTalentUseCase getTopTalentUseCase;
  final SubmitDecisionUseCase submitDecisionUseCase;

  ReviewSessionCubit(this.getTopTalentUseCase, this.submitDecisionUseCase)
    : super(ReviewSessionInitial());

  void fetchTopTalentCandidates() async {
    emit(ReviewSessionLoading());
    final result = await getTopTalentUseCase.execute();

    result.fold((failure) => emit(ReviewSessionError(failure)), (candidates) {
      final pendingCandidates = candidates
          .where((a) => a.status == "Pending" && !ApplicantModel.processedSessionIds.contains(a.sessionId))
          .toList();

      if (pendingCandidates.isEmpty) {
        emit(
          ReviewSessionError("No top talent candidates available right now."),
        );
      } else {
        emit(ReviewSessionLoaded(pendingCandidates));
      }
    });
  }

  void submitDecision(String sessionId, int status) async {
    emit(ReviewDecisionSubmitting());

    final result = await submitDecisionUseCase.execute(sessionId, status);

    result.fold((failure) => emit(ReviewDecisionError(failure)), (success) async {
      await ApplicantModel.markSessionAsProcessed(sessionId);
      emit(ReviewDecisionSuccess());

      getIt<HomeOrganizationCubit>().fetchDashboard(showLoading: false);
    });
  }
}
