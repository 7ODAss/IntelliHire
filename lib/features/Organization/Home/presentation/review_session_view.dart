import 'package:flutter/material.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/widget/candidate_score_avatar.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/widget/progress_bar.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/widget/review_session_header.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/models/applicant_model.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/report_button.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/report_card.dart';

class ReviewSessionView extends StatefulWidget {
  final List<ApplicantModel> applicants;

  const ReviewSessionView({super.key, required this.applicants});

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

  void nextCandidate() {
    if (currentIndex < widget.applicants.length - 1) {
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
    final currentApplicant = widget.applicants[currentIndex];
    final totalCandidates = widget.applicants.length;

    return Scaffold(
      body: SafeArea(
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
                    onPressed: nextCandidate,
                  ),
                  const SizedBox(height: 20),
                  ProgressBar(
                    currentIndex: currentIndex,
                    total: totalCandidates,
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: totalCandidates,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final applicant = widget.applicants[index];

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        CandidateScoreAvatar(applicant: applicant),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: const ReportButton(
                                text: "5+",
                                label: "Years",
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: const ReportButton(
                                icon: "assets/image/icon svg/download.svg",
                                label: "PDF Report",
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: const ReportButton(
                                icon: "assets/image/icon svg/cv.svg",
                                label: "Download CV",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        ReportCard(applicant: applicant, isreviewSession: true),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    nextCandidate();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                                  onPressed: () {
                                    nextCandidate();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    backgroundColor: const Color(0xFF1967D2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                        ),
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
  }
}
