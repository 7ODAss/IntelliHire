import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../controller/sign_up_cubit.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SignUpCubit, SignUpState, bool>(
      selector: (state) {
        return state.checkBoxTermsConditions;
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: context
                  .read<SignUpCubit>()
                  .state
                  .checkBoxTermsConditions,
              onChanged: (value) {
                context.read<SignUpCubit>().changeCheckBoxTermsConditions();
              },
              activeColor: AppColor.signUpConditionColor2,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              side: const BorderSide(
                color: Color(0xFFD1D5DB),
                width: 1.5,
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'I agree to the ',
                  style: AppTextStyle.signUpConditionStyle,
                  children: [
                    TextSpan(
                      text: 'Terms',
                      style: AppTextStyle.signUpConditionStyle
                          .copyWith(
                        color: AppColor.signUpConditionColor2,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to Terms
                        },
                    ),
                    const TextSpan(
                      text: ' and ',
                      style: AppTextStyle.signUpConditionStyle,
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: AppTextStyle.signUpConditionStyle
                          .copyWith(
                        color: AppColor.signUpConditionColor2,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to Privacy Policy
                        },
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
