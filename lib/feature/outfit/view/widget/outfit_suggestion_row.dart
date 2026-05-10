import 'package:flutter/material.dart';
import 'package:smart_closet_app/feature/outfit/view/widget/outfit_clothing_card.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class OutfitSuggestionRow extends StatelessWidget {
  const OutfitSuggestionRow({
    super.key,
    required this.items,
    this.styleTip,
  });

  final List<ClothingModel> items;
  final String? styleTip;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
