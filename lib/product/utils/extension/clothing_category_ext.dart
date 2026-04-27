import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';

extension ClothingCategoryExtension on ClothingModel {
  String get categoryEmoji {
    switch (category) {
      case 'tops':
        return '👚';
      case 'bottoms':
        return '👖';
      case 'dress':
        return '👗';
      case 'outerwear':
        return '🧥';
      case 'shoes':
        return '👠';
      case 'bags':
        return '👜';
      default:
        return '👔';
    }
  }

  Color get categoryColor {
    switch (category) {
      case 'tops':
        return const Color(0xFFF5C5C5);
      case 'bottoms':
        return const Color(0xFFBDD8C0);
      case 'dress':
        return const Color(0xFFB8CEDD);
      case 'outerwear':
        return const Color(0xFFF5E8C8);
      case 'shoes':
        return const Color(0xFFF0EAF5);
      case 'bags':
        return const Color(0xFFF5E8C8);
      default:
        return const Color(0xFFF0EEE8);
    }
  }
}
