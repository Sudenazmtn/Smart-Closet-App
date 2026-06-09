import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/outfit/view/widget/outfit_detail_sheet.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/outfit_provider.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/data/model/outfit_model.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/extension/clothing_category_ext.dart';

class SavedOutfitsView extends StatefulWidget {
  const SavedOutfitsView({super.key});

  @override
  State<SavedOutfitsView> createState() => _SavedOutfitsViewState();
}

class _SavedOutfitsViewState extends State<SavedOutfitsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    if (!mounted) return;
    await context.read<OutfitProvider>().loadOutfitsSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentLight,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: AppSizes.m, color: AppColors.textOnDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          LocaleKeys.statsSavedOutfitsTitle.tr(),
          style: AppTextStyles.headingOnDark,
        ),
      ),
      body: Consumer<OutfitProvider>(
        builder: (context, provider, _) {
          final outfits = provider.outfits;

          if (outfits.isEmpty) {
            return Center(
              child: Padding(
                padding: AppPaddings.allL,
                child: Text(
                  LocaleKeys.statsRecentOutfitsEmpty.tr(),
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: AppPaddings.allM,
            itemCount: outfits.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSizes.s),
            itemBuilder: (ctx, i) => GestureDetector(
              onTap: () => showOutfitDetail(ctx, outfits[i]).then((_) {
                // Refresh after possible delete/favorite change
                if (mounted) setState(() {});
              }),
              child: _SavedOutfitCard(outfit: outfits[i]),
            ),
          );
        },
      ),
    );
  }
}

// ─── Full-width outfit card ───────────────────────────────────────────────────

class _SavedOutfitCard extends StatelessWidget {
  const _SavedOutfitCard({required this.outfit});
  final OutfitModel outfit;

  @override
  Widget build(BuildContext context) {
    final items = outfit.itemsData ?? [];

    return Container(
      padding: AppPaddings.allS,
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
          // Header row
          Row(
            children: [
              Text(outfit.eventEmoji,
                  style: const TextStyle(fontSize: AppSizes.l)),
              const SizedBox(width: AppSizes.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      outfit.name ?? outfit.localizedEventLabel,
                      style: AppTextStyles.headingSmall,
                    ),
                    Text(outfit.formattedDate,
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              if (outfit.isFavorite)
                const Icon(Icons.favorite_rounded,
                    size: AppSizes.m, color: Colors.red),
              const SizedBox(width: AppSizes.xxs),
              const Icon(Icons.chevron_right_rounded,
                  size: AppSizes.l, color: AppColors.border),
            ],
          ),

          // Item thumbnails
          if (items.isNotEmpty) ...[
            const SizedBox(height: AppSizes.xs),
            SizedBox(
              height: AppSizes.maxiS + AppSizes.xs,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSizes.xxs),
                itemBuilder: (_, i) => _Thumb(item: items[i]),
              ),
            ),
          ],

          // AI note preview
          if (outfit.aiNote != null && outfit.aiNote!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.xxs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    size: AppSizes.xs, color: AppColors.accent),
                const SizedBox(width: AppSizes.xxxs),
                Expanded(
                  child: Text(
                    outfit.aiNote!,
                    style: AppTextStyles.bodyAiNote,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          // Item count if no data
          if (items.isEmpty) ...[
            const SizedBox(height: AppSizes.xxs),
            Text('${outfit.items.length} parça',
                style: AppTextStyles.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.item});
  final ClothingModel item;

  @override
  Widget build(BuildContext context) {
    const w = AppSizes.maxiS;
    const h = AppSizes.maxiS + AppSizes.xs;
    if (item.imageUrl != null) {
      return ClipRRect(
        borderRadius: AppRadius.allXXS,
        child: Image.network(
          '${ApiService.baseUrl}${item.imageUrl}',
          width: w,
          height: h,
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
