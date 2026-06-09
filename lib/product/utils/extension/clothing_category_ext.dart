import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/utils/constant/app_emojis.dart';

extension ClothingCategoryExtension on ClothingModel {
  String get categoryEmoji {
    switch (category) {
      case 'tops':       return AppEmojis.tops;
      case 'bottoms':    return AppEmojis.bottoms;
      case 'dress':      return AppEmojis.dress;
      case 'outerwear':  return AppEmojis.outerwear;
      case 'shoes':      return AppEmojis.shoes;
      case 'bags':       return AppEmojis.bags;
      default:           return AppEmojis.generic;
    }
  }

  Color get categoryColor {
    switch (category) {
      case 'tops':      return const Color(0xFFF5C5C5);
      case 'bottoms':   return const Color(0xFFBDD8C0);
      case 'dress':     return const Color(0xFFB8CEDD);
      case 'outerwear': return const Color(0xFFF5E8C8);
      case 'shoes':     return const Color(0xFFF0EAF5);
      case 'bags':      return const Color(0xFFF5E8C8);
      default:          return const Color(0xFFF0EEE8);
    }
  }
}
