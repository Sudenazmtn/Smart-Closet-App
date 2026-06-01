import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/clothing_provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/outfit_provider.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/extension/clothing_category_ext.dart';

class HomeTodaysOutfitCard extends StatelessWidget {
  const HomeTodaysOutfitCard({super.key, this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.homeSectionOutfit.tr(),
          style: AppTextStyles.headingSmall,
        ),
        const SizedBox(height: 12),
        Consumer2<OutfitProvider, ClothingProvider>(
          builder: (context, outfit, clothing, _) {
            if (isLoading) {
              return const _CardShell(child: _LoadingState());
            }

            final aiItems = outfit.lastAiItems
                .whereType<ClothingModel>()
                .toList();
            final score = outfit.lastAiScore;
            final tip   = outfit.lastAiNote;

            if (aiItems.isNotEmpty) {
              return _CardShell(
                child: _OutfitContent(
                  items: aiItems,
                  score: score,
                  tip: tip,
                ),
              );
            }

            final mostWorn = clothing.mostWorn.take(3).toList();
            if (mostWorn.isNotEmpty) {
              return _CardShell(
                child: _OutfitContent(
                  items: mostWorn,
                  score: null,
                  tip: null,
                  isSuggestion: false,
                ),
              );
            }

            // Hiç giyilmemiş ama kıyafet var → son eklenenlerden göster
            final recent = clothing.items.take(3).toList();
            if (recent.isNotEmpty) {
              return _CardShell(
                child: _OutfitContent(
                  items: recent,
                  score: null,
                  tip: 'Henüz kombin önerisi yok. AI\'a sor!',
                  isSuggestion: false,
                ),
              );
            }

            return _CardShell(
              child: _EmptyState(onTap: () => context.go(AppRoutes.outfit)),
            );
          },
        ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: child,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          const Text('✨', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(
            'AI\'dan kombin önerisi al',
            style: AppTextStyles.headingSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Gardırobuna göre en iyi kombini seçelim',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'AI\'a Sor →',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutfitContent extends StatelessWidget {
  const _OutfitContent({
    required this.items,
    required this.score,
    required this.tip,
    this.isSuggestion = true,
  });

  final List<ClothingModel> items;
  final double? score;
  final String? tip;
  final bool isSuggestion;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: items.take(3).map((i) => _ItemThumb(item: i)).toList(),
              ),
            ),
            if (score != null) ...[
              const SizedBox(width: 8),
              _MatchBadge(percent: (score! * 100).round()),
            ],
          ],
        ),
        const SizedBox(height: 10),
        if (tip != null && tip!.isNotEmpty)
          Text(tip!, style: AppTextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis)
        else if (!isSuggestion)
          Text('En çok giydiğin parçalar', style: AppTextStyles.bodySmall),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => context.go(AppRoutes.outfit),
          child: Text(
            isSuggestion ? 'Farklı kombin iste →' : 'AI\'dan kombin al →',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
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
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          '${ApiService.baseUrl}${item.imageUrl}',
          width: 60, height: 60, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _EmojiThumb(item: item),
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
      width: 60, height: 60,
      decoration: BoxDecoration(
        color: item.categoryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(item.categoryEmoji, style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}

class _MatchBadge extends StatelessWidget {
  const _MatchBadge({required this.percent});
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$percent%', style: const TextStyle(fontFamily: 'DMSans', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          Text(
            LocaleKeys.homeMatchLabel.tr(),
            style: const TextStyle(fontFamily: 'DMSans', fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2),
      ),
    );
  }
}
