import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/review_session_view.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/models/applicant_model.dart';

class TopCanddidateCard extends StatelessWidget {
  const TopCanddidateCard({super.key, required this.applicants});
  final List<ApplicantModel> applicants;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.darkBlue, Color(0XFF405293)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0XFFFBBF24),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "Action Required",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppFont.interBold,
                      color: Color(0XFF475569),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/image/icon svg/stack.svg",
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "From 2 Interviews",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFont.interBold,
                          color: Color(0XFFF8FAFC),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "5 Candidates",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                fontFamily: AppFont.interBold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Scored +90% (Top Talent)",
              style: TextStyle(
                color: Color(0XFFB9C2FD),
                fontSize: 14,
                fontFamily: AppFont.interRegular,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColor.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return ReviewSessionView(applicants: applicants);
                      },
                    ),
                  );
                },
                child: const Text(
                  "Start Unified Review >",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFont.interBold,
                    color: AppColor.darkBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
