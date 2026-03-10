import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_text_style.dart';
import '../../Job Managment/presentation/widget/custom_pop_button.dart';
import '../../bottom _navigation/controller/bottom_nav_cubit.dart';

class PopActionMenu extends StatelessWidget {
  final String title;
  final void Function()? fun;
  const PopActionMenu({super.key,required this.title,this.fun});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomPopButton(
          onTap: fun,
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: Text(
              title,
              style: AppTextStyle.titlePostScreen,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
