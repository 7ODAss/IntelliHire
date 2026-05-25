import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/cache_helper.dart';
import '../../../../../core/service/service_locator.dart';
import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../controller/assessment_session_cubit.dart';

class ShowAgainCheckBox extends StatelessWidget {
  const ShowAgainCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AssessmentSessionCubit>(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocSelector<AssessmentSessionCubit, AssessmentSessionState, bool>(
            selector: (state) {
              return state.isCheck;
            },
            builder: (context, state) {
              return Checkbox(
                value: state,
                onChanged: (value) {
                  context.read<AssessmentSessionCubit>().onCheck(
                    value!,
                  );
                  CacheHelper.saveData(
                    key: 'do_not_show',
                    value: value,
                  );
                },
                activeColor: AppColor.signUpConditionColor2,
                materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                side: const BorderSide(
                  color: Color(0xFFD1D5DB),
                  width: 1.5,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            'Don\'t show this again',
            style: AppTextStyle.signUpConditionStyle.copyWith(
                color: Colors.black
            ),
          ),
        ],
      ),
    );
  }
}
