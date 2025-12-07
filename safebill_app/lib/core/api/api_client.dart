import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

/// Lightweight HTTP client for SafeBill backend.
class SafeBillApiClient {
  SafeBillApiClient({
    Dio? dio,
    String? baseUrl,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
                connectTimeout: const Duration(seconds: 12),
                receiveTimeout: const Duration(seconds: 30),
              ),
            ) {
    _setupInterceptors();
  }

  final Dio _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

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

