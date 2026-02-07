import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_styles.dart';

class TermsCheckbox extends StatefulWidget {
  const TermsCheckbox({super.key});

  @override
  State<TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  bool _agree = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: AppColor.primary,
          value: _agree,

          onChanged: (val) {
            setState(() {
              _agree = val ?? false;
            });
          },
          side: BorderSide(color: AppColor.grey),
        ),

        Expanded(
          child: Text.rich(
            TextSpan(
              text: "I agree to the ",
              style: AppStyles.textstyle14.copyWith(color: AppColor.grey),

              children: [
                TextSpan(
                  text: "Terms",

                  style: AppStyles.textstyle14.copyWith(
                    color: AppColor.primary,
                  ),
                ),

                TextSpan(
                  text: " and ",
                  style: AppStyles.textstyle14.copyWith(color: AppColor.grey),
                ),

                TextSpan(
                  text: "Privacy Policy",

                  style: AppStyles.textstyle14.copyWith(
                    color: AppColor.primary,
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
