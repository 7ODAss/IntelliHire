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

  // 🌟 متغيرات الوقت
  Timer? _assessmentTimer;
  DateTime? _questionStartTime;
  final List<int> _replyTimesInSeconds = [];

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
          submitInterview();
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

  Future<void> submitInterview() async {
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
    final String exp = state.candidateExp;
    final double years = double.tryParse(exp) ?? 0.0;

    String level = "Junior";
    if (years > 1.5 && years <= 4.0) {
      level = "Mid-Level";
    } else if (years > 4.0) {
      level = "Senior";
    }

    final String finalTitle = "$level $trackName Assessment";

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
        // Do NOT call loadHomeData() here. HomeScreen is alive in the
        // IndexedStack under the newassess route and would rebuild immediately,
        // combining chart/calendar/header work with audio encoding on the main
        // thread → 500+ skipped frames → ANR → Signal 3.
        //
        // Instead, mark the cubit so HomeScreen fetches fresh data the moment
        // it becomes the visible screen again (didChangeDependencies).
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
    // 1. نوري اليوزر الـ Loading الأساسي للشاشة
    emit(state.copyWith(status: RequestState.loading));

    // 2. نجيب الـ ID ونستنى الدالة تخلص
    await getCandidateId();

    // نشيك: لو حصل إيرور وإحنا بنجيب الـ ID، نوقف ونعرض الإيرور
    if (state.candidateIdStatus == RequestState.error) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: state.candidateIdMessage,
        ),
      );
      return; // 🌟 بنوقف التنفيذ هنا عشان ميكملش
    }

    // بما إنه نجح، نقرأ الـ ID من الـ State
    final String id = state.candidateId;

    // 3. نجيب الـ CV باستخدام الـ ID ونستنى يخلص
    await getCandidateCv(id);

    // نشيك: لو حصل إيرور وإحنا بنجيب الـ CV، نوقف ونعرض الإيرور
    if (state.cvStatus == RequestState.error) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: state.cvMessage,
        ),
      );
      return;
    }

    // بما إنه نجح، نقرأ الـ CV من الـ State
    final CvData cv = state.cv!;

    // 4. أخيراً، نبعت الـ CV لدالة الأسئلة (وهي جواها بتعمل emit للـ Success أو الـ Error بتاعها)
    await loadQuestions(cv);
  }
}
