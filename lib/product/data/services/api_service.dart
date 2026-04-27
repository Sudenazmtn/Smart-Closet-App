import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  // Android emülatörde localhost = 10.0.2.2
  // Fiziksel cihazda bilgisayarın IP adresi olmalı
  // Örn: http://192.168.1.5:5000
  static const String _baseUrl = 'http://10.0.2.2:5000';

  late final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: _baseUrl,
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
