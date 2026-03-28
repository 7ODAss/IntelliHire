import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class ApiService {
  late Dio dio;

  final String baseUrl = "http://10.0.2.2:5058/";
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

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
  }

  Future<Response> post({required String endPoint, dynamic data}) async {
    return await dio.post(endPoint, data: data);
  }

  Future<Response> get({required String endPoint}) async {
    return await dio.get(endPoint);
  }

  Future<Response> put({required String endPoint, dynamic data}) async {
    return await dio.put(endPoint, data: data);
  }

  Future<Response> delete({required String endPoint}) async {
    return await dio.delete(endPoint);
  }
}
