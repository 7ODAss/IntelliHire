part of 'assessment_session_cubit.dart';

class AssessmentSessionState extends Equatable {
  final RequestState status;
  final RequestState submitStatus;
  final List<Question> questions;
  final int currentIndex;
  final RecordingState recordingState;
  final String recordingPath;
  final Map<String, String> recordingPathsMap; // questionId → file path
  final String selectedOption;
  final Map<String, String> mcqAnswers; // questionId → selected option
  final PerformanceReport? submittedReport;
  final String errorMessage;
  final bool isCheck;
  final RequestState sendAssessment;
  final String sendAssessmentMessage;
  final int remainingTimeInSeconds;
  final CvData? cv;
  final RequestState cvStatus;
  final String cvMessage;
  final String candidateId;
  final String candidateExp;
  final RequestState candidateIdStatus;
  final String candidateIdMessage;

  const AssessmentSessionState({
    this.status = RequestState.initial,
    this.submitStatus = RequestState.initial,
    this.questions = const [],
    this.currentIndex = 0,
    this.recordingState = RecordingState.idle,
    this.recordingPath = '',
    this.recordingPathsMap = const {},
    this.selectedOption = '',
    this.mcqAnswers = const {},
    this.submittedReport,
    this.errorMessage = '',
    this.isCheck = false,
    this.sendAssessment = RequestState.initial,
    this.sendAssessmentMessage = '',
    this.remainingTimeInSeconds = 1800,
    this.cv,
    this.cvStatus = RequestState.initial,
    this.cvMessage = '',
    this.candidateId = '',
    this.candidateExp = '',
    this.candidateIdStatus = RequestState.initial,
    this.candidateIdMessage = '',
  });

  Question? get currentQuestion =>
      questions.isNotEmpty ? questions[currentIndex] : null;

  bool get isLastQuestion =>
      questions.isNotEmpty && currentIndex == questions.length - 1;

  AssessmentSessionState copyWith({
    RequestState? status,
    RequestState? submitStatus,
    List<Question>? questions,
    int? currentIndex,
    RecordingState? recordingState,
    String? recordingPath,
    Map<String, String>? recordingPathsMap,
    String? selectedOption,
    Map<String, String>? mcqAnswers,
    PerformanceReport? submittedReport,
    String? errorMessage,
    bool? isCheck,
    RequestState? sendAssessment,
    String? sendAssessmentMessage,
    int? remainingTimeInSeconds,
    CvData? cv,
    RequestState? cvStatus,
    String? cvMessage,
    String? candidateId,
    String? candidateExp,
    RequestState? candidateIdStatus,
    String? candidateIdMessage,
  }) => AssessmentSessionState(
    status: status ?? this.status,
    submitStatus: submitStatus ?? this.submitStatus,
    questions: questions ?? this.questions,
    currentIndex: currentIndex ?? this.currentIndex,
    recordingState: recordingState ?? this.recordingState,
    recordingPath: recordingPath ?? this.recordingPath,
    recordingPathsMap: recordingPathsMap ?? this.recordingPathsMap,
    selectedOption: selectedOption ?? this.selectedOption,
    mcqAnswers: mcqAnswers ?? this.mcqAnswers,
    submittedReport: submittedReport ?? this.submittedReport,
    errorMessage: errorMessage ?? this.errorMessage,
    isCheck: isCheck ?? this.isCheck,
    sendAssessment: sendAssessment ?? this.sendAssessment,
    sendAssessmentMessage: sendAssessmentMessage ?? this.sendAssessmentMessage,
    remainingTimeInSeconds:
        remainingTimeInSeconds ?? this.remainingTimeInSeconds,
    cv: cv ?? this.cv,
    cvStatus: cvStatus ?? this.cvStatus,
    cvMessage: cvMessage ?? this.cvMessage,
    candidateId: candidateId ?? this.candidateId,
    candidateExp: candidateExp ?? this.candidateExp,
    candidateIdStatus: candidateIdStatus ?? this.candidateIdStatus,
    candidateIdMessage: candidateIdMessage ?? this.candidateIdMessage,
  );

  @override
  List<Object?> get props => [
    status,
    submitStatus,
    questions,
    currentIndex,
    recordingState,
    recordingPath,
    recordingPathsMap,
    selectedOption,
    mcqAnswers,
    submittedReport,
    errorMessage,
    isCheck,
    sendAssessment,
    sendAssessmentMessage,
    remainingTimeInSeconds,
    cv,
    cvStatus,
    cvMessage,
    candidateId,
    candidateExp,
    candidateIdStatus,
    candidateIdMessage,
  ];
}
