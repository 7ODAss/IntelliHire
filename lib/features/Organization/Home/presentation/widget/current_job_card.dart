import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/widget/stauts_box.dart';

class CurrentJobCard extends StatelessWidget {
  const CurrentJobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8D5D6), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Senior React Developer",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFont.interBold,
                        color: AppColor.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 18,
                          color: Color(0XFF475569),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Posted Oct 25, 2023",
                          style: AppTextStyle.textstyle12.copyWith(
                            color: const Color(0XFF475569),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF101828),
                  size: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFFEAECF0), width: 1),
                ),
                color: Colors.white,
                elevation: 8,
                offset: const Offset(-17, 35),
                constraints: const BoxConstraints(minWidth: 55, maxWidth: 55),
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == 'team') {
                    debugPrint('Team clicked');
                  } else if (value == 'edit') {
                    debugPrint('Edit clicked');
                  } else if (value == 'delete') {
                    debugPrint('Delete clicked');
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'team',
                    height: 30,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Icon(
                        Icons.people_alt,
                        color: Color(0xFF1877F2),
                        size: 20,
                      ),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'edit',
                    height: 30,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.penToSquare,
                        color: Color(0xFF475467),
                        size: 17,
                      ),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    height: 30,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.trashCan,
                        color: Color(0xFFF04438),
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: const [
              StautsBox(
                iconpath: "assets/image/icon svg/Dropped.svg",
                label: "Dropped",
                count: 2,
              ),
              SizedBox(width: 8),
              StautsBox(
                iconpath: "assets/image/icon svg/Applied.svg",
                label: "Applied",
                count: 2,
              ),
              SizedBox(width: 8),
              StautsBox(
                iconpath: "assets/image/icon svg/Completed.svg",
                label: "Completed",
                count: 2,
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(12),
                  value: 0.37,
                  color: const Color(0XFF16A34A),
                  backgroundColor: const Color(0XFFF1F0F1),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "37% Completion",
                style: AppTextStyle.textstyle12.copyWith(
                  color: AppColor.darkBlue,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
