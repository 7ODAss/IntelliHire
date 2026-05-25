import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class EmptyHomeBody extends StatelessWidget {
  final String companyName;

  const EmptyHomeBody({super.key, required this.companyName});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: size.height * 0.06, // كانت 54 (بقت نسبة من طول الشاشة)
            left: 24,
            right: 24,
            bottom: size.height * 0.08, // كانت 70
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back",
                      style: AppTextStyle.textstyle12.copyWith(
                        color: const Color(0xff475569),
                      ),
                    ),
                    Text(
                      companyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFont.poppinsBold,
                      ),
                    ),
                  ],
                ),
              ),
              // الـ Avatar الدائري
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

        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.08,
              right: size.width * 0.08,
              bottom: size.height * 0.2,
            ), // كانت 32 ثابتة
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الصورة
                SvgPicture.asset(
                  "assets/image/icon svg/rocket.svg",
                  height: size.height * 0.18,
                ),
                SizedBox(height: size.height * 0.04), // 🔴 كانت 32
                // العنوان
                const Text(
                  "Welcome to IntelliHire!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFont.interBold,
                    color: AppColor.darkBlue,
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                // الوصف (Subtitle)
                const Text(
                  "You haven't posted any jobs yet. Start looking for top tech talent by creating your first job post.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFont.interRegular,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
