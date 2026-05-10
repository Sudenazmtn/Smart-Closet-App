import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/extension/clothing_category_ext.dart';

class StatsNeverWornItem extends StatelessWidget {
  const StatsNeverWornItem({super.key, required this.item});
  final ClothingModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.xs),
      padding: AppPaddings.allS,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.allS,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.xl,
            height: AppSizes.xl,
            decoration: BoxDecoration(
              color: item.categoryColor,
              borderRadius: AppRadius.allXS,
            ),
            child: Center(
              child: Text(
                item.categoryEmoji,
                style: const TextStyle(fontSize: AppSizes.m),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTextStyles.headingSmall),
                Text(item.category, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
            size: AppSizes.m,
          ),
        ],
      ),
    );
  }
}
