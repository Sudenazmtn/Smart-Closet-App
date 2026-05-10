import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/app_feature/nav_bar/nav_bar.dart';
import 'package:smart_closet_app/feature/stats/view/mixin/stats_mixin.dart';
import 'package:smart_closet_app/feature/stats/view/widget/stats_most_worn_item.dart';
import 'package:smart_closet_app/feature/stats/view/widget/stats_never_worn_item.dart';
import 'package:smart_closet_app/feature/stats/view/widget/stats_overview_card.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/outfit_provider.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/enums/outfit_status_enum.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> with StatsMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentLight,
      body: SafeArea(
        child: Column(
          children: [
            const _StatsHeader(),
            Expanded(
              child: Consumer<OutfitProvider>(
                builder: (context, outfit, _) {
                  if (outfit.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                      ),
                    );
                  }
                  if (outfit.status == OutfitStatus.error) {
                    return _StatsError(
                      message: outfit.errorMessage ?? '',
                      onRetry: onRetry,
                    );
                  }
                  if (outfit.stats == null) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                      ),
                    );
                  }
                  final stats = outfit.stats!;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatsOverviewCard(
                          totalItems: stats.totalItems,
                          totalOutfits: stats.totalOutfits,
                          neverWornCount: stats.neverWornCount,
                          itemsLabel: LocaleKeys.profileStatItems.tr(),
                          outfitsLabel: LocaleKeys.profileStatOutfits.tr(),
                          neverWornLabel: LocaleKeys.statsNeverWorn.tr(),
                        ),
                        if (stats.mostWorn.isNotEmpty) ...[
                          Padding(
                            padding: AppPaddings.horizontalM,
                            child: Text(
                              LocaleKeys.statsMostWorn.tr(),
                              style: AppTextStyles.headingSmall,
                            ),
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Padding(
                            padding: AppPaddings.horizontalM,
                            child: Column(
                              children: stats.mostWorn
                                  .map((item) => StatsMostWornItem(
                                        item: item,
                                        wornTimesLabel:
                                            LocaleKeys.statsWornTimes.tr(),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: AppSizes.m),
                        ],
                        if (stats.neverWorn.isNotEmpty) ...[
                          Padding(
                            padding: AppPaddings.horizontalM,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.statsNeverWorn.tr(),
                                  style: AppTextStyles.headingSmall,
                                ),
                                const SizedBox(height: AppSizes.xxs),
                                Text(
                                  LocaleKeys.statsNeverWornSub.tr(),
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Padding(
                            padding: AppPaddings.horizontalM,
                            child: Column(
                              children: stats.neverWorn
                                  .map((item) =>
                                      StatsNeverWornItem(item: item))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: AppSizes.m),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            const AppBottomNavBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: AppPaddings.allM,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textOnDark,
              size: AppSizes.m,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            LocaleKeys.statsTitle.tr(),
            style: AppTextStyles.headingOnDark,
          ),
        ],
      ),
    );
  }
}

class _StatsError extends StatelessWidget {
  const _StatsError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSizes.m),
          TextButton(
            onPressed: onRetry,
            child: Text(
              LocaleKeys.commonRetry.tr(),
              style: AppTextStyles.buttonLink,
            ),
          ),
        ],
      ),
    );
  }
}
