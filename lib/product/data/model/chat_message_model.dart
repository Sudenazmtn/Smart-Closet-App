import 'package:smart_closet_app/product/data/model/clothing_model.dart';

enum MessageSender { user, ai }

class ChatMessageModel {
  const ChatMessageModel({
    required this.sender,
    required this.text,
    this.suggestedItems,
    this.styleName,
    this.styleTip,
  });

  final MessageSender sender;
  final String text;

  /// Kural tabanlı AI'dan dönen kombin öğeleri (tam ClothingModel)
  final List<ClothingModel>? suggestedItems;

  final String? styleName;
  final String? styleTip;
}

/// /chat/message endpoint'inden dönen ham yanıt modeli
class ChatAiResponse {
  const ChatAiResponse({
    required this.message,
    required this.items,
    this.score,
    this.styleTip,
  });

  final String message;
  final List<ClothingModel> items;
  final double? score;
  final String? styleTip;

  factory ChatAiResponse.fromJson(Map<String, dynamic> json) {
    final outfitList = json['outfit'] as List<dynamic>? ?? [];
    return ChatAiResponse(
      message : json['message'] as String? ?? '',
      items   : outfitList
          .map((e) => ClothingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      score   : (json['score'] as num?)?.toDouble(),
      styleTip: json['style_tip'] as String?,
    );
  }
}
