import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/external%20login/external_login_cubit.dart';

import '../../../../../../../../core/utils/app_text_style.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key, required this.type});
  final int type;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              context.read<ExternalLoginCubit>().loginWithProvider(
                provider: "google",
                type: type.toString(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Image.asset(
              "assets/image/google_icon.png",
              width: 20,
              height: 20,
            ),

            label: const Text("Google", style: AppTextStyle.textstyle14),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              context.read<ExternalLoginCubit>().loginWithProvider(
                provider: "microsoft",
                type: type.toString(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Image.asset(
              "assets/image/logos_microsoft-icon.png",
              width: 20,
              height: 20,
            ),
            label: Text(
              "Microsoft",
              style: AppTextStyle.textstyle14.copyWith(
                color: Color(0xff0F172A),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
