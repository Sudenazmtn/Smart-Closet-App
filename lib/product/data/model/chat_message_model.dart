import 'package:smart_closet_app/product/data/model/clothing_model.dart';

enum MessageSender { user, ai }

class ChatMessageModel {
  const ChatMessageModel({
    required this.sender,
    required this.text,
    this.suggestedItems,
    this.styleName,
    this.styleTip,
    this.destinationCity,
  });

  final MessageSender sender;
  final String text;
  final List<ClothingModel>? suggestedItems;
  final String? styleName;
  final String? styleTip;
  final String? destinationCity;
}

class ChatAiResponse {
  const ChatAiResponse({
    required this.message,
    required this.items,
    this.score,
    this.styleTip,
    this.destinationCity,
  });

  final String message;
  final List<ClothingModel> items;
  final double? score;
  final String? styleTip;
  final String? destinationCity;

  factory ChatAiResponse.fromJson(Map<String, dynamic> json) {
    final outfitList = json['outfit'] as List<dynamic>? ?? [];
    return ChatAiResponse(
      message: json['message'] as String? ?? '',
      items: outfitList
          .map((e) => ClothingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      score: (json['score'] as num?)?.toDouble(),
      styleTip: json['style_tip'] as String?,
      destinationCity: json['destination_city'] as String?,
    );
  }
}
