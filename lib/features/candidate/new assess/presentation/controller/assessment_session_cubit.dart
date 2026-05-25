import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/performance_report.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/question.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/usecases/fetch_assessment_questions_usecase.dart';
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

  // 🌟 متغيرات الوقت
  Timer? _assessmentTimer;
  DateTime? _questionStartTime;
  final List<int> _replyTimesInSeconds = [];
  final String _assessmentTitle = "Software Engineering"; // عشان نستخدمهم في الـ auto submit
  final String _assessmentTrack = "Flutter Developer";

  AssessmentSessionCubit(
    this.fetchQuestionsUseCase,
    this.submitInterviewUseCase,
    this.sendAssessmentUseCase,
  ) : super(const AssessmentSessionState());

  @override
  Future<void> close() {
    _assessmentTimer?.cancel(); // 🌟 تأمين التايمر لما الشاشة تتقفل
    return super.close();
  }

  final int _totalAssessmentMinutes = 3;

  // 🌟 دالة بداية الامتحان والتايمر
  void startAssessmentTimer() {
    int remainingSeconds = _totalAssessmentMinutes * 60;

    _assessmentTimer?.cancel();
    emit(state.copyWith(remainingTimeInSeconds: remainingSeconds));

    _assessmentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        emit(state.copyWith(remainingTimeInSeconds: remainingSeconds));
      } else {
        // 🌟 الوقت خلص!
        _assessmentTimer?.cancel();
        if (state.submitStatus != RequestState.loading &&
            state.submitStatus != RequestState.success) {
          submitInterview(
            state.submittedReport?.title ?? _assessmentTitle,
            state.submittedReport?.track ?? _assessmentTrack,
          );
        }
      }
    });
  }

  // 🌟 دوال الـ avgReply
  void onQuestionShown() {
    _questionStartTime = DateTime.now();
  }

  void onQuestionAnswered() {
    if (_questionStartTime != null) {
      final timeSpent = DateTime.now()
          .difference(_questionStartTime!)
          .inSeconds;
      _replyTimesInSeconds.add(timeSpent);
      _questionStartTime = null; // Reset
    }
  }

  String getAvgReply() {
    if (_replyTimesInSeconds.isEmpty) return "0.0";
    int totalSeconds = _replyTimesInSeconds.reduce((a, b) => a + b);
    double avg = totalSeconds / _replyTimesInSeconds.length;
    return avg.toStringAsFixed(1);
  }

  Future<void> loadQuestions(String title, String track) async {
    emit(state.copyWith(status: RequestState.loading));
    final result = await fetchQuestionsUseCase(
      FetchAssessmentQuestionsParams(title, track),
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
        // 🌟 بدأنا الامتحان! شغل التايمر وسجل أول سؤال
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
      // 🌟 سجلنا سؤال جديد
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

  Future<void> submitInterview(String title, String track) async {
    _assessmentTimer?.cancel(); // 🌟 وقف التايمر
    // 🌟 بنحسب الوقت الفعلي اللي أخدوه (30 دقيقة ناقص اللي اتبقى)
    final timeSpentInSeconds =
        (_totalAssessmentMinutes * 60) - (state.remainingTimeInSeconds ?? 1800);
    final timeSpentInMinutes = (timeSpentInSeconds / 60).toStringAsFixed(1);
    emit(state.copyWith(submitStatus: RequestState.loading));
    final recordingPaths = state.recordingPathsMap.values.toList();
    final result = await submitInterviewUseCase(
      SubmitInterviewParams(
        voiceTextAnswers: state.recordingPathsMap,
        mcqAnswers: state.mcqAnswers,
        originalQuestions: state.questions,
        title: title,
        track: track,
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
    final result = await sendAssessmentUseCase(
      SendAssessmentParams(
        trackName: trackName,
        assessmentName: assessmentName,
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
        getIt<HomeCubit>().loadHomeData();
        getIt<AssessManageCubit>().loadAssessmentHistory();
        if (isClosed) return;
        emit(state.copyWith(sendAssessment: RequestState.success));
      },
    );
  }
}
