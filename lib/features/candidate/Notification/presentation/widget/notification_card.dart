import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.isRead,
    required this.title,
    required this.time,
    required this.description,
    this.onTap, // 🔴 1. ضفنا دي
  });

  final bool isRead;
  final String title;
  final String time;
  final String description;
  final VoidCallback? onTap; // 🔴 2. وعرفناها هنا

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 🔴 3. شغلنا الضغطة هنا
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead
              ? Colors.white
              : Color.alphaBlend(
                  const Color(0xFFB9C2FD).withValues(alpha: 0.3),
                  Colors.white,
                ),

          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0XFFAFAFAF), width: 0.5),

          boxShadow: [
            BoxShadow(
              color: const Color(0Xff3d3d3d).withValues(alpha: 0.25),
              blurRadius: 5,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isRead
                    ? const Color(0xFFF3F4F6)
                    : Color.alphaBlend(
                        const Color(0XFF8499FB).withValues(alpha: 0.3),
                        Colors.white,
                      ),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/image/icon svg/bell.svg",
                colorFilter: ColorFilter.mode(
                  isRead ? const Color(0xFF9CA3AF) : AppColor.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.textstyle14.copyWith(
                          fontFamily: AppFont.interBold,
                          fontWeight: FontWeight.w700,
                          color: AppColor.darkBlue,
                        ),
                      ),
                      Text(
                        time,
                        style: AppTextStyle.textstyle12.copyWith(
                          color: const Color(0XFF898989),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyle.textstyle12.copyWith(
                      color: const Color(0XFF475569),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
