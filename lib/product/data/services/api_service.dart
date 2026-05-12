import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  // Web (Chrome) → localhost
  // Android emülatör → 10.0.2.2
  // Fiziksel cihaz → bilgisayarın yerel IP'si
  static final String baseUrl = kIsWeb
      ? 'http://localhost:5000'
      : 'http://172.20.10.2:5000';
      //: 'http://192.168.1.121:5000';

  late final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.addAll([
          _AuthInterceptor(),
          LogInterceptor(requestBody: true, responseBody: true),
        ]);

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      options.headers['X-Firebase-UID'] = user.uid;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: _parseError(err),
        type: err.type,
        response: err.response,
      ),
    );
  }

  String _parseError(DioException err) {
    if (err.response?.data != null) {
      final data = err.response!.data;
      if (data is Map && data['error'] != null) {
        return data['error'].toString();
      }
    }
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong.';
    }
  }
}
