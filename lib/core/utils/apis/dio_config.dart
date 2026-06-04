import 'package:dio/dio.dart';
import 'package:intelli_hire/core/utils/apis/api_constant.dart';

import 'interceptor.dart';

class DioConfig {
  DioConfig._();

  static late Dio _dio;

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstant.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    //update refresh token
    _dio.interceptors.add(TokenInterceptor(_dio));
  }

  static Future<Response<dynamic>> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  static Future<Response<dynamic>> postData({
    required String path,
    Map<String, dynamic>? data,
    FormData? formData,
  }) async {
    return _dio.post(path, data: formData ?? data);
  }

  static Future<Response<dynamic>> putData({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    return _dio.put(path, data: data);
  }

  static Future<Response<dynamic>> patchData({
    required String path,
    FormData? formData,
    Map<String, dynamic>? data,
  }) async {
    return _dio.patch(path, data: formData ?? data);
  }

  static Future<Response<dynamic>> deleteData({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    return _dio.delete(path, data: data);
  }
}
