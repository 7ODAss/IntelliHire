import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/features/auth/controller/external%20login/external_login_cubit.dart';

class SocialButtons extends StatelessWidget {
  final String type; 
  const SocialButtons({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final externalCubit = context.read<ExternalLoginCubit>();
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => externalCubit.loginWithProvider(provider: "google", type: type),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/login/google.svg"),
                const SizedBox(width: 8),
                const Text("Google", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => externalCubit.loginWithProvider(provider: "microsoft", type: type),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/login/microsoft.svg"),
                const SizedBox(width: 8),
                const Text("Microsoft", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}