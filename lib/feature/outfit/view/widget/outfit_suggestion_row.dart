import 'package:flutter/material.dart';
import 'package:smart_closet_app/feature/outfit/view/widget/outfit_clothing_card.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class OutfitSuggestionRow extends StatelessWidget {
  const OutfitSuggestionRow({
    super.key,
    required this.items,
    this.styleTip,
    this.destinationCity,
  });

  final List<ClothingModel> items;
  final String? styleTip;
  final String? destinationCity;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (destinationCity != null) ...[
          _DestinationPill(city: destinationCity!),
          const SizedBox(height: AppSizes.xxs),
        ],
        SizedBox(
          height: AppSizes.maxiM + AppSizes.l,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSizes.xs),
            itemBuilder: (_, i) => OutfitClothingCard(item: items[i]),
          ),
        ),
        if (styleTip != null && styleTip!.isNotEmpty) ...[
          const SizedBox(height: AppSizes.xxs),
          Text(
            '💡 $styleTip',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ],
    );
  }
}

class _DestinationPill extends StatelessWidget {
  const _DestinationPill({required this.city});
  final String city;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s, vertical: AppSizes.xxs),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: AppRadius.allS,
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: AppSizes.s,
            color: AppColors.accentDark,
          ),
          const SizedBox(width: AppSizes.xxs),
          Text(
            city,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.accentDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
