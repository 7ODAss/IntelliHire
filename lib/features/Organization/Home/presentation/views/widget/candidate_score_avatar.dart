import 'package:flutter/material.dart';
import 'package:intelli_hire/core/models/applicant_model.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/custom_avatar.dart';

class CandidateScoreAvatar extends StatelessWidget {
  const CandidateScoreAvatar({super.key, required this.applicant});
  final ApplicantModel applicant;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}
