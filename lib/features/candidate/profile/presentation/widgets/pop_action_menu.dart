import 'package:flutter/material.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../Organization/Job Managment/presentation/views/widget/custom_pop_button.dart';

class PopActionMenu extends StatelessWidget {
  final String? title;
  final void Function()? fun;
  const PopActionMenu({super.key,this.title,this.fun});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomPopButton(
          onTap: fun,
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: AppTextStyle.titlePostScreen,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }
}
