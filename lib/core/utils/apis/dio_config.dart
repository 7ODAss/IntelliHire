import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:intelli_hire/core/utils/apis/api_constant.dart';

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
          'ngrok-skip-browser-warning': 'true',
        },
      ),
    );
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        // This tells Flutter to trust the local self-signed certificate
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
  }

  static Future<Response<dynamic>> getData({required String path}) async {
    return _dio.get(path);
  }

  static Future<Response<dynamic>> postData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    return _dio.post(path, data: data);
  }
}
