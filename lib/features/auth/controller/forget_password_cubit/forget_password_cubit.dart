import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:dio/dio.dart';
import '../../../../core/utils/apis/api_constant.dart';
import '../../../../core/utils/apis/dio_config.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(const ForgetPasswordState());
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final PageController pageController = PageController();
  final PinInputController otpController = PinInputController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String token = '';

  void changeIndex(int index) {
    emit(state.copyWith(pageIndex: index));
  }

  void changePasswordSuffix() {
    emit(state.copyWith(changePasswordSuffix: !state.changePasswordSuffix));
  }

  void changeConfirmPasswordSuffix() {
    emit(
      state.copyWith(
        changeConfirmPasswordSuffix: !state.changeConfirmPasswordSuffix,
      ),
    );
  }

  void sendCode({required String email}) {
    emit(state.copyWith(checkEmailState: RequestState.loading));
    DioConfig.postData(path: ApiConstant.checkEmail, data: {'email': email})
        .then((value) {
          print('check email response: ${value.data}');
          emit(
            state.copyWith(
              checkEmailState: RequestState.success,
              checkEmailMessage: value.data.toString(),
            ),
          );
        })
        .catchError((error) {
          emit(
            state.copyWith(
              checkEmailState: RequestState.error,
              checkEmailMessage: error.toString(),
            ),
          );
        });
  }

  void verifyCode({required String code}) {
    emit(state.copyWith(otpState: RequestState.loading));
    DioConfig.postData(
          path: ApiConstant.verifyOtp,
          data: {'email': emailController.text, 'code': code},
        )
        .then((value) {
          print('verify code response: ${value.data}');
          token = value.data['token'];
          emit(
            state.copyWith(
              otpState: RequestState.success,
              otpMessage: value.data['message'],
            ),
          );
        })
        .catchError((error) {
          emit(
            state.copyWith(
              otpState: RequestState.error,
              otpMessage: 'OTP verification failed.',
            ),
          );
        });
  }

  void resetPassword({
    required String email,
    required String token,
    required String password,
    required String confirmPassword,
  }) {
    emit(state.copyWith(resetPasswordState: RequestState.loading));
    DioConfig.postData(
          path: ApiConstant.resetPassword,
          data: {
            'email': email,
            'token': token,
            'newPassword': password,
            'confirmPassword': confirmPassword,
          },
        )
        .then((value) {
          print('reset password response: ${value.data}');
          emit(
            state.copyWith(
              resetPasswordState: RequestState.success,
              resetPasswordMessage: value.data['message'],
            ),
          );
        })
        .catchError((error) {
          String message = 'Reset password failed. Please try again.';
          if (error is DioException && error.response?.data != null) {
            final data = error.response!.data;
            if (data is Map<String, dynamic>) {
              final msg = data['message'] ?? '';
              final errors = data['errors'];
              String details = '';
              if (errors is Map && errors['description'] != null) {
                details = errors['description'].toString();
              } else if (errors is Map && errors.isNotEmpty) {
                details = errors.values.first.toString();
              }
              message = msg.isNotEmpty 
                  ? (details.isNotEmpty ? '$msg\n$details' : msg)
                  : (details.isNotEmpty ? details : message);
            }
          } else if (error is DioException) {
            message = error.message ?? message;
          } else {
            message = error.toString();
          }
          emit(
            state.copyWith(
              resetPasswordState: RequestState.error,
              resetPasswordMessage: message,
            ),
          );
        });
  }
}
