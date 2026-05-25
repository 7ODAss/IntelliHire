import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/controller/bottom_nav_cubit.dart';

class CurrentJobsHeader extends StatelessWidget {
  const CurrentJobsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, right: 24, left: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Current Jobs",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: AppFont.interBold,
              color: AppColor.darkBlue,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<BottomNavCubit>().changeIndex(1);
            },
            child: Text(
              "View All",
              style: AppTextStyle.textstyle12.copyWith(
                color: Color(0XFF475569),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
