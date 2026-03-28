import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/models/applicant_model.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/point_text.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/status_card.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.applicant,
    this.isreviewSession = false,
  });
  final ApplicantModel applicant;
  final bool? isreviewSession;
  @override
  Widget build(BuildContext context) {
    return Container(
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
          if (isreviewSession == false)
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
                  icon: SvgPicture.asset("assets/image/icon svg/download.svg"),
                  label: Text(
                    "PDF Report",
                    style: AppTextStyle.textstyle12.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

          Row(
            children: const [
              Expanded(
                child: StatusCard(title: 'Avg. Response', value: '1.5s'),
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
    );
  }
}
