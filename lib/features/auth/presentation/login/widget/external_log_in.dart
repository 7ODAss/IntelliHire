import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../controller/login_cubit/login_cubit.dart';

class ExternalLogIn extends StatelessWidget {
  final String userType;
  const ExternalLogIn({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context.read<LoginCubit>().loginWithExternalProvider(
                provider: "Google",
                userType: userType,
                context: context,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/login/google.svg"),
                SizedBox(width: 8),
                Text(
                  "Google",
                  style: AppTextStyle.loginSubTitleStyle.copyWith(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context.read<LoginCubit>().loginWithExternalProvider(
                provider: "Microsoft",
                userType: userType,
                context: context,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mircoSoftButtonBorderColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/login/microsoft.svg"),
                SizedBox(width: 8),
                Text(
                  "Microsoft",
                  style: AppTextStyle.loginSubTitleStyle.copyWith(
                    color: Colors.black,
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
