import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/clothing_provider.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';

import 'wardrobe_grid_card.dart';

class WardrobeGrid extends StatelessWidget {
  const WardrobeGrid({
    super.key,
    required this.items,
    this.onItemTap,
    this.onItemLongPress,
  });

  final List<ClothingModel> items;
  final void Function(ClothingModel)? onItemTap;
  final void Function(ClothingModel)? onItemLongPress;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return WardrobeGridCard(
          item: item,
          onTap: onItemTap != null ? () => onItemTap!(item) : null,
          onLongPress: onItemLongPress != null ? () => onItemLongPress!(item) : null,
          onFavoriteToggle: () =>
              context.read<ClothingProvider>().toggleFavorite(item.id),
        );
      },
    );
  }
}
