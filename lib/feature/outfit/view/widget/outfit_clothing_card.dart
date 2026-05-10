import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/extension/clothing_category_ext.dart';

class OutfitClothingCard extends StatelessWidget {
  const OutfitClothingCard({super.key, required this.item});
  final ClothingModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.maxiS + AppSizes.xl,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: item.imageUrl != null
                    ? AppColors.backgroundCard
                    : item.categoryColor,
                borderRadius: AppRadius.allS,
                border: Border.all(color: AppColors.border),
              ),
              child: item.imageUrl != null
                  ? ClipRRect(
                      borderRadius: AppRadius.allS,
                      child: Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _EmojiContent(item: item),
                      ),
                    )
                  : _EmojiContent(item: item),
            ),
          ),
          const SizedBox(height: AppSizes.xxs),
          Text(
            item.name,
            style: AppTextStyles.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmojiContent extends StatelessWidget {
  const _EmojiContent({required this.item});
  final ClothingModel item;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        item.categoryEmoji,
        style: const TextStyle(fontSize: AppSizes.l),
      ),
    );
  }
}
