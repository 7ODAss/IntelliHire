import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/widget/state_item.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.24,
            padding: const EdgeInsets.only(top: 54, left: 24, right: 24),
            decoration: BoxDecoration(
              color: AppColor.darkBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back",
                      style: AppTextStyle.textstyle12.copyWith(
                        color: const Color(0XFFF2F2F2),
                      ),
                    ),
                    const Text(
                      "TechCorp",
                      style: TextStyle(
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
                        color: Color(0XFFF2F2F2),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0XFFD6D6D6), width: 2),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Color(0xffB9C2FD).withValues(alpha: 0.35),
                    child: Text(
                      "TC",
                      style: TextStyle(
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
          Positioned(
            top: MediaQuery.of(context).size.height * 0.24 - 50,
            left: 20,
            right: 20,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StateItem(
                    iconPath: "assets/image/icon svg/Interviews.svg",
                    count: "4",
                    label: "Interviews",
                  ),
                  const VerticalDivider(indent: 20, endIndent: 20),
                  StateItem(
                    iconPath: "assets/image/icon svg/candidates.svg",
                    count: "31",
                    label: "Candidates",
                  ),

                  const VerticalDivider(indent: 20, endIndent: 20),
                  StateItem(
                    iconPath: "assets/image/icon svg/pending.svg",
                    count: "20",
                    label: "Pending",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
