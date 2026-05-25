import 'package:flutter_bloc/flutter_bloc.dart';
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
      if (candidates.isEmpty) {
        emit(
          ReviewSessionError("No top talent candidates available right now."),
        );
      } else {
        emit(ReviewSessionLoaded(candidates));
      }
    });
  }

  void submitDecision(String sessionId, int status) async {
    emit(ReviewDecisionSubmitting());

    // 🔴 التعديل هنا: تمرير الـ status
    final result = await submitDecisionUseCase.execute(sessionId, status);

    result.fold((failure) => emit(ReviewDecisionError(failure)), (success) {
      emit(ReviewDecisionSuccess());

      // 🟢 الخطوة السحرية: نطلب من الـ HomeCubit يرفرش الأرقام فوراً
      getIt<HomeOrganizationCubit>().fetchDashboard();
    });
  }
}
