import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/performance_report.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/cv_data.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/question.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/usecases/fetch_assessment_questions_usecase.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/usecases/get_candidate_cv_usecase.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/usecases/get_candidate_id_usecase.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/usecases/send_assessment_usecase.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/usecases/submit_interview_usecase.dart';

import '../../../../../core/service/service_locator.dart';
import '../../../assess manage/domain/entities/question_result.dart';
import '../../../assess manage/presentation/controller/assess_manage_cubit.dart';
import '../../../home/presentation/controller/home_cubit.dart';

part 'assessment_session_state.dart';

enum RecordingState { idle, recording, recorded, playing }

class AssessmentSessionCubit extends Cubit<AssessmentSessionState> {
  final FetchAssessmentQuestionsUseCase fetchQuestionsUseCase;
  final SubmitInterviewUseCase submitInterviewUseCase;
  final SendAssessmentUseCase sendAssessmentUseCase;
  final GetCandidateIdUseCase getCandidateIdUseCase;
  final GetCandidateCvUseCase getCandidateCvUseCase;
  AssessmentSessionCubit(
    this.fetchQuestionsUseCase,
    this.submitInterviewUseCase,
    this.sendAssessmentUseCase,
    this.getCandidateIdUseCase,
    this.getCandidateCvUseCase,
  ) : super(const AssessmentSessionState());

  Timer? _assessmentTimer;
  DateTime? _questionStartTime;
  final List<int> _replyTimesInSeconds = [];

  @override
  Future<void> close() {
    _assessmentTimer?.cancel();
    _timerController.close();
    return super.close();
  }

  final int _totalAssessmentMinutes = 10;
  int _remainingSeconds = 10 * 60;
  int get remainingSeconds => _remainingSeconds;
  final _timerController = StreamController<int>.broadcast();
  Stream<int> get timerStream => _timerController.stream;

  void startAssessmentTimer() {
    _remainingSeconds = _totalAssessmentMinutes * 60;

    _assessmentTimer?.cancel();
    _timerController.add(_remainingSeconds);

    _assessmentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _timerController.add(_remainingSeconds);
      } else {
        _assessmentTimer?.cancel();
        if (state.submitStatus != RequestState.loading &&
            state.submitStatus != RequestState.success) {
          submitInterview(isTimeUp: true);
        }
      }
    });
  }

  void onQuestionShown() {
    _questionStartTime = DateTime.now();
  }

  void onQuestionAnswered() {
    if (_questionStartTime != null) {
      final timeSpent = DateTime.now()
          .difference(_questionStartTime!)
          .inSeconds;
      _replyTimesInSeconds.add(timeSpent);
      _questionStartTime = null;
    }
  }

  String getAvgReply() {
    if (_replyTimesInSeconds.isEmpty) return "0.0";
    int totalSeconds = _replyTimesInSeconds.reduce((a, b) => a + b);
    double avg = totalSeconds / _replyTimesInSeconds.length;
    return avg.toStringAsFixed(1);
  }

  Future<void> loadQuestions(CvData cv) async {
    emit(state.copyWith(status: RequestState.loading, cv: cv));
    final result = await fetchQuestionsUseCase(
      FetchAssessmentQuestionsParams(cv: cv),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (questions) {
        emit(
          state.copyWith(
            status: RequestState.success,
            questions: questions,
            currentIndex: 0,
          ),
        );
        startAssessmentTimer();
        onQuestionShown();
      },
    );
  }

  void nextQuestion() {
    final next = state.currentIndex + 1;
    if (next < state.questions.length) {
      emit(
        state.copyWith(
          currentIndex: next,
          recordingState: RecordingState.idle,
          recordingPath: '',
          selectedOption: '',
        ),
      );
      onQuestionShown();
    }
  }

  void onRecordingStarted() {
    emit(
      state.copyWith(
        recordingState: RecordingState.recording,
        recordingPath: '',
      ),
    );
  }

  void onRecordingStopped(String path) {
    final updatedPaths = Map<String, String>.from(state.recordingPathsMap);
    final currentQ = state.questions[state.currentIndex];
    updatedPaths[currentQ.id] = path;
    emit(
      state.copyWith(
        recordingState: RecordingState.recorded,
        recordingPath: path,
        recordingPathsMap: updatedPaths,
      ),
    );
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
    emit(
      state.copyWith(
        recordingState: RecordingState.idle,
        recordingPath: '',
        recordingPathsMap: updatedPaths,
      ),
    );
  }

  void selectOption(String option) {
    final updatedMcq = Map<String, String>.from(state.mcqAnswers);
    final currentQ = state.questions[state.currentIndex];
    updatedMcq[currentQ.id] = option;
    emit(state.copyWith(selectedOption: option, mcqAnswers: updatedMcq));
  }

  Future<void> submitInterview({bool isTimeUp = false}) async {
    _assessmentTimer?.cancel();
    final timeSpentInSeconds =
        (_totalAssessmentMinutes * 60) - _remainingSeconds;
    final timeSpentInMinutes = (timeSpentInSeconds / 60).toStringAsFixed(1);
    emit(
      state.copyWith(
        submitStatus: RequestState.loading,
        isTimeUp: isTimeUp,
        remainingTimeInSeconds: _remainingSeconds,
      ),
    );

    final result = await submitInterviewUseCase(
      SubmitInterviewParams(
        voiceTextAnswers: state.recordingPathsMap,
        mcqAnswers: state.mcqAnswers,
        originalQuestions: state.questions,
        cv: state.cv!,
        avgReply: getAvgReply(),
        totalTime: timeSpentInMinutes,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          submitStatus: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (report) => emit(
        state.copyWith(
          submitStatus: RequestState.success,
          submittedReport: report,
        ),
      ),
    );
  }

  void onCheck(bool value) {
    emit(state.copyWith(isCheck: value));
  }

  Future<void> sendAssessment({
    required String trackName,
    required String assessmentName,
    required double overallAiScore,
    required double accuracy,
    required String avgReply,
    required int totalQuestions,
    required String duration,
    required List<QuestionResult> questions,
  }) async {
    emit(state.copyWith(sendAssessment: RequestState.loading));

    final String finalTitle = "$trackName Assessment";

    final result = await sendAssessmentUseCase(
      SendAssessmentParams(
        trackName: trackName,
        assessmentName: finalTitle,
        overallAiScore: overallAiScore,
        accuracy: accuracy,
        avgReply: avgReply,
        totalQuestions: totalQuestions,
        duration: duration,
        questions: questions,
      ),
    );

    result.fold(
      (l) {
        if (isClosed) return;
        emit(
          state.copyWith(
            sendAssessment: RequestState.error,
            sendAssessmentMessage: l.message,
          ),
        );
      },
      (r) {
        getIt<HomeCubitCandidate>().markNeedsRefresh();
        getIt<AssessManageCubit>().loadAssessmentHistory();
        if (isClosed) return;
        emit(state.copyWith(sendAssessment: RequestState.success));
      },
    );
  }

  Future<void> getCandidateId() async {
    emit(state.copyWith(candidateIdStatus: RequestState.loading));
    final result = await getCandidateIdUseCase(NoParameters());
    result.fold(
      (l) => emit(
        state.copyWith(
          candidateIdStatus: RequestState.error,
          candidateIdMessage: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          candidateIdStatus: RequestState.success,
          candidateId: r.$1,
          candidateExp: r.$2,
        ),
      ),
    );
  }

  Future<void> getCandidateCv(String candidateId) async {
    emit(state.copyWith(cvStatus: RequestState.loading));
    final result = await getCandidateCvUseCase(
      GetCandidateCvParams(candidateId),
    );
    result.fold(
      (l) => emit(
        state.copyWith(cvStatus: RequestState.error, cvMessage: l.message),
      ),
      (r) => emit(state.copyWith(cvStatus: RequestState.success, cv: r)),
    );
  }

  Future<void> startAssessmentFlow() async {
    emit(state.copyWith(status: RequestState.loading));
    await getCandidateId();

    if (state.candidateIdStatus == RequestState.error) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: state.candidateIdMessage,
        ),
      );
      return;
    }

    final String id = state.candidateId;

    await getCandidateCv(id);

    if (state.cvStatus == RequestState.error) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: state.cvMessage,
        ),
      );
      return;
    }

    final CvData cv = state.cv!;

    await loadQuestions(cv);
  }
}
