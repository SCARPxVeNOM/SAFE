import 'package:dio/dio.dart';

const defaultBaseUrl = 'http://localhost:8080/api';

class SafeBillApiClient {
  SafeBillApiClient({
    Dio? dio,
    String? baseUrl,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? defaultBaseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 30),
              ),
            );

  final Dio _dio;

  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
  }) {
    return _dio.post<T>(path, data: data);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
  }) {
    return _dio.get<T>(path, queryParameters: query);
  }
}

