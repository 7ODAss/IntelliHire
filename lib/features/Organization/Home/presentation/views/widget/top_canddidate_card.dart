import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/review%20session%20cubit/cubit/review_session_cubit.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/review_session_view.dart';

class TopCanddidateCard extends StatelessWidget {
  const TopCanddidateCard({
    super.key,
    required this.candidatesCount,
    required this.interviewsCount,
  });

  // ✅ شيلنا تعريف الـ List<ApplicantModel> applicants;
  final int candidatesCount;
  final int interviewsCount;

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
                    color: const Color(0XFFFBBF24),
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
                      Text(
                        "From $interviewsCount Interviews",
                        style: const TextStyle(
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
            Text(
              "$candidatesCount Candidates",
              style: const TextStyle(
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
                  // 🟢 الألوان والزرار "شغال" (Enabled)
                  backgroundColor: Colors.white,
                  foregroundColor: AppColor.darkBlue,

                  // 🔴 الألوان والزرار "مطفى" (Disabled) - دي أهم حتة:
                  disabledBackgroundColor: Colors.white.withValues(alpha: 0.25),
                  disabledForegroundColor: Colors.white.withValues(alpha: 0.5),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: candidatesCount == 0 ? 0 : 2,
                ),
                // هنا بنحدد هل الزرار شغال ولا لأ
                onPressed: candidatesCount == 0
                    ? null // كدة الزرار Disabled وهياخد ألوان الـ disabled اللي فوق
                    : () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return BlocProvider(
                                create: (context) =>
                                    getIt<ReviewSessionCubit>()
                                      ..fetchTopTalentCandidates(),
                                child: const ReviewSessionView(),
                              );
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
