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
          child: Text(
            title!,
            textAlign: TextAlign.center,
            style: AppTextStyle.titlePostScreen.copyWith(
              color: const Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 40), // Balances back button space
      ],
    );
  }
}
