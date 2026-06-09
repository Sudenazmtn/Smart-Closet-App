import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_closet_app/product/data/model/stats_model.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class StatsWardrobeSuggestions extends StatelessWidget {
  const StatsWardrobeSuggestions({super.key, required this.suggestions});

  final List<WardrobeSuggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppPaddings.horizontalM,
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline_rounded,
                  size: AppSizes.m, color: AppColors.warning),
              const SizedBox(width: AppSizes.xxs),
              Text(LocaleKeys.statsSuggestions.tr(),
                  style: AppTextStyles.headingSmall),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        ...suggestions.map(
          (s) => Padding(
            padding: const EdgeInsets.only(
              left: AppSizes.m,
              right: AppSizes.m,
              bottom: AppSizes.xs,
            ),
            child: _SuggestionCard(suggestion: s),
          ),
        ),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.suggestion});
  final WardrobeSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final title = _title(suggestion.key);
    final desc  = _desc(suggestion.key);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.addClothing),
      child: Container(
        padding: AppPaddings.allS,
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: AppRadius.allS,
          border: Border.all(
            color: AppColors.warning.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Text(suggestion.emoji,
                style: const TextStyle(fontSize: AppSizes.l)),
            const SizedBox(width: AppSizes.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.headingSmall),
                  const SizedBox(height: AppSizes.xxxs),
                  Text(desc, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.add_circle_outline_rounded,
                size: AppSizes.m, color: AppColors.warning),
          ],
        ),
      ),
    );
  }

  String _title(String key) {
    const map = {
      'missing_tops':       LocaleKeys.statsSuggestionsMissingTops,
      'missing_bottoms':    LocaleKeys.statsSuggestionsMissingBottoms,
      'missing_shoes':      LocaleKeys.statsSuggestionsMissingShoes,
      'missing_outerwear':  LocaleKeys.statsSuggestionsMissingOuterwear,
      'missing_sneakers':   LocaleKeys.statsSuggestionsMissingSneakers,
      'missing_formal_top': LocaleKeys.statsSuggestionsMissingFormalTop,
      'missing_casual_top': LocaleKeys.statsSuggestionsMissingCasualTop,
      'low_variety':        LocaleKeys.statsSuggestionsLowVariety,
      'empty_wardrobe':     LocaleKeys.statsSuggestionsEmptyWardrobe,
    };
    return (map[key] ?? key).tr();
  }

  String _desc(String key) {
    const map = {
      'missing_tops':       LocaleKeys.statsSuggestionsMissingTopsDesc,
      'missing_bottoms':    LocaleKeys.statsSuggestionsMissingBottomsDesc,
      'missing_shoes':      LocaleKeys.statsSuggestionsMissingShoesDesc,
      'missing_outerwear':  LocaleKeys.statsSuggestionsMissingOuterwearDesc,
      'missing_sneakers':   LocaleKeys.statsSuggestionsMissingSneakersDesc,
      'missing_formal_top': LocaleKeys.statsSuggestionsMissingFormalTopDesc,
      'missing_casual_top': LocaleKeys.statsSuggestionsMissingCasualTopDesc,
      'low_variety':        LocaleKeys.statsSuggestionsLowVarietyDesc,
      'empty_wardrobe':     LocaleKeys.statsSuggestionsEmptyWardrobeDesc,
    };
    return (map[key] ?? key).tr();
  }
}
