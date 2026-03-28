import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/models/applicant_model.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/custom_avatar.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/custom_pop_button.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/point_text.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/report_button.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/status_card.dart';

class CandidateReportView extends StatelessWidget {
  const CandidateReportView({super.key, required this.applicant});
  final ApplicantModel applicant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
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
                          color: applicant.aiScore > 80
                              ? const Color(0xFF15803D)
                              : (applicant.aiScore > 50
                                    ? const Color(0xFFCA8A04)
                                    : const Color(0xFFDC2626)),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        "${applicant.aiScore}%",
                        style: AppTextStyle.textstyle12.copyWith(
                          color: applicant.aiScore > 80
                              ? const Color(0xFF15803D)
                              : (applicant.aiScore > 50
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
              Text(
                applicant.role,
                style: AppTextStyle.textstyle12.copyWith(
                  color: const Color(0xff475569),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ReportButton(
                    icon: "assets/image/icon svg/message.svg",
                    label: "Email",
                  ),
                  SizedBox(width: 12),
                  ReportButton(
                    icon: "assets/image/icon svg/phone.svg",
                    label: "Call",
                  ),
                  SizedBox(width: 12),
                  ReportButton(
                    icon: "assets/image/icon svg/cv.svg",
                    label: "Download CV",
                  ),
                ],
              ),
              const SizedBox(height: 26),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffF0F4F8), Color(0xffF8FAFC)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "AI Interview Report",
                          style: AppTextStyle.textstyle16.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFont.interBold,
                            color: AppColor.darkBlue,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          icon: SvgPicture.asset(
                            "assets/image/icon svg/download.svg",
                          ),
                          label: Text(
                            "PDF Report",
                            style: AppTextStyle.textstyle12.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: const [
                        Expanded(
                          child: StatusCard(
                            title: 'Avg. Response',
                            value: '1.5s',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: StatusCard(title: "Accuracy", value: "94%"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Strength Points",
                      style: TextStyle(
                        color: Color(0xff22C55E),
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFont.interBold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...applicant.strengths.map(
                      (strength) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PointText(text: strength),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Weakness Points",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...applicant.weaknesses.map(
                      (weakness) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PointText(text: weakness),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<ApplicantsCubit>().updateApplicantStatus(
                          applicant.id,
                          "Rejected",
                        );
                        Navigator.pop(context);
                      },
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
                      onPressed: () {
                        context.read<ApplicantsCubit>().updateApplicantStatus(
                          applicant.id,
                          "Accepted",
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
