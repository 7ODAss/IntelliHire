import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/helpers/cache_helper.dart';
import 'package:intelli_hire/core/utils/apis/dio_config.dart';
import '../../../../core/network/error_message_model.dart';
import '../../../../core/utils/apis/api_constant.dart';
import '../../../Organization/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper.dart';
import '../../models/login_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

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
          //debugPrint(value.data);
          loginModel = LoginModel.fromJson(value.data);

          if (loginModel != null &&
              loginModel!.isSuccess &&
              loginModel!.token.isNotEmpty) {
            await CacheHelper.saveData(key: 'token', value: loginModel!.token);
            await CacheHelper.saveData(
              key: 'refreshToken',
              value: loginModel!.refreshToken,
            );
            await CacheHelper.saveData(
              key: 'expiresOn',
              value: DateTime.parse(loginModel!.expiresOn.toString()),
            );
            await CacheHelper.saveData(
              key: 'userType',
              value: loginModel!.userType,
            );

            emit(
              state.copyWith(
                loginState: RequestState.success,
                loginModel: loginModel,
                loginMessage: loginModel!.message,
              ),
            );
          } else {
            emit(
              state.copyWith(
                loginState: RequestState.error,
                loginMessage:
                    loginModel?.message ?? 'Login failed. Please try again.',
              ),
            );
          }
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
                message = ErrorMessageModel.fromJson(
                  error.response!.data,
                ).message;
              } catch (_) {
                message = 'Server error: ${error.response?.statusCode}';
              }
            } else {
              message = 'An unexpected error occurred: ${error.message}';
            }
          }
          debugPrint('message: $message');
          emit(
            state.copyWith(
              loginState: RequestState.error,
              loginMessage: message,
            ),
          );
        });
  }

  Future<void> loginWithExternalProvider({
    required String provider,
    required String userType,
    required BuildContext context,
  }) async {
    try {
      final String authUrl = ApiConstant.externalLogin(provider, userType);

      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: "intellihire",
      );

      final uri = Uri.parse(result);
      final token = uri.queryParameters['token'];

      if (token != null) {
        debugPrint('Login Success! Token: $token');

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
      debugPrint('Login Failed or Canceled by user: $e');
    }
  }
}
