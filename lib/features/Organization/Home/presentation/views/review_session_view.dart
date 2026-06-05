import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:dio/dio.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/core/models/applicant_model.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/review%20session%20cubit/cubit/review_session_cubit.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/review%20session%20cubit/cubit/review_session_state.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/widget/candidate_score_avatar.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/widget/progress_bar.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/widget/review_session_header.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/report_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/report_button.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/report_card.dart'
    as job;
import 'package:skeletonizer/skeletonizer.dart';

class ReviewSessionView extends StatefulWidget {
  const ReviewSessionView({super.key});

  @override
  State<ReviewSessionView> createState() => _ReviewSessionViewState();
}

class _ReviewSessionViewState extends State<ReviewSessionView> {
  int currentIndex = 0;
  late PageController _pageController;
  bool _isSubmitting = false;
  List<ApplicantModel>? _localApplicants;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void removeCurrentCandidateAndTransition() {
    if (_localApplicants == null || _localApplicants!.isEmpty) return;

    final int total = _localApplicants!.length;

    if (total == 1) {
      // Last candidate in the list, close the screen
      Navigator.pop(context);
      return;
    }

    if (currentIndex < total - 1) {
      // 1. Animate to the next candidate (page = currentIndex + 1)
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // 2. After animation completes, remove the candidate and reset controller silently
      Future.delayed(const Duration(milliseconds: 310), () {
        if (!mounted) return;
        setState(() {
          _localApplicants!.removeAt(currentIndex);
          // currentIndex remains the same because the next candidate shifted down
          // We jump silently to the same index to sync the PageController
          _pageController.jumpToPage(currentIndex);
        });
      });
    } else {
      // We are on the last candidate in the list (but total > 1)
      // 1. Animate to the previous candidate (page = currentIndex - 1)
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // 2. After animation completes, remove the candidate and reset controller silently
      Future.delayed(const Duration(milliseconds: 310), () {
        if (!mounted) return;
        setState(() {
          _localApplicants!.removeAt(currentIndex);
          currentIndex = currentIndex - 1;
          _pageController.jumpToPage(currentIndex);
        });
      });
    }
  }

  Future<void> _downloadFile({
    required String sessionId,
    required String applicantName,
    required String fileType, // 'cv' or 'report'
  }) async {
    final suffix = fileType == 'cv' ? 'CV' : 'Report';
    try {
      final endpoint = "api/Employer/$sessionId/download/$fileType";
      
      final directory = await getApplicationDocumentsDirectory();
      final savePath = "${directory.path}/${applicantName.replaceAll(' ', '_')}_$suffix.pdf";

      print("--- [DOWNLOAD REQUEST] Start ---");
      print("Endpoint: $endpoint");
      print("Save Path: $savePath");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Downloading $suffix..."),
          duration: const Duration(seconds: 1),
        ),
      );

      await ApiService().download(
        endPoint: endpoint,
        savePath: savePath,
      );

      print("--- [DOWNLOAD RESPONSE] Success ---");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$suffix downloaded successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      await OpenFilex.open(savePath);
    } catch (e) {
      print("--- [DOWNLOAD ERROR] Failed ---");
      print("Error: $e");
      if (!mounted) return;

      String message = "Failed to download $suffix.";
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 500) {
          message = "Failed to download $suffix: Candidate may not have a $suffix uploaded.";
        } else if (statusCode == 404) {
          message = "Failed to download $suffix: File not found on the server.";
        } else {
          message = "Failed to download $suffix: Server error ($statusCode)";
        }
      } else {
        message = "Failed to download $suffix: ${e.toString().split('\n').first}";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewSessionCubit, ReviewSessionState>(
      listener: (context, state) {
        if (state is ReviewDecisionSubmitting) {
          setState(() {
            _isSubmitting = true;
          });
        } else if (state is ReviewDecisionSuccess) {
          setState(() {
            _isSubmitting = false;
          });
        } else if (state is ReviewDecisionError) {
          setState(() {
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ReviewSessionCubit, ReviewSessionState>(
            buildWhen: (previous, current) {
              return current is! ReviewDecisionSubmitting &&
                  current is! ReviewDecisionSuccess &&
                  current is! ReviewDecisionError;
            },
            builder: (context, state) {
              if (state is ReviewSessionError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              final bool isLoading =
                  state is ReviewSessionLoading ||
                  state is ReviewSessionInitial;

              if (!isLoading && _localApplicants == null && state is ReviewSessionLoaded) {
                _localApplicants = List.from(state.applicants);
              }

              // 🟢 Using a dummy model for Skeletonizer instead of ApplicantModel.empty()
              final List<ApplicantModel> applicants = isLoading
                  ? [
                      ApplicantModel.fromJson({
                        "sessionId": "",
                        "name": "Loading Name...",
                        "role": "Loading Role...",
                        "aiScore": 0,
                        "status": "Pending",
                        "experienceYears": 0,
                        "avgResponseTime": 0.0,
                        "accuracyPercent": 0,
                        "strengthPoints": "",
                        "weaknessPoints": "",
                      }),
                    ]
                  : (_localApplicants ?? []);

              if (!isLoading && applicants.isEmpty) {
                return const Center(child: Text("No candidates to review"));
              }

              final totalCandidates = applicants.length;
              final currentApplicant = applicants[currentIndex];

              return BlocListener<ReviewSessionCubit, ReviewSessionState>(
                listener: (context, state) {
                  if (state is ReviewDecisionSuccess) {
                    removeCurrentCandidateAndTransition();
                  }
                },
                child: Skeletonizer(
                  enabled: isLoading,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 10.0,
                        ),
                        child: Column(
                          children: [
                            ReviewSessionHeader(
                              role: currentApplicant.role,
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(height: 20),
                            ProgressBar(
                              currentIndex: currentIndex,
                              total: isLoading
                                  ? 5
                                  : totalCandidates, 
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: (isLoading || _isSubmitting)
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                          itemCount: totalCandidates,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final applicant = applicants[index];

                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 16),
                                  CandidateScoreAvatar(applicant: applicant),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: ReportButton(
                                            text: "${applicant.experienceYears}+",
                                            label: "Years",
                                            onPressed: () {},
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ReportButton(
                                          icon:
                                              "assets/image/icon svg/download.svg",
                                          label: "PDF Report",
                                          onPressed: () {
                                            _downloadFile(
                                              sessionId: applicant.sessionId,
                                              applicantName: applicant.name,
                                              fileType: "report",
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ReportButton(
                                          icon: "assets/image/icon svg/cv.svg",
                                          label: "Download CV",
                                          onPressed: () {
                                            _downloadFile(
                                              sessionId: applicant.sessionId,
                                              applicantName: applicant.name,
                                              fileType: "cv",
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  job.ReportCard(
                                    isreviewSession: true,
                                    report: ReportEntity(
                                      sessionId: applicant.sessionId,
                                      fullName: applicant.name,
                                      accuracyPercent:
                                          applicant.accuracyPercent,
                                      averageResponseTime: applicant
                                          .averageResponseTime
                                          .toString(),
                                      strengthPoints: applicant.strengths.join(' | '),
                                      weaknessesPoints: applicant.weaknesses.join(' | '),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: (isLoading || _isSubmitting)
                                              ? null
                                              : () {
                                                  context
                                                      .read<
                                                        ReviewSessionCubit
                                                      >()
                                                      .submitDecision(
                                                        applicant.sessionId,
                                                        2, // 🔴 رفض
                                                      );
                                                },
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            side: const BorderSide(
                                              color: Colors.red,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            "Reject",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: (isLoading || _isSubmitting)
                                              ? null
                                              : () {
                                                  context
                                                      .read<
                                                        ReviewSessionCubit
                                                      >()
                                                      .submitDecision(
                                                        applicant.sessionId,
                                                        1, // 🟢 قبول
                                                      );
                                                },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            backgroundColor: const Color(
                                              0xFF1967D2,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            "Accept",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
