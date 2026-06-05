import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/login_cubit/login_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/forgetpassword/forget_process.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';

class RememberMe extends StatelessWidget {
  const RememberMe({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginCubit, LoginState, bool>(
      selector: (state) {
        return state.rememberMeCheck;
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: context.read<LoginCubit>().state.rememberMeCheck,
              onChanged: (value) {
                context.read<LoginCubit>().changeRememberMeCheck();
              },
              activeColor: AppColor.signUpConditionColor2,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              side: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
            ),
            Text(
              'Remember Me',
              style: AppTextStyle.signUpConditionStyle.copyWith(
                color: AppColor.signUpConditionColor1,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                // 1. Set padding to zero
                padding: EdgeInsets.zero,
                // 2. Set minimum size to zero
                minimumSize: Size.zero,
                // 3. Shrink the touch target area to the button's visual bounds
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetProcess()));
                },
               child: Text('Forgot Password?',
                 style: AppTextStyle.signUpConditionStyle.copyWith(
                   color: AppColor.signUpConditionColor2,
                 ),),
              ),
            ),
          ],
        );
      },
    );
  }
}
