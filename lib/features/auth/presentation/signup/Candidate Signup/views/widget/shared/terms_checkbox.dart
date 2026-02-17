import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';

import '../../../../../../../../core/utils/app_text_style.dart';

class TermsCheckbox extends StatelessWidget {
  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.side,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final BorderSide? side;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              activeColor: AppColor.primary,
              value: value,
              onChanged: onChanged,
              side: side,
              
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: "I agree to the ",
                  style: AppTextStyle.textstyle14.copyWith(color: AppColor.grey),
                  children: [
                    TextSpan(
                      text: "Terms",
                      style: AppTextStyle.textstyle14.copyWith(
                        color: AppColor.primary,
                      ),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: AppTextStyle.textstyle14.copyWith(
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
