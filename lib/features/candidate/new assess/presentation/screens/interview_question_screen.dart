import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/presentation/screens/performance_report_screen.dart';
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

class _InterviewQuestionScreenState extends State<InterviewQuestionScreen> {
  void _showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ExitAssessmentDialog(
        onCancel: () => Navigator.pop(context),
        onConfirmExit: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onNext(AssessmentSessionCubit cubit, AssessmentSessionState state) {
    cubit.onQuestionAnswered();

    if (state.isLastQuestion) {
      cubit.submitInterview();
    } else {
      cubit.nextQuestion();
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
      child: BlocListener<AssessmentSessionCubit, AssessmentSessionState>(
        listenWhen: (prev, curr) => prev.submitStatus != curr.submitStatus,
        listener: (context, state) async {
          if (state.submitStatus == RequestState.loading && state.isTimeUp) {
            context.showSnackBar(
              type: SnackBarType.error,
              'Time is up! Submitting your answers automatically...',
            );
          }

          if (state.submitStatus == RequestState.success &&
              state.submittedReport != null) {
            final report = state.submittedReport!;
            final cubit = context.read<AssessmentSessionCubit>();

            await cubit.sendAssessment(
              trackName: state.cv?.jobTitle ?? 'Unknown Position',
              assessmentName: report.title,
              overallAiScore: report.overallAiScore,
              accuracy: report.accuracy,
              avgReply: cubit.getAvgReply(),
              totalQuestions: report.questionsCount,
              duration: report.totalTime,
              questions: report.questions,
            );

            if (!context.mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: getIt<AssessManageCubit>(),
                  child: PerformanceReportScreen(
                    comeFromAssess: true,
                    jobTitle: state.cv?.jobTitle ?? 'Unknown Position',
                    report: report,
                  ),
                ),
              ),
              (route) => route.isFirst,
            );
          } else if (state.submitStatus == RequestState.error) {
            context.showSnackBar(type: SnackBarType.error, state.errorMessage);
          }
        },
        child: BlocBuilder<AssessmentSessionCubit, AssessmentSessionState>(
          buildWhen: (prev, curr) => prev.status != curr.status,
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

            if (state.questions.isEmpty) return const SizedBox.shrink();

            return Scaffold(
              backgroundColor: AppColor.backgroundColor,
              body: SafeArea(
                child: Column(
                  children: [
                    BlocSelector<
                      AssessmentSessionCubit,
                      AssessmentSessionState,
                      ({int number, int total})
                    >(
                      selector: (s) {
                        final q = s.currentQuestion;
                        return (number: q?.number ?? 1, total: q?.total ?? 1);
                      },
                      builder: (context, qInfo) {
                        return QuestionProgressHeader(
                          currentQuestion: qInfo.number,
                          totalQuestions: qInfo.total,
                          onClose: _showExitDialog,
                          timerStream: cubit.timerStream,
                          initialRemainingTime: cubit.remainingSeconds,
                        );
                      },
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            BlocSelector<
                              AssessmentSessionCubit,
                              AssessmentSessionState,
                              String
                            >(
                              selector: (s) => s.currentQuestion?.text ?? '',
                              builder: (context, questionText) {
                                return Container(
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
                                    questionText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: AppFont.interBold,
                                      fontSize: 17,
                                      color: Color(0xFF0F172A),
                                      height: 1.5,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),

                            BlocBuilder<
                              AssessmentSessionCubit,
                              AssessmentSessionState
                            >(
                              buildWhen: (prev, curr) =>
                                  prev.currentIndex != curr.currentIndex ||
                                  prev.selectedOption != curr.selectedOption ||
                                  prev.recordingState != curr.recordingState,
                              builder: (context, s) {
                                final currentQ = s.currentQuestion;
                                if (currentQ == null) {
                                  return const SizedBox.shrink();
                                }

                                if (currentQ.type == QuestionType.mcq) {
                                  return Column(
                                    children: currentQ.options
                                        .map(
                                          (option) => McqOptionTile(
                                            option: option,
                                            isSelected:
                                                s.selectedOption == option,
                                            onTap: () =>
                                                cubit.selectOption(option),
                                          ),
                                        )
                                        .toList(),
                                  );
                                } else {
                                  return const RecordingControlsWidget();
                                }
                              },
                            ),

                            const SizedBox(height: 32),

                            BlocBuilder<
                              AssessmentSessionCubit,
                              AssessmentSessionState
                            >(
                              buildWhen: (prev, curr) =>
                                  prev.currentIndex != curr.currentIndex ||
                                  prev.selectedOption != curr.selectedOption ||
                                  prev.recordingState != curr.recordingState ||
                                  prev.submitStatus != curr.submitStatus,
                              builder: (context, s) {
                                final canProceed = _canProceed(s);
                                final isSubmitting =
                                    s.submitStatus == RequestState.loading;

                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: canProceed && !isSubmitting
                                        ? () => _onNext(cubit, s)
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
                                    child: isSubmitting
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            s.isLastQuestion
                                                ? 'Submit Interview'
                                                : 'Next Question',
                                            style: const TextStyle(
                                              fontFamily: AppFont.interBold,
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
