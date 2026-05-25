import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intelli_hire/core/helpers/cache_helper.dart';
import 'package:intelli_hire/features/auth/presentation/login/login_screen.dart';

import 'api_constant.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;
  // 🌟 إشارة المرور عشان نمنع السباق (Race Condition)
  static Future<bool>? _refreshFuture;

  TokenInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await CacheHelper.getData(key: 'token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    // 🌟 دي الطريقة الصح عشان الطلب يكمل طريقه
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 1. لو الإيرور 401 (التوكن خلصان)
    if (err.response?.statusCode == 401) {

      // 🌟 لو فيه دالة ريفرش شغالة، استناها.. لو مفيش، شغلها
      _refreshFuture ??= _refreshToken();
      bool isRefreshed = await _refreshFuture!;

      // فضي الإشارة عشان الطلبات اللي بعد كده
      _refreshFuture = null;

      if (isRefreshed) {
        // 3. لو نجحنا، هنجيب التوكن الجديد من الكاش
        final newToken = await CacheHelper.getData(key: 'token');

        final requestOptions = err.requestOptions;
        // 4. نعدل الـ Request القديم اللي فشل ونحطله التوكن الجديد
        requestOptions.headers['Authorization'] = 'Bearer $newToken';

        try {
          // 🌟 5. لازم حماية هنا عشان لو الطلب ده فشل تاني (مثلاً 500 أو نت فصل) الموبايل ميكراشش!
          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        } on DioException catch (retryError) {
          return handler.next(retryError); // لو فشل يرجع الإيرور باحترام
        }
      } else {
        print("🚨 الـ Refresh Token كمان خلصان! لازم اليوزر يعمل Login تاني");
        await CacheHelper.removeData(key: 'token');
        await CacheHelper.removeData(key: 'refreshToken');
        await CacheHelper.removeData(key: 'expiresOn');

        ApiConstant.navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);

        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  // دالة تحديث التوكن
  Future<bool> _refreshToken() async {
    try {
      final accessToken = await CacheHelper.getData(key: 'token');
      final refreshToken = await CacheHelper.getData(key: 'refreshToken');
      if (accessToken == null || refreshToken == null) return false;

      // 🌟 لازم نحدد الهيدر هنا عشان السيرفر يفهم الـ JSON
      final response = await Dio().post(
        ApiConstant.refreshToken,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        },
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
          return true;
        }
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        print("🚨 تفاصيل رفض السيرفر للريفرش (400/401): ${e.response?.data}");
      }
      return false;
    }
  }
}