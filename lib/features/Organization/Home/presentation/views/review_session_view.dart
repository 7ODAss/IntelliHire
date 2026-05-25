import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void nextCandidate(int totalCandidates) {
    if (currentIndex < totalCandidates - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewSessionCubit, ReviewSessionState>(
      listener: (context, state) {
        if (state is ReviewDecisionSuccess) {
        } else if (state is ReviewDecisionError) {
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
                  : (state is ReviewSessionLoaded ? state.applicants : []);

              if (!isLoading && applicants.isEmpty) {
                return const Center(child: Text("No candidates to review"));
              }

              final totalCandidates = applicants.length;
              final currentApplicant = applicants[currentIndex];

              return BlocListener<ReviewSessionCubit, ReviewSessionState>(
                listener: (context, state) {
                  if (state is ReviewDecisionSuccess) {
                    nextCandidate(totalCandidates);
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
                          physics: isLoading
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
                                  const Row(
                                    children: [
                                      Expanded(
                                        child: ReportButton(
                                          text: "5+",
                                          label: "Years",
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: ReportButton(
                                          icon:
                                              "assets/image/icon svg/download.svg",
                                          label: "PDF Report",
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: ReportButton(
                                          icon: "assets/image/icon svg/cv.svg",
                                          label: "Download CV",
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
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: isLoading
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
                                          onPressed: isLoading
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
