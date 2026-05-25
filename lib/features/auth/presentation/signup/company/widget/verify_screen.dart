import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/enums/request.dart';
import '../../../../../../core/enums/snack_bar_type.dart';
import '../../../../../../core/utils/shared/context_extension.dart';
import '../../../../controller/sign_up_cubit/sign_up_cubit.dart';
import '../sign_up_process.dart';

class VerifyScreen extends StatefulWidget {
  final String token;
  final String userId;

  const VerifyScreen({super.key, required this.token, required this.userId});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  void initState() {
    super.initState();
    // 🌟 بنبعت الريكويست للسيرفر في اللحظة اللي الشاشة بتفتح فيها
    context.read<SignUpCubit>().confirmEmail(
      token: widget.token,
      userId: widget.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignUpCubit, SignUpState>(
        // بنراقب حالة التأكيد بس عشان ميعملش listen على الفاضي
        listenWhen: (previous, current) =>
            previous.confirmEmailState != current.confirmEmailState,

        listener: (context, state) {
          if (state.confirmEmailState == RequestState.success) {
            // ✅ لو السيرفر رد بنجاح:
            context.showSnackBar(
              'Email verified successfully!',
              type: SnackBarType.success,
            );

            // بنمسح شاشة الـ Verify ونوديه لشاشة تكملة البيانات
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SignUpCubit(),
                  child: SignUpProcess(),
                ), // الشاشة اللي عليها الدور
              ),
              (route) =>
                  false, // بيمسح كل الـ History بتاع الشاشات عشان ميرجعش ورا
            );
          } else if (state.confirmEmailState == RequestState.error) {
            // ❌ لو السيرفر رفض (مثلاً اللينك منتهي أو مستخدم قبل كده):
            context.showSnackBar(
              state.confirmEmailMessage ??
                  'Verification failed. The link may be expired.',
              type: SnackBarType.error,
            );

            // بنقفله شاشة الانتظار ونرجعه للشاشة اللي كان فيها (اللوجين مثلاً)
            Navigator.pop(context);
          }
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // شكل جمالي بيطمن اليوزر إن الأبلكيشن شغال ومش مهنج
              CircularProgressIndicator(
                color: Color(0xFF134CC7), // لون الـ Primary بتاعك
              ),
              SizedBox(height: 24),
              Text(
                'Verifying your email...',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please wait a moment.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
