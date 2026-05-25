import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/shared/liquid_glass_custom_pop_button.dart';

import '../../../../../core/utils/app_text_style.dart';
import '../../../Job Managment/presentation/widget/custom_pop_button.dart';

class PopActionMenu extends StatelessWidget {
  final String? title;
  final void Function()? fun;
  final bool? isLiquid;

  const PopActionMenu({super.key, this.title, this.fun, this.isLiquid = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isLiquid == true
            ? LiquidGlassCustomPopButton()
            : CustomPopButton(onTap: fun),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: Text(
              title!,
              style: AppTextStyle.titlePostScreen,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
