import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:intelli_hire/core/utils/apis/interceptor.dart';

class ApiService {
  late Dio dio;
  final String baseUrl = "https://intellhire.runasp.net/";

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(TokenInterceptor(dio));

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
  }

  // مسحنا دالة refreshToken من هنا لأننا نقلناها خلاص جوه TokenInterceptor

  Future<Response> get({required String endPoint}) async =>
      await dio.get(endPoint);
  Future<Response> post({required String endPoint, dynamic data}) async =>
      await dio.post(endPoint, data: data);
  Future<Response> put({required String endPoint, dynamic data}) async =>
      await dio.put(endPoint, data: data);
  Future<Response> delete({required String endPoint}) async =>
      await dio.delete(endPoint);
  Future<Response> patch({required String endPoint, dynamic data}) async =>
      await dio.patch(endPoint, data: data);
  Future<Response> download({
    required String endPoint,
    required String savePath,
  }) async => await dio.download(endPoint, savePath);
}
