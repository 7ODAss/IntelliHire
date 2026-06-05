import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intelli_hire/core/helpers/cache_helper.dart';
import 'package:intelli_hire/features/auth/presentation/login/login_screen.dart';

import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/core/service/notification_hub_service.dart';

import 'api_constant.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;
  static Future<bool>? _refreshFuture;

  TokenInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await CacheHelper.getData(key: 'token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains(ApiConstant.refreshToken)) {
      try {
        _refreshFuture ??= _refreshToken();
        bool isRefreshed = await _refreshFuture!;
        _refreshFuture = null;

        if (isRefreshed) {
          final newToken = await CacheHelper.getData(key: 'token');
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newToken';

          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        } else {
          await _performLogout(err, handler);
        }
      } catch (e) {
        _refreshFuture = null;
        await _performLogout(err, handler);
      }
    } else {
      return handler.next(err);
    }
  }

  Future<void> _performLogout(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    print("🚨 الـ Refresh Token كمان خلصان! لازم اليوزر يعمل Login تاني");
    await CacheHelper.removeData(key: 'token');
    await CacheHelper.removeData(key: 'refreshToken');
    await CacheHelper.removeData(key: 'expiresOn');

    ApiConstant.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final accessToken = await CacheHelper.getData(key: 'token');
      final refreshToken = await CacheHelper.getData(key: 'refreshToken');
      if (accessToken == null || refreshToken == null) return false;

      final response = await Dio().post(
        ApiConstant.refreshToken,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {'accessToken': accessToken, 'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['token'];
        final newExpiresOn = response.data['expiresOn'];
        final newRefreshToken = response.data['refreshToken'];

        if (newAccessToken != null && newRefreshToken != null) {
          await CacheHelper.saveData(key: 'token', value: newAccessToken);
          await CacheHelper.saveData(key: 'refreshToken', value: newRefreshToken);
          if (newExpiresOn != null) {
            await CacheHelper.saveData(key: 'expiresOn', value: newExpiresOn.toString());
          }

          print("✅ تم تجديد التوكن بنجاح في الخفاء!");

          // 🌟🌟 التجديد اللحظي لـ SignalR 🌟🌟
          try {
            getIt<NotificationHubService>().onTokenExpiredOrRefreshed?.call();
            print("✅ تم إرسال أمر تجديد SignalR عبر NotificationHubService");
          } catch (e) {
            print("❌ فشل إرسال أمر تجديد SignalR: $e");
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        print("🚨 تفاصيل رفض السيرفر للريفرش: ${e.response?.data}");
      }
      return false;
    }
  }
}