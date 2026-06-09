import 'package:dio/dio.dart';
import 'package:smart_closet_app/product/data/model/chat_message_model.dart';
import 'package:smart_closet_app/product/data/model/outfit_model.dart';
import 'package:smart_closet_app/product/data/model/stats_model.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';

class OutfitRepository {
  OutfitRepository() : _dio = ApiService.instance.dio;

  final Dio _dio;

  Future<List<OutfitModel>> getOutfits({
    bool? isFavorite,
    bool includeItems = false,
  }) async {
    final params = <String, String>{};
    if (isFavorite == true) params['is_favorite'] = 'true';
    if (includeItems)       params['include_items'] = 'true';

    final response = await _dio.get(
      '/outfit/',
      queryParameters: params.isNotEmpty ? params : null,
    );

    final outfits = response.data['outfits'] as List;
    return outfits
        .map((e) => OutfitModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<OutfitModel> saveOutfit({
    required List<int> itemIds,
    String? name,
    String? eventType,
    String? aiNote,
  }) async {
    final response = await _dio.post(
      '/outfit/save',
      data: {
        'item_ids': itemIds,
        'name': ?name,
        'event_type': ?eventType,
        'ai_note': ?aiNote,
      },
    );
    return OutfitModel.fromJson(
      response.data['outfit'] as Map<String, dynamic>,
    );
  }

  Future<OutfitModel> toggleFavorite(int outfitId) async {
    final response = await _dio.patch('/outfit/$outfitId/favorite');
    return OutfitModel.fromJson(
      response.data['outfit'] as Map<String, dynamic>,
    );
  }

  Future<void> deleteOutfit(int outfitId) async {
    await _dio.delete('/outfit/$outfitId');
  }

  Future<StatsModel> getStats() async {
    final response = await _dio.get('/outfit/stats');
    return StatsModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ChatAiResponse> sendChatMessage({
    required String userText,
    double? temperature,
    String? weatherDesc,
    List<int>? excludeItemIds,
  }) async {
    final response = await _dio.post(
      '/chat/message',
      data: {
        'message': userText,
        'temperature': ?temperature?.round(),
        'weather_desc': ?weatherDesc,
        if (excludeItemIds != null && excludeItemIds.isNotEmpty)
          'exclude_item_ids': excludeItemIds,
      },
    );
    return ChatAiResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
