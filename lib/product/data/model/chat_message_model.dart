import 'package:smart_closet_app/product/data/model/clothing_model.dart';

enum MessageSender { user, ai }

class ChatMessageModel {
  const ChatMessageModel({
    required this.sender,
    required this.text,
    this.suggestedItems,
    this.allOutfits,
    this.eventType,
    this.styleName,
    this.styleTip,
    this.destinationCity,
    this.score,
  });

  final MessageSender sender;
  final String text;
  /// Primary outfit items (first alternative)
  final List<ClothingModel>? suggestedItems;
  /// All alternative outfits — index 0 is primary
  final List<List<ClothingModel>>? allOutfits;
  /// Occasion type — used when saving the outfit
  final String? eventType;
  final String? styleName;
  final String? styleTip;
  final String? destinationCity;
  final double? score;
}

class ChatAiResponse {
  const ChatAiResponse({
    required this.message,
    required this.items,
    required this.allOutfits,
    this.eventType,
    this.score,
    this.styleTip,
    this.destinationCity,
  });

  final String message;
  final List<ClothingModel> items;
  final List<List<ClothingModel>> allOutfits;
  final String? eventType;
  final double? score;
  final String? styleTip;
  final String? destinationCity;

  factory ChatAiResponse.fromJson(Map<String, dynamic> json) {
    final outfitList   = json['outfit'] as List<dynamic>? ?? [];
    final primaryItems = outfitList
        .map((e) => ClothingModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final outfitsList = json['outfits'] as List<dynamic>?;
    final List<List<ClothingModel>> allOutfits;
    if (outfitsList != null && outfitsList.isNotEmpty) {
      allOutfits = outfitsList
          .map((outfit) => (outfit as List<dynamic>)
              .map((e) => ClothingModel.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList();
    } else {
      allOutfits = primaryItems.isNotEmpty ? [primaryItems] : [];
    }

    return ChatAiResponse(
      message:         json['message']          as String?  ?? '',
      items:           primaryItems,
      allOutfits:      allOutfits,
      eventType:       json['event_type']        as String?,
      score:           (json['score']            as num?)?.toDouble(),
      styleTip:        json['style_tip']         as String?,
      destinationCity: json['destination_city']  as String?,
    );
  }
}
