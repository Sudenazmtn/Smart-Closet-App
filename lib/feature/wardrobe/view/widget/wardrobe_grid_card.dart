import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/extension/clothing_category_ext.dart';

class WardrobeGridCard extends StatelessWidget {
  const WardrobeGridCard({
    super.key,
    required this.item,
    this.onTap,
    this.onLongPress,
    this.onFavoriteToggle,
  });

  final ClothingModel item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: item.imageUrl != null ? Colors.transparent : item.categoryColor,
              borderRadius: AppRadius.allM,
            ),
            child: item.imageUrl != null
                ? _NetworkImage(
                    imageUrl: item.imageUrl!,
                    fallbackEmoji: item.categoryEmoji,
                    name: item.name,
                  )
                : _EmojiContent(emoji: item.categoryEmoji, name: item.name),
          ),
          Positioned(
            top: AppSizes.xxs,
            right: AppSizes.xxs,
            child: GestureDetector(
              onTap: onFavoriteToggle,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: AppSizes.l + AppSizes.xxs,
                height: AppSizes.l + AppSizes.xxs,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: AppSizes.m,
                  color: item.isFavorite ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  const _NetworkImage({
    required this.imageUrl,
    required this.fallbackEmoji,
    required this.name,
  });

  final String imageUrl;
  final String fallbackEmoji;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.allM,
      child: Image.network(
        '${ApiService.baseUrl}$imageUrl',
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) =>
            _EmojiContent(emoji: fallbackEmoji, name: name),
      ),
    );
  }
}

class _EmojiContent extends StatelessWidget {
  const _EmojiContent({required this.emoji, required this.name});

  final String emoji;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: AppSizes.xxl)),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall,
          ),
        ),
      ],
    );
  }
}
