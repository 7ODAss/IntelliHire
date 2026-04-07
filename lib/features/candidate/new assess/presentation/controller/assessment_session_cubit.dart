import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/performance_report.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/question.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/usecases/fetch_assessment_questions_usecase.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/usecases/submit_interview_usecase.dart';

part 'assessment_session_state.dart';

enum RecordingState { idle, recording, recorded, playing }

class AssessmentSessionCubit extends Cubit<AssessmentSessionState> {
  final FetchAssessmentQuestionsUseCase fetchQuestionsUseCase;
  final SubmitInterviewUseCase submitInterviewUseCase;

  AssessmentSessionCubit(this.fetchQuestionsUseCase, this.submitInterviewUseCase)
      : super(const AssessmentSessionState());

  Future<void> loadQuestions(String assessmentId) async {
    emit(state.copyWith(status: RequestState.loading));
    final result = await fetchQuestionsUseCase(FetchAssessmentQuestionsParams(assessmentId));
    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestState.error,
        errorMessage: failure.message,
      )),
      (questions) => emit(state.copyWith(
        status: RequestState.success,
        questions: questions,
        currentIndex: 0,
      )),
    );
  }

  void nextQuestion() {
    final next = state.currentIndex + 1;
    if (next < state.questions.length) {
      emit(state.copyWith(
        currentIndex: next,
        recordingState: RecordingState.idle,
        recordingPath: '',
        selectedOption: '',
      ));
    }
  }

  void onRecordingStarted() {
    emit(state.copyWith(recordingState: RecordingState.recording, recordingPath: ''));
  }

  void onRecordingStopped(String path) {
    final updatedPaths = Map<String, String>.from(state.recordingPathsMap);
    final currentQ = state.questions[state.currentIndex];
    updatedPaths[currentQ.id] = path;
    emit(state.copyWith(
      recordingState: RecordingState.recorded,
      recordingPath: path,
      recordingPathsMap: updatedPaths,
    ));
  }

  void onPlaybackStarted() {
    emit(state.copyWith(recordingState: RecordingState.playing));
  }

  void onPlaybackStopped() {
    emit(state.copyWith(recordingState: RecordingState.recorded));
  }

  void onRecordingDeleted() {
    final updatedPaths = Map<String, String>.from(state.recordingPathsMap);
    final currentQ = state.questions[state.currentIndex];
    updatedPaths.remove(currentQ.id);
    emit(state.copyWith(
      recordingState: RecordingState.idle,
      recordingPath: '',
      recordingPathsMap: updatedPaths,
    ));
  }

  void selectOption(String option) {
    final updatedMcq = Map<String, String>.from(state.mcqAnswers);
    final currentQ = state.questions[state.currentIndex];
    updatedMcq[currentQ.id] = option;
    emit(state.copyWith(selectedOption: option, mcqAnswers: updatedMcq));
  }

  Future<void> submitInterview(String assessmentId) async {
    emit(state.copyWith(submitStatus: RequestState.loading));
    final recordingPaths = state.recordingPathsMap.values.toList();
    final result = await submitInterviewUseCase(SubmitInterviewParams(
      assessmentId: assessmentId,
      recordingPaths: recordingPaths,
      mcqAnswers: state.mcqAnswers,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
        submitStatus: RequestState.error,
        errorMessage: failure.message,
      )),
      (report) => emit(state.copyWith(
        submitStatus: RequestState.success,
        submittedReport: report,
      )),
    );
  }
}
