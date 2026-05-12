import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/extension/clothing_category_ext.dart';

class WardrobeGridCard extends StatelessWidget {
  const WardrobeGridCard({
    super.key,
    required this.item,
    this.onTap,
    this.onLongPress,
  });

  final ClothingModel item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          
          // Görsel varsa şeffaf, yoksa kategori rengi
          color: item.imageUrl != null ? Colors.transparent : item.categoryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: item.imageUrl != null
            ? _NetworkImage(
                imageUrl: item.imageUrl!,
                fallbackEmoji: item.categoryEmoji,
                name: item.name,
              )
            : _EmojiContent(emoji: item.categoryEmoji, name: item.name),
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
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        '${ApiService.baseUrl}$imageUrl',
        fit: BoxFit.contain,
        errorBuilder: (_,__,___) =>
          _EmojiContent(emoji: fallbackEmoji, name: name)
        
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
        Text(emoji, style: const TextStyle(fontSize: 40)),
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
