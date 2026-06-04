import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/presentation/screens/performance_report_screen.dart';
import 'package:intelli_hire/features/candidate/home/presentation/controller/home_cubit.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/cv_data.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/question_type.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/controller/assessment_session_cubit.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/widgets/exit_assessment_dialog.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/widgets/mcq_option_tile.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/widgets/question_progress_header.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/widgets/recording_controls_widget.dart';

import '../../../../../core/enums/snack_bar_type.dart';
import '../../../../../core/service/service_locator.dart';
import '../../../assess manage/presentation/controller/assess_manage_cubit.dart';

class InterviewQuestionScreen extends StatefulWidget {
  const InterviewQuestionScreen({super.key});

  @override
  State<InterviewQuestionScreen> createState() =>
      _InterviewQuestionScreenState();
}

class _InterviewQuestionScreenState extends State<InterviewQuestionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));
    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ExitAssessmentDialog(
        onCancel: () => Navigator.pop(context),
        onConfirmExit: () {
          Navigator.pop(context); // close dialog
          Navigator.pop(context); // exit screen
        },
      ),
    );
  }

  void _onNext(AssessmentSessionCubit cubit, AssessmentSessionState state) {
    // 🌟 سجل إنه جاوب وخد الوقت
    cubit.onQuestionAnswered();

    if (state.isLastQuestion) {
      cubit.submitInterview();
    } else {
      cubit.nextQuestion();
      _entryController
        ..reset()
        ..forward();
    }
  }

  bool _canProceed(AssessmentSessionState state) {
    final q = state.currentQuestion;
    if (q == null) return false;
    if (q.type == QuestionType.audio) {
      return state.recordingState == RecordingState.recorded ||
          state.recordingState == RecordingState.playing;
    } else {
      return state.selectedOption.isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AssessmentSessionCubit>()..startAssessmentFlow(),

      child: BlocConsumer<AssessmentSessionCubit, AssessmentSessionState>(
        listenWhen: (prev, curr) =>
            prev.submitStatus != curr.submitStatus ||
            prev.remainingTimeInSeconds != curr.remainingTimeInSeconds,
        listener: (context, state) async {
          if (state.remainingTimeInSeconds == 0 &&
              state.submitStatus == RequestState.loading) {
            context.showSnackBar(
              type: SnackBarType.error,
              'Time is up! Submitting your answers automatically...',
            );
          }
          if (state.submitStatus == RequestState.success &&
              state.submittedReport != null) {
            final report = state.submittedReport!;
            final cubit = context.read<AssessmentSessionCubit>();

            cubit.sendAssessment(
              trackName: state.cv?.jobTitle ?? 'Unknown Position',
              assessmentName: report.title,
              overallAiScore: report.overallAiScore,
              accuracy: report.accuracy,
              avgReply: cubit.getAvgReply(),
              totalQuestions: report.questionsCount,
              duration: report.totalTime,
              questions: report.questions,
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: getIt<AssessManageCubit>(),
                  child: PerformanceReportScreen(
                    comeFromAssess: true,
                    jobTitle: state.cv?.jobTitle ?? 'Unknown Position',
                    report: state.submittedReport!,
                  ),
                ),
              ),
            );
          } else if (state.submitStatus == RequestState.error) {
            context.showSnackBar(type: SnackBarType.error, state.errorMessage);
          }
        },
        builder: (context, state) {
          final cubit = context.read<AssessmentSessionCubit>();

          if (state.status == RequestState.loading) {
            return const Scaffold(
              backgroundColor: AppColor.backgroundColor,
              body: Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              ),
            );
          }

          if (state.status == RequestState.error) {
            return Scaffold(
              backgroundColor: AppColor.backgroundColor,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(state.errorMessage),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => cubit.startAssessmentFlow(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final question = state.currentQuestion;
          if (question == null) return const SizedBox.shrink();

          return Scaffold(
            backgroundColor: AppColor.backgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  // Dark header
                  QuestionProgressHeader(
                    currentQuestion: question.number,
                    totalQuestions: question.total,
                    onClose: _showExitDialog,
                  ),

                  // Question content
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Question card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  question.text,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: AppFont.interBold,
                                    fontSize: 17,
                                    color: Color(0xFF0F172A),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // MCQ or Audio controls
                              if (question.type == QuestionType.mcq) ...[
                                ...question.options.map(
                                  (option) => McqOptionTile(
                                    option: option,
                                    isSelected: state.selectedOption == option,
                                    onTap: () => cubit.selectOption(option),
                                  ),
                                ),
                              ] else ...[
                                const RecordingControlsWidget(),
                              ],

                              const SizedBox(height: 32),

                              // Next / Submit button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _canProceed(state)
                                      ? () => _onNext(cubit, state)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primary,
                                    disabledBackgroundColor: const Color(
                                      0xFFCBD5E1,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child:
                                      state.submitStatus == RequestState.loading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          state.isLastQuestion
                                              ? 'Submit Interview'
                                              : 'Next Question',
                                          style: const TextStyle(
                                            fontFamily: AppFont.interBold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
