import 'package:dio/dio.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';

import '../services/api_service.dart';

class ClothingRepository {
  ClothingRepository() : _dio = ApiService.instance.dio;

  final Dio _dio;

  Future<List<ClothingModel>> getClothes({
    String? category,
    String? season,
    String? color,
  }) async {
    final params = <String, String>{};
    if (category != null) params['category'] = category;
    if (season != null) params['season'] = season;
    if (color != null) params['color'] = color;

    final response = await _dio.get(
      '/clothes/',
      queryParameters: params.isNotEmpty ? params : null,
    );

    final items = response.data['items'] as List;
    return items
        .map((e) => ClothingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ClothingModel> getClothingItem(int id) async {
    final response = await _dio.get('/clothes/$id');
    return ClothingModel.fromJson(
      response.data['item'] as Map<String, dynamic>,
    );
  }

  Future<ClothingModel> addClothing({
    required String name,
    required String category,
    required String color,
    required String season,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'category': category,
      'color': color,
      'season': season,
      if (imagePath != null)
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
    });

    final response = await _dio.post(
      '/clothes/',
      data: formData,
    );

    return ClothingModel.fromJson(
      response.data['item'] as Map<String, dynamic>,
    );
  }

  Future<ClothingModel> updateClothing(
    int id, {
    String? name,
    String? category,
    String? color,
    String? season,
  }) async {
    final body = <String, String>{};
    if (name != null) body['name'] = name;
    if (category != null) body['category'] = category;
    if (color != null) body['color'] = color;
    if (season != null) body['season'] = season;

    final response = await _dio.put('/clothes/$id', data: body);
    return ClothingModel.fromJson(
      response.data['item'] as Map<String, dynamic>,
    );
  }

  Future<void> deleteClothing(int id) async {
    await _dio.delete('/clothes/$id');
  }

  Future<ClothingModel> markAsWorn(int id) async {
    final response = await _dio.post('/clothes/$id/wear');
    return ClothingModel.fromJson(
      response.data['item'] as Map<String, dynamic>,
    );
  }
}
