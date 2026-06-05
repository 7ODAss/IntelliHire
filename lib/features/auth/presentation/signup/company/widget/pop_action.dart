import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_text_style.dart';

class PopAction extends StatelessWidget {
  final void Function()? onPressed;
  const PopAction({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF2F466C),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(0xFF2F466C),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF2F466C),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Color(0xFF0F172A),
            radius: 18,
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white,size: 20,),
                onPressed: onPressed ?? () =>Navigator.pop(context),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            'Sign Up',
            style: AppTextStyle.signUpTitleStyle.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
