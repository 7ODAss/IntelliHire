import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    super.key,
    required this.name, required this.height, required this.width,
  });

  final String name;
  final double height;
  final double width;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xffD6D6D6),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          (name.trim().split(" ").length == 1
                  ? name.trim()[0]
                  : name.trim().split(" ").first[0] +
                        name.trim().split(" ").last[0])
              .toUpperCase(),
          style: AppTextStyle.textstyle20.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
