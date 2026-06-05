import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/enums/snack_bar_type.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';

import 'package:intelli_hire/core/helpers/cache_helper.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/account_setup_view.dart';
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
  // 🌟 1. قفل الحماية: هنحتفظ بآخر توكن تم إرساله عشان نمنع التكرار (Double Trigger)
  static String? _lastVerifiedToken;

  @override
  void initState() {
    super.initState();

    // 🌟 2. لو التوكن ده لسه مبعوت للباك إند حالاً، متعملش حاجة وتجاهل الشاشة التانية
    if (_lastVerifiedToken == widget.token) {
      return; 
    }
    _lastVerifiedToken = widget.token;

    // 🌟 3. تنظيف التوكن: فلاتر أحياناً بيحول علامة (+) لمسافة، بنرجعها تاني عشان الباك إند ميضربش 400
    String cleanToken = widget.token.replaceAll(' ', '+');

    context.read<SignUpCubit>().confirmEmail(
      token: cleanToken,
      userId: widget.userId,
    );
  }

  // دالة لفك تشفير التوكن وقراءة النوع الحقيقي للمستخدم
  String _getUserTypeFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return 'Individual';
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);
      return payloadMap['UserType'] ?? payloadMap['userType'] ?? 'Individual';
    } catch (e) {
      return 'Individual';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignUpCubit, SignUpState>(
        listenWhen: (previous, current) =>
            previous.confirmEmailState != current.confirmEmailState,
        listener: (context, state) async {
          if (state.confirmEmailState == RequestState.success) {
            context.showSnackBar(
              'Email verified successfully!',
              type: SnackBarType.success,
            );

            // جلب التوكن لمعرفة النوع الحقيقي وتوجيهه صح
            String? token = await CacheHelper.getData(key: 'token');
            if (token == null) return;

            String actualUserType = _getUserTypeFromToken(token);

            if (actualUserType == 'Company' || actualUserType == 'company') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => SignUpCubit(),
                    child: const SignUpProcess(),
                  ),
                ),
                (route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ProfileSetupCubit(ApiService(), userToken: token),
                    child: const AccountSetupView(),
                  ),
                ),
                (route) => false,
              );
            }
          } else if (state.confirmEmailState == RequestState.error) {
            // 🌟 لو حصل إيرور حقيقي (زي النت فصل)، بنفك القفل عشان يقدر يحاول تاني
            _lastVerifiedToken = null; 
            context.showSnackBar(
              state.confirmEmailMessage,
              type: SnackBarType.error,
            );
          }
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFF134CC7),
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