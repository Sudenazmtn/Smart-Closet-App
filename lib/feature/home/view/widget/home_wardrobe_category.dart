import 'package:flutter/material.dart';

import 'home_category_card.dart';

class HomeCategoryData {
  const HomeCategoryData({
    required this.label,
    required this.emoji,
    required this.color,
    required this.filter,
  });

  final String label;
  final String emoji;
  final Color color;
  final String filter;
}

class HomeWardrobeCategories extends StatelessWidget {
  const HomeWardrobeCategories({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  final List<HomeCategoryData> categories;
  final void Function(String filter) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories
          .map(
            (cat) => HomeCategoryCard(
              label: cat.label,
              emoji: cat.emoji,
              color: cat.color,
              onTap: () => onCategoryTap(cat.filter),
            ),
          )
          .toList(),
    );
  }
}
