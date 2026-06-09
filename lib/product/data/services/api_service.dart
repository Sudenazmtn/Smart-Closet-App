import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  static const String _envUrl = String.fromEnvironment('BASE_URL');

  /// Dev IP, .env dosyasındaki DEV_IP değerinden okunur.
  /// .env dosyasına şunu ekle: DEV_IP=10.33.10.72
  static String get _devIp => dotenv.get('DEV_IP', fallback: 'localhost');

  static String get baseUrl {
    if (_envUrl.isNotEmpty) return _envUrl;
    if (kIsWeb) return 'http://localhost:5000';
    return 'http://$_devIp:5000';
  }

  late final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
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
