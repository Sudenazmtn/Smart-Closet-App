import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/home/provider/weather_provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/clothing_provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/outfit_provider.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_emojis.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/extension/clothing_category_ext.dart';

class HomeTodaysOutfitCard extends StatefulWidget {
  const HomeTodaysOutfitCard({super.key, this.isLoading = false});

  final bool isLoading;

  @override
  State<HomeTodaysOutfitCard> createState() => _HomeTodaysOutfitCardState();
}

class _HomeTodaysOutfitCardState extends State<HomeTodaysOutfitCard>
    with SingleTickerProviderStateMixin {
  bool _refreshing = false;
  late AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    _spin.repeat();

    final weather = context.read<WeatherProvider>().weather;
    await context.read<OutfitProvider>().sendMessage(
          userText:           LocaleKeys.homeAiButtonSub.tr(),
          aiErrorText:        LocaleKeys.outfitAiError.tr(),
          temperature:        weather?.temperature.toDouble(),
          weatherDescription: weather?.description,
        );

    _spin.stop();
    _spin.reset();
    if (mounted) setState(() => _refreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(LocaleKeys.homeSectionOutfit.tr(),
                style: AppTextStyles.headingSmall),
            const Spacer(),
            GestureDetector(
              onTap: _refresh,
              child: AnimatedBuilder(
                animation: _spin,
                builder: (_, child) => Transform.rotate(
                  angle: _spin.value * 6.28318,
                  child: child,
                ),
                child: Icon(
                  Icons.refresh_rounded,
                  size: AppSizes.m,
                  color: _refreshing ? AppColors.accent : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.s),
        Consumer2<OutfitProvider, ClothingProvider>(
          builder: (context, outfit, clothing, _) {
            if (widget.isLoading || _refreshing) {
              return const _CardShell(label: null, child: _LoadingState());
            }

            final aiItems =
                outfit.lastAiItems.whereType<ClothingModel>().toList();
            final score = outfit.lastAiScore;
            final tip   = outfit.lastAiNote;

            // ── AI suggestion ─────────────────────────────────────────────
            if (aiItems.isNotEmpty) {
              return _CardShell(
                label: LocaleKeys.homeOutfitLabelAi.tr(),
                child: _OutfitContent(
                  items:        aiItems,
                  score:        score,
                  tip:          tip,
                  isSuggestion: true,
                ),
              );
            }
            final mostWorn = clothing.mostWorn.take(3).toList();
            if (mostWorn.isNotEmpty) {
              return _CardShell(
                label: LocaleKeys.homeOutfitLabelMostWorn.tr(),
                child: _OutfitContent(
                  items:        mostWorn,
                  score:        null,
                  tip:          null,
                  isSuggestion: false,
                ),
              );
            }
            final recent = clothing.items.take(3).toList();
            if (recent.isNotEmpty) {
              return _CardShell(
                label: LocaleKeys.homeOutfitLabelRecent.tr(),
                child: _OutfitContent(
                  items:        recent,
                  score:        null,
                  tip:          LocaleKeys.homeNoSuggestionTip.tr(),
                  isSuggestion: false,
                ),
              );
            }
            return _CardShell(
              label: null,
              child: _EmptyState(onTap: () => context.go(AppRoutes.outfit)),
            );
          },
        ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child, required this.label});

  final Widget child;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPaddings.allM,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.allM,
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            _StateChip(label: label!),
            const SizedBox(height: AppSizes.xs),
          ],
          child,
        ],
      ),
    );
  }
}

class _StateChip extends StatelessWidget {
  const _StateChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xs, vertical: AppSizes.xxxs),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.allXXS,
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _OutfitContent extends StatefulWidget {
  const _OutfitContent({
    required this.items,
    required this.score,
    required this.tip,
    required this.isSuggestion,
  });

  final List<ClothingModel> items;
  final double? score;
  final String? tip;
  final bool isSuggestion;

  @override
  State<_OutfitContent> createState() => _OutfitContentState();
}

class _OutfitContentState extends State<_OutfitContent> {
  bool _wearing = false;
  bool _worn    = false;

  Future<void> _markWorn() async {
    if (_wearing || _worn) return;
    setState(() => _wearing = true);

    final clothing = context.read<ClothingProvider>();
    for (final item in widget.items) {
      await clothing.markAsWorn(item.id);
    }

    if (mounted) setState(() { _wearing = false; _worn = true; });
  }
  @override
  void didUpdateWidget(_OutfitContent old) {
    super.didUpdateWidget(old);
    if (old.items != widget.items) setState(() => _worn = false);
  }

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
                children: widget.items
                    .take(3)
                    .map((i) => _ItemThumb(item: i))
                    .toList(),
              ),
            ),
            if (widget.score != null) ...[
              const SizedBox(width: AppSizes.xs),
              _MatchBadge(percent: (widget.score! * 100).round()),
            ],
          ],
        ),
        if (widget.tip != null && widget.tip!.isNotEmpty) ...[
          const SizedBox(height: AppSizes.xs),
          Text(
            widget.tip!,
            style: AppTextStyles.bodyAiNote,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ] else if (!widget.isSuggestion) ...[
          const SizedBox(height: AppSizes.xs),
          Text(LocaleKeys.statsMostWorn.tr(),
              style: AppTextStyles.bodySmall),
        ],

        const SizedBox(height: AppSizes.s),
        if (widget.items.isNotEmpty)
          _WearButton(
            wearing: _wearing,
            worn:    _worn,
            onTap:   _markWorn,
          ),
      ],
    );
  }
}

class _WearButton extends StatelessWidget {
  const _WearButton({
    required this.wearing,
    required this.worn,
    required this.onTap,
  });

  final bool wearing;
  final bool worn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
            vertical: AppSizes.xxs + AppSizes.xxxs,
            horizontal: AppSizes.xs),
        decoration: BoxDecoration(
          color: worn
              ? AppColors.success.withValues(alpha: 0.12)
              : AppColors.primary,
          borderRadius: AppRadius.allXXS,
          border: worn
              ? Border.all(color: AppColors.success, width: 0.8)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (wearing)
              const SizedBox(
                width: AppSizes.s,
                height: AppSizes.s,
                child: CircularProgressIndicator(
                    strokeWidth: 1.5, color: AppColors.textOnDark),
              )
            else
              Icon(
                worn
                    ? Icons.check_circle_rounded
                    : Icons.checkroom_outlined,
                size: AppSizes.s,
                color: worn ? AppColors.success : AppColors.textOnDark,
              ),
            const SizedBox(width: AppSizes.xxxs),
            Text(
              worn
                  ? LocaleKeys.homeWearTodayDone.tr()
                  : LocaleKeys.homeWearToday.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: worn ? AppColors.success : AppColors.textOnDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
        borderRadius: AppRadius.allSoft,
        child: Image.network(
          '${ApiService.baseUrl}${item.imageUrl}',
          width: 60,
          height: 60,
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
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: item.categoryColor,
        borderRadius: AppRadius.allSoft,
      ),
      child: Center(
        child: Text(item.categoryEmoji,
            style: const TextStyle(fontSize: AppSizes.emojiS)),
      ),
    );
  }
}

class _MatchBadge extends StatelessWidget {
  const _MatchBadge({required this.percent});
  final int percent;

  Color get _color {
    if (percent >= 75) return AppColors.success;
    if (percent >= 50) return AppColors.warning;
    return const Color(0xFFD97706); // amber-ish
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xs, vertical: AppSizes.xxs + AppSizes.xxxs),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: AppRadius.allSoft,
        border: Border.all(color: _color.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$percent%',
            style: AppTextStyles.matchBadgePercent.copyWith(color: _color),
          ),
          Text(
            LocaleKeys.homeMatchLabel.tr(),
            style: AppTextStyles.labelTag.copyWith(color: _color),
          ),
        ],
      ),
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
          const Text(AppEmojis.sparkle,
              style: TextStyle(fontSize: AppSizes.emojiL)),
          const SizedBox(height: AppSizes.xs),
          Text(LocaleKeys.homeEmptyOutfitTitle.tr(),
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center),
          const SizedBox(height: AppSizes.xxs),
          Text(LocaleKeys.homeEmptyOutfitSub.tr(),
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center),
          const SizedBox(height: AppSizes.s),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.m, vertical: AppSizes.xs),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.pill,
            ),
            child: Text(
              LocaleKeys.homeAskAiButton.tr(),
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


class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: AppPaddings.allM,
        child: CircularProgressIndicator(
            color: AppColors.accent, strokeWidth: 2),
      ),
    );
  }
}
