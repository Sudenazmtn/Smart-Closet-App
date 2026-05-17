import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  /// Öncelik sırası:
  ///   1. --dart-define=BASE_URL=http://...  (her ortam için önerilen)
  ///   2. Web (Chrome)      → http://localhost:5000
  ///   3. Android emülatör  → http://10.0.2.2:5000
  ///
  /// Fiziksel cihazda çalıştırırken:
  ///   flutter run --dart-define=BASE_URL=http://10.45.76.72:5000
  static const String _envUrl = String.fromEnvironment('BASE_URL');

  static String get baseUrl {
    if (_envUrl.isNotEmpty) return _envUrl;
    if (kIsWeb) return 'http://localhost:5000';
    return 'http://10.0.2.2:5000'; // Android emülatör
  }

  late final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.addAll([
          _AuthInterceptor(),
          if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
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
        return 'Sunucuya bağlanılamadı, zaman aşımı.';
      case DioExceptionType.receiveTimeout:
        return 'Sunucu yanıt vermedi, tekrar dene.';
      case DioExceptionType.connectionError:
        return 'Sunucuya ulaşılamıyor. Backend çalışıyor mu?';
      case DioExceptionType.badResponse:
        return 'Sunucudan hatalı yanıt geldi (${err.response?.statusCode}).';
      default:
        return 'Bir hata oluştu, tekrar dene.';
    }
  }
}
