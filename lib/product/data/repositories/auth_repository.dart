import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_closet_app/product/data/model/user_model.dart';

import '../services/api_service.dart';

class AuthRepository {
  AuthRepository() : _dio = ApiService.instance.dio;

  final Dio _dio;

  Future<UserModel> register({
    required String firebaseUid,
    required String name,
    required String email,
  }) async {
    final response = await _dio.post(
      '/auth/register',
      data: {'firebase_uid': firebaseUid, 'name': name, 'email': email},
    );
    return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> login({
    required String firebaseUid,
    String? name,
    String? email,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'firebase_uid': firebaseUid,
        'name': ?name,
        'email': ?email,
      },
    );
    return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> getMe() async {
    final response = await _dio.get('/auth/me');
    return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  Future<void> deleteAccount() async {
    await _dio.delete('/auth/delete');
  }

  /// Uploads the profile photo to the backend and returns its relative URL
  /// (e.g. `/uploads/profile_1.jpg?v=123`).
  Future<String> uploadProfilePhoto(String filePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });
    final response = await _dio.post('/auth/profile-photo', data: formData);
    return response.data['image_url'] as String;
  }

  Future<UserModel?> syncWithBackend(User firebaseUser) async {
    try {
      return await login(
        firebaseUid: firebaseUser.uid,
        name: firebaseUser.displayName,
        email: firebaseUser.email,
      );
    } catch (_) {
      return null;
    }
  }
}
