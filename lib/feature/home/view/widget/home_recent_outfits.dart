import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_closet_app/feature/outfit/view/widget/outfit_detail_sheet.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/data/model/outfit_model.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/extension/clothing_category_ext.dart';

class HomeRecentOutfits extends StatelessWidget {
  const HomeRecentOutfits({super.key, required this.outfits});

  final List<OutfitModel> outfits;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => context.push(AppRoutes.savedOutfits),
          child: Row(
            children: [
              Text(
                LocaleKeys.statsRecentOutfits.tr(),
                style: AppTextStyles.headingSmall,
              ),
              const Spacer(),
              Text(
                LocaleKeys.statsRecentOutfitsSeeAll.tr(),
                style: AppTextStyles.buttonLink,
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: AppSizes.m,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        if (outfits.isEmpty)
          _EmptyState()
        else
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: outfits.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSizes.s),
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => showOutfitDetail(ctx, outfits[i]),
                child: _OutfitCard(outfit: outfits[i]),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.savedOutfits),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.m),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: AppRadius.allS,
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          LocaleKeys.statsRecentOutfitsEmpty.tr(),
          style: AppTextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _OutfitCard extends StatelessWidget {
  const _OutfitCard({required this.outfit});
  final OutfitModel outfit;

  @override
  Widget build(BuildContext context) {
    final items = outfit.itemsData ?? [];

    return Container(
      width: 130,
      padding: const EdgeInsets.all(AppSizes.xs),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.allS,
        border: Border.all(
          color: outfit.isFavorite
              ? AppColors.accent.withValues(alpha: 0.6)
              : AppColors.border,
          width: outfit.isFavorite ? 1.5 : 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item thumbnails
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      outfit.eventEmoji,
                      style: const TextStyle(fontSize: AppSizes.l),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.take(3).length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(right: AppSizes.xxxs),
                      child: _MiniThumb(item: items[i]),
                    ),
                  ),
          ),
          const SizedBox(height: AppSizes.xxxs),
          Row(
            children: [
              if (outfit.isFavorite)
                const Padding(
                  padding: EdgeInsets.only(right: AppSizes.xxxs),
                  child: Icon(
                    Icons.favorite_rounded,
                    size: AppSizes.xxs + AppSizes.xxxs,
                    color: Colors.red,
                  ),
                ),
              Expanded(
                child: Text(
                  // Descriptive label from extension
                  outfit.localizedEventLabel,
                  style: AppTextStyles.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            // Short date: dd.MM
            '${outfit.createdAt.day.toString().padLeft(2, '0')}.${outfit.createdAt.month.toString().padLeft(2, '0')}',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _MiniThumb extends StatelessWidget {
  const _MiniThumb({required this.item});
  final ClothingModel item;

  @override
  Widget build(BuildContext context) {
    if (item.imageUrl != null) {
      return ClipRRect(
        borderRadius: AppRadius.allXXXS,
        child: Image.network(
          '${ApiService.baseUrl}${item.imageUrl}',
          width: 44,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _EmojiBox(item: item),
        ),
      );
    }
    return _EmojiBox(item: item);
  }
}

class _EmojiBox extends StatelessWidget {
  const _EmojiBox({required this.item});
  final ClothingModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 56,
      decoration: BoxDecoration(
        color: item.categoryColor,
        borderRadius: AppRadius.allXXXS,
      ),
      child: Center(
        child: Text(
          item.categoryEmoji,
          style: const TextStyle(fontSize: AppSizes.m),
        ),
      ),
    );
  }
}
