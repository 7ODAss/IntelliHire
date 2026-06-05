import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/forget_password_cubit/forget_password_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/forgetpassword/widget/forget_password_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/enums/request.dart';
import '../../../../core/utils/app_color.dart';
import '../../models/forget_password_model.dart';

class ForgetProcess extends StatelessWidget {
  const ForgetProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: _ForgetProcess(),
    );
  }
}

class _ForgetProcess extends StatelessWidget {
  const _ForgetProcess({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();
    // 🌟 ضفنا BlocBuilder عشان نراقب إحنا في أي صفحة لحظة بلحظة
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      buildWhen: (previous, current) => previous.pageIndex != current.pageIndex || previous.checkEmailState != current.checkEmailState,
      builder: (context, state) {
        final isLoading = state.checkEmailState == RequestState.loading;
        return PopScope(
          // 🌟 canPop: لو بـ true الموبايل يرجع لورا ويقفل الشاشة.. لو بـ false هيمنع القفل
          // إحنا عايزينه يمنع القفل (false) بس لو هو في صفحة الـ OTP (اللي هي صفحة رقم 1)
          canPop: state.pageIndex != 1 && !isLoading,

          onPopInvoked: (didPop) {
            // لو didPop بـ true معناه إنه كان في صفحة 0 أو 2 وقفل الشاشة خلاص (مش هنعمل حاجة)
            if (didPop) return;
            if (isLoading) return;

            // لو وصل هنا، معناه إنه في صفحة الـ OTP (صفحة 1) واتمنع من القفل، فهنرجعه لصفحة الإيميل
            if (state.pageIndex == 1) {
              cubit.pageController.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
              // (اختياري) ممكن تمسح التيكست بتاع الـ OTP هنا لو عايز
            }
          },
          child: AbsorbPointer(
            absorbing: isLoading,
            child: SafeArea(
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: cubit.pageController,
                          onPageChanged: (index) {
                            cubit.changeIndex(index);
                          },
                          itemCount: forgetPasswordList.length,
                          itemBuilder: (context, index) =>
                              ForgetPasswordItem(
                                pageIndex: index,
                                forgetPasswordList: forgetPasswordList,
                              ),
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: cubit.pageController,
                        count: forgetPasswordList.length,
                        axisDirection: Axis.horizontal,
                        effect: ExpandingDotsEffect(
                          spacing: 8.0,
                          dotWidth: 10,
                          dotHeight: 10,
                          radius: 56,
                          paintStyle: PaintingStyle.fill,
                          strokeWidth: 1.5,
                          activeDotColor: AppColor.logicColor,
                          dotColor: AppColor.notActiveIndicatorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
