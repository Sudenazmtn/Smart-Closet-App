import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_closet_app/feature/outfit/view/widget/outfit_detail_sheet.dart';
import 'package:smart_closet_app/product/data/model/outfit_model.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';
import 'package:smart_closet_app/product/utils/extension/clothing_category_ext.dart';

class StatsOutfitHistory extends StatelessWidget {
  const StatsOutfitHistory({super.key, required this.outfits});

  final List<OutfitModel> outfits;

  @override
  Widget build(BuildContext context) {
    if (outfits.isEmpty) {
      return Padding(
        padding: AppPaddings.horizontalM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocaleKeys.statsOutfitHistory.tr(),
                style: AppTextStyles.headingSmall),
            const SizedBox(height: AppSizes.xs),
            Center(
              child: Text(
                LocaleKeys.statsOutfitHistoryEmpty.tr(),
                style: AppTextStyles.bodySmall,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppPaddings.horizontalM,
          child: Text(LocaleKeys.statsOutfitHistory.tr(),
              style: AppTextStyles.headingSmall),
        ),
        const SizedBox(height: AppSizes.xs),
        ...outfits.map(
          (o) => Padding(
            padding: const EdgeInsets.only(
              left: AppSizes.m,
              right: AppSizes.m,
              bottom: AppSizes.xs,
            ),
            child: GestureDetector(
              onTap: () => showOutfitDetail(context, o),
              child: _OutfitHistoryCard(outfit: o),
            ),
          ),
        ),
      ],
    );
  }
}

class _OutfitHistoryCard extends StatelessWidget {
  const _OutfitHistoryCard({required this.outfit});
  final OutfitModel outfit;

  @override
  Widget build(BuildContext context) {
    final itemsData = outfit.itemsData ?? [];
    final dateStr = outfit.formattedDate;

    return Container(
      padding: AppPaddings.allS,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.allS,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (outfit.isFavorite)
                const Padding(
                  padding: EdgeInsets.only(right: AppSizes.xxs),
                  child: Icon(Icons.favorite_rounded,
                      size: AppSizes.s, color: Colors.red),
                ),
              Expanded(
                child: Text(
                  outfit.name ?? outfit.localizedEventLabel,
                  style: AppTextStyles.headingSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(dateStr, style: AppTextStyles.bodySmall),
            ],
          ),
          if (itemsData.isNotEmpty) ...[
            const SizedBox(height: AppSizes.xs),
            SizedBox(
              height: AppSizes.maxiS + AppSizes.xs,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: itemsData.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSizes.xxs),
                itemBuilder: (_, i) => _ItemThumb(item: itemsData[i]),
              ),
            ),
          ] else ...[
            const SizedBox(height: AppSizes.xxs),
            Text(
              '${outfit.items.length} parça',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

}

class _ItemThumb extends StatelessWidget {
  const _ItemThumb({required this.item});
  final ClothingModel item;

  @override
  Widget build(BuildContext context) {
    if (item.imageUrl != null) {
      return ClipRRect(
        borderRadius: AppRadius.allXXS,
        child: Image.network(
          '${ApiService.baseUrl}${item.imageUrl}',
          width: AppSizes.maxiS,
          height: AppSizes.maxiS + AppSizes.xs,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _EmojiThumb(item: item),
        ),
      );
    }
    return _EmojiThumb(item: item);
  }
}

class _EmojiThumb extends StatelessWidget {
  const _EmojiThumb({required this.item});
  final ClothingModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.maxiS,
      height: AppSizes.maxiS + AppSizes.xs,
      decoration: BoxDecoration(
        color: item.categoryColor,
        borderRadius: AppRadius.allXXS,
      ),
      child: Center(
        child: Text(item.categoryEmoji,
            style: const TextStyle(fontSize: AppSizes.emojiS)),
      ),
    );
  }
}
