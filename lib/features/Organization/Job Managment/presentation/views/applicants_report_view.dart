import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intelli_hire/core/models/applicant_model.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/report_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/appliocants_cubit/applicants_state.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/custom_avatar.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/custom_pop_button.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/report_card.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/report_button.dart';

class CandidateReportView extends StatelessWidget {
  const CandidateReportView({super.key, required this.applicant});
  final ApplicantModel applicant;

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching dialer: $e');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Interview Feedback - IntelliHire',
    );
    try {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching email client: $e');
    }
  }

  Future<void> _downloadCV(String sessionId, String applicantName) async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      String savePath =
          "${dir.path}/${applicantName.replaceAll(' ', '_')}_CV.pdf";

      await ApiService().download(
        endPoint: "api/Employer/$sessionId/download/cv",
        savePath: savePath,
      );

      await OpenFilex.open(savePath);
    } catch (e) {
      debugPrint("CV Download Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<ApplicantsCubit, ApplicantsState>(
          listener: (context, state) {
            if (state is DecisionSuccess) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            String email = "";
            String phone = "";
            double displayScore = applicant.aiScore.toDouble();

            ReportEntity currentReport = ReportEntity(
              sessionId: applicant.sessionId,
              strengthPoints: 'Loading... | Loading...',
              weaknessesPoints: 'Loading...',
              accuracyPercent: 0.0,
              averageResponseTime: 'Loading...',
            );

            if (state is ApplicantPreviewLoaded) {
              email = state.reportData.email ?? "";
              phone = state.reportData.phone ?? "";
              displayScore = state.reportData.accuracyPercent ?? displayScore;

              currentReport = ReportEntity(
                sessionId: applicant.sessionId,
                fullName: state.reportData.fullName,
                email: state.reportData.email,
                phone: state.reportData.phone,
                averageResponseTime: state.reportData.averageResponseTime,
                accuracyPercent: state.reportData.accuracyPercent,
                strengthPoints: state.reportData.strengthPoints,
                weaknessesPoints: state.reportData.weaknessesPoints,
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: CustomPopButton(),
                      ),
                      Center(
                        child: Text(
                          "Candidate Report",
                          style: AppTextStyle.textstyle14.copyWith(
                            color: const Color(0xff475569),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CustomAvatar(name: applicant.name, height: 96, width: 96),
                      Positioned(
                        top: -12,
                        right: -18,
                        child: Container(
                          padding: const EdgeInsets.all(8.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: displayScore > 80
                                  ? const Color(0xFF15803D)
                                  : (displayScore > 50
                                        ? const Color(0xFFCA8A04)
                                        : const Color(0xFFDC2626)),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            "${displayScore.round()}%",
                            style: AppTextStyle.textstyle12.copyWith(
                              color: displayScore > 80
                                  ? const Color(0xFF15803D)
                                  : (displayScore > 50
                                        ? const Color(0xFFCA8A04)
                                        : const Color(0xFFDC2626)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    applicant.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColor.darkBlue,
                      fontFamily: AppFont.interBold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(applicant.role, style: AppTextStyle.textstyle12),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReportButton(
                        onPressed: () {
                          if (email.isNotEmpty) _sendEmail(email);
                        },
                        icon: "assets/image/icon svg/message.svg",
                        label: "Email",
                      ),
                      const SizedBox(width: 12),
                      ReportButton(
                        onPressed: () {
                          if (phone.isNotEmpty) _makeCall(phone);
                        },
                        icon: "assets/image/icon svg/phone.svg",
                        label: "Call",
                      ),
                      const SizedBox(width: 12),
                      ReportButton(
                        onPressed: () {
                          _downloadCV(applicant.sessionId, applicant.name);
                        },
                        icon: "assets/image/icon svg/cv.svg",
                        label: "Download CV",
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Skeletonizer(
                    enabled: state is ApplicantPreviewLoading,
                    child: ReportCard(
                      report: currentReport,
                      isreviewSession: false,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context
                              .read<ApplicantsCubit>()
                              .submitDecision(applicant.sessionId, 2),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey.shade300),
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
                          onPressed: () => context
                              .read<ApplicantsCubit>()
                              .submitDecision(applicant.sessionId, 1),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF1967D2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
