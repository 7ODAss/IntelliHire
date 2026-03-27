import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/helpers/cache_helper.dart';
import 'package:intelli_hire/core/utils/apis/dio_config.dart';
import '../../../core/network/error_message_model.dart';
import '../../../core/utils/apis/api_constant.dart';
import '../../Organization/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper.dart';
import '../models/login_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());
  final TextEditingController candidateEmailController =
      TextEditingController();
  final TextEditingController candidatePasswordController =
      TextEditingController();
  final GlobalKey<FormState> candidateFormKey = GlobalKey<FormState>();

  void changeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void changeSuffix() {
    emit(state.copyWith(changeSuffix: !state.changeSuffix));
  }

  void changeRememberMeCheck() {
    emit(state.copyWith(checkBoxTermsConditions: !state.rememberMeCheck));
  }

  LoginModel? loginModel;

  void login({
    required String email,
    required String password,
    required bool rememberMe,
  }) {
    emit(state.copyWith(loginState: RequestState.loading));
    DioConfig.postData(
          path: ApiConstant.login,
          data: {
            'email': email,
            'password': password,
            'rememberMe': rememberMe,
            'deviceName': 'mobile',
          },
        )
        .then((value) async {
          print(value.data);
          loginModel = LoginModel.fromJson(value.data);

          if (loginModel?.token != null) {
            await CacheHelper.saveData(key: 'token', value: loginModel!.token);
            await CacheHelper.saveData(
              key: 'refreshToken',
              value: loginModel!.refreshToken,
            );
            await CacheHelper.saveData(
              key: 'userType',
              value: loginModel!.userType,
            );
          }

          emit(
            state.copyWith(
              loginState: RequestState.success,
              loginModel: loginModel,
              loginMessage: loginModel!.message,
            ),
          );
        })
        .catchError((error) {
          String message = 'Login failed. Please try again.';

          if (error is DioException) {
            if (error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.sendTimeout) {
              message = 'Connection timed out. Please check your internet.';
            } else if (error.type == DioExceptionType.connectionError) {
              message = 'No internet connection or server is unreachable.';
            } else if (error.response?.data != null) {
              // Try to parse error from server response
              try {
                message = ErrorMessageModel.fromJson(error.response!.data).message;
              } catch (_) {
                message = 'Server error: ${error.response?.statusCode}';
              }
            } else {
              message = 'An unexpected error occurred: ${error.message}';
            }
          }

          emit(
            state.copyWith(loginState: RequestState.error, loginMessage: message),
          );
        });
  }

  Future<void> loginWithExternalProvider({
    required String provider, // "Google" or "Microsoft"
    required String userType, // "company" or "candidate"
    required BuildContext context,
  }) async {
    try {
      // 1. اللينك زي ما الباك إند قالهولك بالظبط (مع تعديل localhost لـ 10.0.2.2 للمحاكي)
      final String authUrl = ApiConstant.externalLogin(provider, userType);

      // 2. هنفتح المتصفح ونستنى الـ Scheme بتاعنا
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: "intellihire", // ده الـ Scheme اللي في AndroidManifest
      );

      // 3. اللينك هيرجعلك من الباك إند بالشكل ده:
      // intellihire://CustomBottomNavBarWrapper?token=12345
      final uri = Uri.parse(result);
      final token = uri.queryParameters['token']; // بناخد التوكن

      // (اختياري) لو الباك إند رجع اسم الشاشة في اللينك، نقدر نقرأها
      final screenName = uri.host;

      if (token != null) {
        print('Login Success! Token: $token');

        // 4. هنا بقى احنا اللي بنعمل النافيجيشن للشاشة اللي طلبناها!
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomBottomNavBarWrapper(),
            ),
          );
        }
      }
    } catch (e) {
      print('Login Failed or Canceled by user: $e');
    }
  }
}
