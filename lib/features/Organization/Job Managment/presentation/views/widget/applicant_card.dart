import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/models/applicant_model.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/applicants_report_view.dart'; 
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/widget/custom_avatar.dart';

class ApplicantCard extends StatelessWidget {
  // 🔴 1. ضفنا الـ jobId هنا عشان الكارت يقدر يستخدمه في الـ Refresh
  const ApplicantCard({super.key, required this.applicant, required this.jobId}); 
  
  final ApplicantModel applicant;
  final String jobId; // 🔴 2. تعريف المتغير

  Map<String, Color> getStatusColors(String status) {
    switch (status) {
      case "Pending":
        return {
          "bg": const Color(0xFF8499FB).withValues(alpha: 0.2),
          "text": AppColor.primary,
        };
      case "Accepted":
        return {
          "bg": const Color(0xFF86EFAC).withValues(alpha: 0.2),
          "text": const Color(0xff15803D),
        };
      case "Rejected":
        return {
          "bg": const Color(0xFFFCA5A5).withValues(alpha: 0.2),
          "text": const Color(0xFFDC2626),
        };
      default:
        return {"bg": Colors.grey.shade200, "text": Colors.grey.shade800};
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColors = getStatusColors(applicant.status);

    Color scoreBgColor = applicant.aiScore > 80
        ? const Color(0xFF4ADE80).withValues(alpha: 0.2)
        : (applicant.aiScore > 50
              ? const Color(0xFFFEF08A).withValues(alpha: 0.2)
              : const Color(0xFFFECACA).withValues(alpha: 0.2));
    Color scoreTextColor = applicant.aiScore > 80
        ? const Color(0xFF15803D)
        : (applicant.aiScore > 50
              ? const Color(0xFFCA8A04)
              : const Color(0xFFDC2626));

    return GestureDetector(
      // 🔴 3. خلينا الدالة async عشان نستنى الشاشة تقفل
      onTap: () async {
        // 1. جلب بيانات التقرير
        context.read<ApplicantsCubit>().fetchApplicantPreview(
          applicant.sessionId,
        );

        // 2. الانتقال للشاشة بالاسم الجديد (مع إضافة await)
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (newContext) => BlocProvider.value(
              value: context.read<ApplicantsCubit>(),
              child: CandidateReportView(
                applicant: applicant,
              ),
            ),
          ),
        ).then((value) {
          // 🔴 4. أول ما نرجع من التقرير (الشاشة تقفل)، بننادي الكيوبت يحدث اللستة فوراً
          context.read<ApplicantsCubit>().fetchApplicantsForJob(jobId);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.25),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAvatar(name: applicant.name, width: 48, height: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          applicant.name,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: AppFont.poppinsBold,
                            color: AppColor.darkBlue,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: scoreBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "AI Score : ${applicant.aiScore} %",
                          style: TextStyle(
                            color: scoreTextColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppFont.interRegular,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    applicant.role,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: AppTextStyle.textstyle12.copyWith(
                      color: const Color(0xff475569),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColors["bg"],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      applicant.status,
                      style: TextStyle(
                        color: statusColors["text"],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFont.interRegular,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Icon(Icons.chevron_right, color: Colors.grey, size: 15),
            ),
          ],
        ),
      ),
    );
  }
}