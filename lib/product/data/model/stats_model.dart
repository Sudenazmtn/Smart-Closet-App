import 'clothing_model.dart';
import 'outfit_model.dart';

class WardrobeSuggestion {
  const WardrobeSuggestion({required this.key, required this.emoji});

  final String key;
  final String emoji;

  factory WardrobeSuggestion.fromJson(Map<String, dynamic> json) {
    return WardrobeSuggestion(
      key:   json['key']   as String,
      emoji: json['emoji'] as String,
    );
  }
}

class StatsModel {
  const StatsModel({
    required this.totalItems,
    required this.totalOutfits,
    required this.mostWorn,
    required this.neverWorn,
    required this.neverWornCount,
    required this.recentOutfits,
    required this.wardrobeSuggestions,
  });

  final int totalItems;
  final int totalOutfits;
  final List<ClothingModel> mostWorn;
  final List<ClothingModel> neverWorn;
  final int neverWornCount;
  final List<OutfitModel> recentOutfits;
  final List<WardrobeSuggestion> wardrobeSuggestions;

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      totalItems:   json['total_items']    as int,
      totalOutfits: json['total_outfits']  as int,
      neverWornCount: json['never_worn_count'] as int,
      mostWorn: (json['most_worn'] as List)
          .map((e) => ClothingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      neverWorn: (json['never_worn'] as List)
          .map((e) => ClothingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentOutfits: ((json['recent_outfits'] as List?) ?? [])
          .map((e) => OutfitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      wardrobeSuggestions: ((json['wardrobe_suggestions'] as List?) ?? [])
          .map((e) => WardrobeSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
