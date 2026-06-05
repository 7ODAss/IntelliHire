import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/widget/state_item.dart';

class TopSection extends StatelessWidget {
  const TopSection({
    super.key,
    required this.interviews,
    required this.candidates,
    required this.pending,
    required this.companyName,
  });
  final String interviews;
  final String candidates;
  final String pending;
  final String companyName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. الجزء الأزرق العلوي
        Container(
          // 🔴 زودنا padding من تحت (bottom: 70) عشان ندي مساحة للكارت الأبيض يترفع عليها
          padding: const EdgeInsets.only(
            top: 54,
            left: 24,
            right: 24,
            bottom: 70,
          ),
          decoration: const BoxDecoration(
            color: AppColor.darkBlue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back",
                      style: AppTextStyle.textstyle12.copyWith(
                        color: const Color(0XFFF2F2F2),
                      ),
                    ),
                    Text(
                      companyName,
                      maxLines: 1,
                      overflow: TextOverflow
                          .ellipsis, // بيمنع الاسم إنه يبوظ الارتفاع
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFont.poppinsBold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Here is today's summary",
                      style: AppTextStyle.textstyle14.copyWith(
                        color: const Color(0XFFF2F2F2),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0XFFD6D6D6), width: 2),
                ),
                child: CircleAvatar(
                  backgroundColor: const Color(
                    0xffB9C2FD,
                  ).withValues(alpha: 0.35),
                  child: Text(
                    (companyName.trim().split(" ").length == 1
                            ? companyName.trim()[0]
                            : companyName.trim().split(" ").first[0] +
                                  companyName.trim().split(" ").last[0])
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Color(0XFF021442),
                      fontSize: 15,
                      fontFamily: AppFont.poppinsRegular,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 2. كارت الإحصائيات الأبيض المرفوع
        Align(
          heightFactor:
              0.5, // 🔴 السحر اللي بيمسح الـ Gap ويخلي الـ TopCandidateCard يلزق تحته
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: const Offset(
              0,
              -50,
            ), // بيرفع الكارت 50 بيكسل لفوق يركب على الأزرق
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: StateItem(
                        iconPath: "assets/image/icon svg/Interviews.svg",
                        count: interviews,
                        label: "Interviews",
                      ),
                    ),
                    const VerticalDivider(indent: 20, endIndent: 20, width: 12),
                    Expanded(
                      child: StateItem(
                        iconPath: "assets/image/icon svg/candidates.svg",
                        count: candidates,
                        label: "Candidates",
                      ),
                    ),
                    const VerticalDivider(indent: 20, endIndent: 20, width: 12),
                    Expanded(
                      child: StateItem(
                        iconPath: "assets/image/icon svg/pending.svg",
                        count: pending,
                        label: "Pending",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
