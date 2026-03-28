import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/custom_pop_button.dart';

class ReviewSessionHeader extends StatelessWidget {
  const ReviewSessionHeader({
    super.key,
    required this.role,
    required this.onPressed,
  });
  final String role;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomPopButton(),

        Column(
          children: [
            const Text(
              'Review Session',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: AppFont.interBold,
                color: AppColor.darkBlue,
              ),
            ),
            Text(
              role,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: AppFont.interBold,
                color: Color(0XFF475569),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Skip',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w700,
              fontFamily: AppFont.interBold,
            ),
          ),
        ),
      ],
    );
  }
}
