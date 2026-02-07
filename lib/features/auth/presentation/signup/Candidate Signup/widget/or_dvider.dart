import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_styles.dart';

class OrDvider extends StatelessWidget {
  const OrDvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider(color: AppColor.grey)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),

          child: Text("OR CONTINUE WITH", style: AppStyles.textstyle12),
        ),

        Expanded(child: Divider(color: AppColor.grey)),
      ],
    );
  }
}
