import 'clothing_model.dart';

class StatsModel {
  const StatsModel({
    required this.totalItems,
    required this.totalOutfits,
    required this.mostWorn,
    required this.neverWorn,
    required this.neverWornCount,
  });

  final int totalItems;
  final int totalOutfits;
  final List<ClothingModel> mostWorn;
  final List<ClothingModel> neverWorn;
  final int neverWornCount;

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      totalItems: json['total_items'] as int,
      totalOutfits: json['total_outfits'] as int,
      neverWornCount: json['never_worn_count'] as int,
      mostWorn: (json['most_worn'] as List)
          .map((e) => ClothingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      neverWorn: (json['never_worn'] as List)
          .map((e) => ClothingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
