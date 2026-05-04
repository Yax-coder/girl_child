import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkClient {
  static const String baseUrl = 'http://146.190.153.125:3001';
  
  final Dio _dio;

  NetworkClient() : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  ) {
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  Dio get dio => _dio;
}
