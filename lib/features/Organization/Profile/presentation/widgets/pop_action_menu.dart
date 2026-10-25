import 'package:flutter/material.dart';

import '../../../../../core/utils/app_text_style.dart';
import '../../../Job Managment/presentation/views/widget/custom_pop_button.dart';

class PopActionMenu extends StatelessWidget {
  final String? title;
  final void Function()? fun;
  final bool? isLiquid;

  const PopActionMenu({super.key, this.title, this.fun, this.isLiquid = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomPopButton(onTap: fun),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: AppTextStyle.titlePostScreen.copyWith(
                color: const Color(0xFF0F172A),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }
}
